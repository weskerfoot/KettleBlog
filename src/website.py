#! /usr/bin/python3
from functools import partial

from flask import abort, Flask, render_template, flash, request, send_from_directory, jsonify
from werkzeug.local import Local, LocalProxy, LocalManager
from flask_appconfig import AppConfig

from urllib.parse import unquote
from urllib.parse import quote, unquote
from json import dumps, loads

from werkzeug.contrib.cache import MemcachedCache
cache = MemcachedCache(['127.0.0.1:11211'])

import os

from posts import Posts
from projects import getProjects

posts = Posts()

def cacheit(key, thunk):
    """
    Tries to find a cached version of ``key''
    If there is no cached version then it will
    evaluate thunk (which must be a generator)
    and cache that, then return the result
    """
    cached = cache.get(quote(key))
    if cached is None:
        result = list(thunk())
        cache.set(quote(key), result)
        return result
    return cached

def NeverWhere(configfile=None):
    app = Flask(__name__)
    app.config["TEMPLATES_AUTO_RELOAD"] = True
    app.config["COUCHDB_SERVER"] = "http://localhost:5984"
    app.config["COUCHDB_DATABASE"] = "blog"
    #def favicon():
        #return send_from_directory("/srv/http/goal/favicon.ico",
                                   #'favicon.ico', mimetype='image/vnd.microsoft.icon')

    @app.route("/blog/projects", methods=("GET",))
    def projects():
        return jsonify(cacheit("projects", getProjects))

    @app.route("/blog/stuff", methods=("GET",))
    def stuff():
        return render_template("projects.html")

    @app.route("/blog/", methods=("GET", "POST"))
    def index():
        print("matched index")
        return render_template("index.html")

    @app.route("/blog/editor/", methods=("GET", "POST"))
    def editor():
        return render_template("write.html")

    @app.route("/blog/scripts/<filename>", methods=("GET", "POST"))
    def send_script(filename):
        print("matched scripts route")
        return send_from_directory("/srv/http/riotblog/scripts", filename)

    @app.route("/blog/styles/<filename>", methods=("GET", "POST"))
    def send_style(filename):
        return send_from_directory("/srv/http/riotblog/styles", filename)

    @app.route("/blog/insert/", methods=("POST",))
    def insert():
        print("XXX")
        print(request.form)
        return posts.savepost(**request.form)

    @app.route("/blog/switchpost/<pid>")
    def getposts(pid):
        try:
            index = int(pid)
        except ValueError:
            index = 0
        return posts.getposts(index+1, index)

    @app.route("/<path:path>")
    def page_not_found(path):
        return "Oops, couldn't find that :/"

    return app

app = NeverWhere()

if __name__ == "__main__":
    NeverWhere("./appconfig").run(host="localhost", port=8001, debug=True)
