#! /usr/bin/python2
from functools import partial

from flask import Blueprint, abort, Flask, render_template, flash, request, send_from_directory
from flask_bootstrap import Bootstrap
from flask_appconfig import AppConfig

from urllib import unquote

from urllib import quote, unquote
from json import dumps, loads

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
    blueprint = Blueprint("NeverWhere",__name__, template_folder="templates")

    @blueprint.route('/favicon.ico')
    #def favicon():
        #return send_from_directory("/srv/http/goal/favicon.ico",
                                   #'favicon.ico', mimetype='image/vnd.microsoft.icon')

    @blueprint.route("/", methods=("GET", "POST"))
    def index():
        return render_template("index.html")

    @blueprint.route("./scripts/<filename>")
    def send_script(filename):
        return send_from_directory(app.config["scripts"], filename)

    @blueprint.route("./styles/<filename>")
    def send_style(filename):
        return send_from_directory(app.config["styles"], filename)

    app = Flask(__name__)
    app.register_blueprint(blueprint, url_prefix="/")
    Bootstrap(app)
    app.config["scripts"] = "./scripts"
    app.config["styles"] = "./styles"
    return app

app = NeverWhere()

if __name__ == "__main__":
    NeverWhere("./appconfig").run(host="localhost", port=8001, debug=True)
