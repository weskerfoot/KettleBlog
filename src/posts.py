#! /usr/bin/python

import couchdb
from flask import jsonify
from flask_marshmallow import Marshmallow

class Posts:
    def __init__(self, host=None, port=None):
        if host is None:
            host = "localhost"
        if port is None:
            port = "5984"

        self.client = couchdb.Server("http://%s:%s" % (host, port))

        self.db = self.client["blog"]

    def savepost(self, title="", content="", author="", _id=False):
        if _id:
            doc = self.db[_id]
            doc["title"] = title
            doc["content"] = content
            doc["author"] = author
        else:
            doc = {
                    "title" : title,
                    "content" : content,
                    "author" : author
                    }

        return jsonify(self.db.save(doc))

    def getposts(self, limit, start):
        result = self.db.iterview("blogPosts/blog-posts", 10, include_docs=True, limit=limit, skip=start)
        return jsonify(list(result))

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

    def getpost(self, _id):
        return jsonify(self.db[_id])
