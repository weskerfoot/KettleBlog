#! /usr/bin/python3
from functools import partial

from flask import abort, Flask, render_template, flash, request, send_from_directory, jsonify, g
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

def get_posts():
    posts = getattr(g, "posts", None)
    if posts is None:
        posts = g._posts = Posts(app.config["COUCHDB_USER"], app.config["COUCHDB_PASSWORD"])
    return posts

def NeverWhere(configfile=None):
    app = Flask(__name__)
    app.config["TEMPLATES_AUTO_RELOAD"] = True
    app.config["COUCHDB_SERVER"] = "http://localhost:5984"
    app.config["COUCHDB_DATABASE"] = "blog"
    #def favicon():
        #return send_from_directory("/srv/http/goal/favicon.ico",
                                   #'favicon.ico', mimetype='image/vnd.microsoft.icon')

    print(os.environ["RIOTBLOG_SETTINGS"])
    app.config.from_envvar('RIOTBLOG_SETTINGS')

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

    # blog post routes
    @app.route("/blog/posts/", methods=("GET",))
    def renderInitial():
        post_content = posts.getinitial()
        return render_template("index.html", quote=quote, postcontent=dict(post_content))

    @app.route("/blog/posts/<_id>", methods=("GET",))
    def renderPost(_id):
        post_content = posts.getpost(_id, json=False)
        return render_template("index.html", quote=quote, postcontent=dict(post_content))

    @app.route("/blog/", methods=("GET", "POST"))
    def index():
        return renderInitial()

    # get the next post
    @app.route("/blog/switchpost/<pid>/<category>")
    def getpostid(pid, category):
        return posts.iterpost(startkey=pid, category=category)

    # get the post previous to this one
    @app.route("/blog/prevpost/<pid>/<category>")
    def prevpost(pid, category):
        return posts.iterpost(endkey=pid, category=category)

    # get the contents of any post
    @app.route("/blog/getpost/<_id>/<category>")
    def getpost(_id, category):
        return posts.getpost(_id, category=category)

    # get the id of every post
    @app.route("/blog/allposts")
    def allposts():
        return posts.allposts()

    @app.route("/blog/categories")
    def categories():
        return posts.categories()

    # remove a post
    @app.route("/blog/deletepost/<_id>")
    @login_required
    def delete(_id):
        return posts.delete(_id)

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
        postid = request.form.get("_id", False)

        post = {
                "author" : author,
                "title" : title,
                "content" : content,
                "_id" : postid
                }

        return posts.savepost(**post)

    @app.route("/blog/links/", methods=("GET",))
    def links():
        """
        Get links
        """
        return posts.links()

    return app

app = NeverWhere()

@app.teardown_appcontext
def teardown_couchdb(exception):
    posts = getattr(g, 'posts', None)
    if posts is not None:
        del posts.db

posts = LocalProxy(get_posts)

login_manager.init_app(app)

csrf = CSRFProtect()

csrf.init_app(app)

if __name__ == "__main__":
    NeverWhere().run(host="localhost", port=8001, debug=True)
