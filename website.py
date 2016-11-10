#! /usr/bin/python2
from functools import partial

from flask import abort, Flask, render_template, flash, request, send_from_directory
from flask_bootstrap import Bootstrap
from flask_appconfig import AppConfig

from time import sleep

from urllib import unquote

from urllib import quote, unquote
from json import dumps, loads

from comment import testcomments

from werkzeug.contrib.cache import MemcachedCache
cache = MemcachedCache(['127.0.0.1:11211'])

import os

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
    #def favicon():
        #return send_from_directory("/srv/http/goal/favicon.ico",
                                   #'favicon.ico', mimetype='image/vnd.microsoft.icon')

    @app.route("/", methods=("GET", "POST"))
    def index():
        print "matched index"
        return render_template("index.html")

    @app.route("/scripts/<filename>", methods=("GET", "POST"))
    def send_script(filename):
        print "matched scripts route"
        return send_from_directory("/home/wes/riotblog/scripts/", filename)

    @app.route("/styles/<filename>", methods=("GET", "POST"))
    def send_style(filename):
        return send_from_directory("./styles", filename)

    @app.route("/switchpost/<pid>")
    def switchPost(pid):
        posts = {
                    "1" : "Post one is changed! ",
                    "2" : "Post two here! "
                }
        return posts.get(pid, "false")


    @app.route("/comments/<pid>")
    def comments(pid):
        sleep(5);
        try:
            return testcomments.get(int(pid), dumps([]))
        except ValueError as e:
            print e
            return dumps([])


    @app.route("/<path:path>")
    def page_not_found(path):
        return "Custom failure message"

    Bootstrap(app)
    app.run(debug=True)
    return app

app = NeverWhere()

if __name__ == "__main__":
    NeverWhere("./appconfig").run(host="localhost", port=8001, debug=True)
