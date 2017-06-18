#! /usr/bin/python3
from functools import partial

from flask import abort, Flask, render_template, flash, request, send_from_directory, jsonify
from werkzeug.local import Local, LocalProxy, LocalManager
from flask_appconfig import AppConfig
from flask_login import LoginManager, login_required, login_user
from flask_wtf.csrf import CSRFProtect

from urllib.parse import unquote
from urllib.parse import quote, unquote
from json import dumps, loads

from admin import Admin

from werkzeug.contrib.cache import MemcachedCache
cache = MemcachedCache(['127.0.0.1:11211'])

import os

from posts import Posts
from projects import getProjects

posts = Posts()
login_manager = LoginManager()

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

    @login_manager.user_loader
    def load_user(user_id):
        return Admin

    @app.route("/blog/admin_login", methods=("GET", "POST"))
    def admin_login():
        password = request.args.get("password")
        success = False
        if password == app.config["ADMIN_PASSWORD"]:
            print("logged in successfully")
            success = True
            login_user(Admin())
        else:
            print("did not log in successfully")
        return render_template("login.html", success=success)

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

    @app.route("/blog/scripts/<filename>", methods=("GET", "POST"))
    def send_script(filename):
        print("matched scripts route")
        return send_from_directory("/srv/http/riotblog/scripts", filename)

    @app.route("/blog/styles/<filename>", methods=("GET", "POST"))
    def send_style(filename):
        return send_from_directory("/srv/http/riotblog/styles", filename)

    @app.route("/blog/switchpost/<pid>")
    def getposts(pid):
        try:
            index = int(pid)
        except ValueError:
            index = 0
        return posts.getposts(index+1, index)

    @app.route("/blog/allposts")
    def allposts():
        return posts.allposts()

    # editor routes

    @app.route("/blog/editor/", methods=("GET", "POST"))
    @login_required
    def editor():
        """
        View the post editor, requires auth
        """
        return render_template("write.html")

    @app.route("/blog/insert/", methods=("POST",))
    @login_required
    def insert():
        """
        Insert a post, requires auth
        """

        author = request.form.get("author", "no author")
        title = request.form.get("title", "no title")
        content = request.form.get("content", "no content")
        postid = request.form.get("postid", False)

        post = {"author" : author, "title" : title, "content" : content }

        return posts.savepost(**post)

    # default, not found error

    @app.route("/<path:path>")
    def page_not_found(path):
        return "Oops, couldn't find that :/"

    return app

app = NeverWhere()

app.config.from_envvar('RIOTBLOG_SETTINGS')

login_manager.init_app(app)

csrf = CSRFProtect()

csrf.init_app(app)

if __name__ == "__main__":
    NeverWhere("./appconfig").run(host="localhost", port=8001, debug=True)
