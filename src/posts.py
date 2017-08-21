#! /usr/bin/python

import couchdb
import mistune

from werkzeug.local import Local, LocalProxy, LocalManager
from couchdb.http import ResourceConflict, ResourceNotFound
from flask import jsonify, g
from flask_marshmallow import Marshmallow
from itertools import chain

def get_mistune():
    markdown = getattr(g, "markdown", None)
    if markdown is None:
        markdown = g._markdown = mistune.Markdown()
    return markdown

markdown = LocalProxy(get_mistune)

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
            doc["_id"] = _id
        else:
            doc = {
                    "title" : title,
                    "content" : content,
                    "author" : author,
                    "category" : category,
                    "type" : "post"
                    }


        print("post was saved %s" % doc)
        return jsonify(self.db.save(doc))

    def getpost(self, _id, json=True, convert=True):
        results = self.db.iterview("blogPosts/blog-posts", 1, include_docs=True, startkey=_id)

        post = [result.doc for result in results][0]

        post["content"] = markdown(post["content"]) if convert else post["content"]

        return jsonify(post) if json else post

    def getinitial(self):
        results = list(self.db.iterview("blogPosts/blog-posts", 2, include_docs=True))

        post = [result.doc for result in results][0]

        post["content"] = markdown(post["content"])

        return post

    def iterpost(self, endkey=False, startkey=False, category="programming"):
        if startkey and not endkey:
            results = self.db.iterview("blogPosts/blog-posts", 2, include_docs=True, startkey=startkey)
        elif endkey and not startkey:
            results = self.db.iterview("blogPosts/blog-posts", 1, include_docs=True, endkey=endkey)
        else:
            results = self.db.iterview("blogPosts/blog-posts", 2, include_docs=True)

        docs = [result.doc for result in results]

        for doc in docs:
            doc["content"] = markdown(doc["content"])

        if not docs:
            return jsonify("end")

        if endkey and not startkey:
            if len(docs) < 2 or docs[0] == endkey:
                return jsonify("start")
            return jsonify(docs[-2])

        if len(docs) == 1:
            return jsonify(docs[0])

        if docs:
            # if no startkey or endkey were specified, return the 0th post
            return jsonify(docs[1 if startkey else 0])

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

    def links(self, json=True):
        result = list(self.db.iterview("blogPosts/links", 1, include_docs=True))
        if len(result) >= 1:
            xs = result[0].doc.get("links", [])
            return jsonify(xs) if json else xs
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
        return list(set(chain.from_iterable([
                    c["key"][1] for c in
                        self.db.view("blogPosts/categories",
                                     startkey=["categories"],
                                     endkey=["categories", {}],
                                     inclusive_end=False,
                                     reduce=True,
                                     group_level=2,
                                     group=True)
                ])))

