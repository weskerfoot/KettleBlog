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

    def savepost(self, title, content, author):
        doc = {
                "title" : title,
                "content" : content,
                "author" : author
                }
        return jsonify(self.db.save(doc))

    def getposts(self, start, end):
        return jsonify([])

    def getcomments(self, postID):
        return jsonify([])
