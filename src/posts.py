#! /usr/bin/python

import couchdb

from couchdb.http import ResourceConflict, ResourceNotFound
from flask import jsonify
from flask_marshmallow import Marshmallow

class Posts:
    def __init__(self, user, password, host=None, port=None):
        if host is None:
            host = "localhost"
        if port is None:
            port = "5984"

        self.client = couchdb.Server("http://%s:%s" % (host, port))

        self.client.credentials = (user, password)

        self.db = self.client["blog"]

    def savepost(self, title="", content="", author="", category="programming", _id=False):
        if _id:
            doc = self.db[_id]
            doc["title"] = title
            doc["content"] = content
            doc["author"] = author
            doc["category"] = category
        else:
            doc = {
                    "title" : title,
                    "content" : content,
                    "author" : author,
                    "type" : "post"
                    }

        print("post was saved %s" % doc)
        return jsonify(self.db.save(doc))

    def getpost(self, _id, category="programming", json=True):
        results = self.db.iterview("blogPosts/blog-posts", 1, include_docs=True, startkey=_id)

        post = [result.doc for result in results][0]
        return jsonify(post) if json else post

    def getinitial(self):
        results = list(self.db.iterview("blogPosts/blog-posts", 2, include_docs=True))
        return [result.doc for result in results][0]

    def iterpost(self, endkey=False, startkey=False, category="programming"):
        if startkey and not endkey:
            results = self.db.iterview("blogPosts/blog-posts", 2, include_docs=True, startkey=startkey)
        elif endkey and not startkey:
            results = self.db.iterview("blogPosts/blog-posts", 1, include_docs=True, endkey=endkey)
        else:
            results = self.db.iterview("blogPosts/blog-posts", 2, include_docs=True)

        doc_ids = [result.doc for result in results]

        if not doc_ids:
            return jsonify("end")

        if endkey and not startkey:
            if len(doc_ids) < 2 or doc_ids[0] == endkey:
                return jsonify("start")
            return jsonify(doc_ids[-2])

        if len(doc_ids) == 1:
            return jsonify(doc_ids[0])

        if doc_ids:
            # if no startkey or endkey were specified, return the 0th post
            return jsonify(doc_ids[1 if startkey else 0])

        return jsonify("end")

    def allposts(self):
        result = self.db.iterview("blogPosts/blog-posts", 10, include_docs=True)

        posts = []
        for item in result:
            posts.append({
                            "_id" : item.doc["_id"],
                            "title" : item.doc["title"],
                            "author" : item.doc["author"]
                        })

        return jsonify(posts)

    def links(self):
        result = list(self.db.iterview("blogPosts/links", 1, include_docs=True))
        if len(result) >= 1:
            return jsonify(result[0].doc.get("links", []))
        return []

    def delete(self, _id):
        doc = self.db[_id]
        try:
            self.db.delete(doc)
            return jsonify(True)
        except (ResourceNotFound, ResourceConflict) as e:
            print(e)
            return jsonify(False)

    def categories(self):
        return jsonify(
                [
                    c["key"][1] for c in
                        self.db.view("blogPosts/categories",
                                     startkey=["category"],
                                     endkey=["category", {}],
                                     inclusive_end=False,
                                     reduce=True,
                                     group_level=2,
                                     group=True)
                ]
            )

