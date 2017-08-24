#! /usr/bin/python3
from functools import partial
from collections import defaultdict
from os import environ

from flask import abort, Flask, render_template, flash, request, send_from_directory, jsonify, g
from werkzeug.local import Local, LocalProxy, LocalManager
from flask_appconfig import AppConfig
from flask_login import LoginManager, login_required, login_user
from flask_wtf.csrf import CSRFProtect
from flask.ext.cache import Cache

from urllib.parse import unquote
from urllib.parse import quote, unquote
from json import dumps, loads
from admin import Admin
from werkzeug.contrib.cache import MemcachedCache

from posts import Posts
from projects import getProjects

memcache = MemcachedCache(['127.0.0.1:11211'])
cache = Cache(config={'CACHE_TYPE': 'memcached'})

login_manager = LoginManager()

def cacheit(key, thunk):
    """
    Explicit memcached caching
    """
    cached = memcache.get(quote(key))
    if cached is None:
        print("cache miss for %s" % key)
        result = thunk()
        memcache.set(quote(key), result)
        return result
    print("cache hit for %s" % key)
    return cached

def get_posts():
    posts = getattr(g, "posts", None)
    if posts is None:
        posts = g._posts = Posts(app.config["COUCHDB_USER"],
                                 app.config["COUCHDB_PASSWORD"])
    return posts

def get_initial():
    initial_post = getattr(g, "initial_post", None)
    if initial_post is None:
        initial_post = g._initial_post = posts.getinitial()
    return initial_post

def NeverWhere(configfile=None):
    app = Flask(__name__)
    app.config["TEMPLATES_AUTO_RELOAD"] = True
    app.config["COUCHDB_SERVER"] = "http://localhost:5984"
    app.config["COUCHDB_DATABASE"] = "blog"
    #def favicon():
        #return send_from_directory("/srv/http/goal/favicon.ico",
                                   #'favicon.ico', mimetype='image/vnd.microsoft.icon')

    print(environ["RIOTBLOG_SETTINGS"])
    app.config.from_envvar('RIOTBLOG_SETTINGS')

    # Set template variables to be injected
    @app.context_processor
    def inject_variables():
        postcontent = defaultdict(str)
        postcontent["title"] = initial_post["title"]
        return {
                "quote" : quote,
                "start" : 0,
                "results" : dumps([]),
                "postid" : initial_post["_id"],
                "postcontent" : postcontent,
                "links" : dumps([]),
                "projects" : dumps([]),
                "category_filter" : dumps([]),
                "categories" : cacheit("categories", lambda : dumps(posts.categories()))
        }

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

    # page routes
    @cache.cached(timeout=50)
    @app.route("/blog/posts/", methods=("GET",))
    def renderInitial():
        post = dict(initial_post)
        return render_template("index.html",
                               postid=initial_post["_id"],
                               page="posts",
                               postcontent=post)

    @cache.cached(timeout=50)
    @app.route("/blog/projects", methods=("GET",))
    def showProjects():
        return render_template("index.html", page="projects")

    @cache.cached(timeout=50)
    @app.route("/blog/links", methods=("GET",))
    def showLinks():
        return render_template("index.html",
                               links=dumps(
                                        list(
                                            posts.links(json=False))),
                                            page="links"
                                        )

    @cache.cached(timeout=50)
    @app.route("/blog/about", methods=("GET",))
    def showAbout():
        return render_template("index.html", page="about")

    @cache.cached(timeout=50)
    @app.route("/blog/", methods=("GET", "POST"))
    def index():
        return renderInitial()

    # get the next post
    @cache.cached(timeout=50)
    @app.route("/blog/posts/<_id>", methods=("GET",))
    def renderPost(_id):
        post_content = dict(loads(
                            cacheit(_id,
                                    lambda: dumps(posts.getpost(_id, json=False)))
                            ))


        return render_template("index.html",
                               page="posts",
                               postcontent=post_content)


    @app.route("/blog/browse/")
    def browse_root():
        return browse(0)

    @app.route("/blog/browse/<category>/")
    def browse_categories_(category):
        return browse_categories(category, 0)

    @app.route("/blog/browse/<start>")
    def browse(start):
        results = posts.browse(10, start*10, categories=[], json=False)
        return render_template("index.html",
                                page="browse",
                                start=start,
                                results=dumps(results))

    @app.route("/blog/browse/<category>/<start>")
    def browse_categories(category, start):
        results = posts.browse(10, start*10, categories=[category], json=False)
        return render_template("index.html",
                                page="browse",
                                start=start,
                                category_filter=dumps([category]),
                                results=dumps(results))

    @cache.cached(timeout=50)
    @app.route("/blog/switchpost/<pid>/<category>")
    def getpostid(pid, category):
        return posts.iterpost(startkey=pid)

    # get the post previous to this one
    @cache.cached(timeout=50)
    @app.route("/blog/prevpost/<pid>/<category>")
    def prevpost(pid, category):
        return posts.iterpost(endkey=pid)

    # get the contents of any post
    # rendered in JSON
    @cache.cached(timeout=50)
    @app.route("/blog/getpost/<_id>/")
    def getpost(_id):
        return posts.getpost(_id)

    @cache.cached(timeout=50)
    @app.route("/blog/getrawpost/<_id>")
    def getrawpost(_id):
        return posts.getpost(_id, convert=False)

    # get the first post of a given category
    @cache.cached(timeout=50)
    @app.route("/blog/getpost/<category>")
    def bycategory(category):
        return posts.getbycategory(category)

    # get the id of every post
    @app.route("/blog/allposts")
    def allposts():
        return posts.allposts()

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

    @app.route("/blog/insert/<category>", methods=("POST",))
    @login_required
    def insert(category):
        """
        Insert a post, requires auth
        """

        author = request.form.get("author", "no author")
        title = request.form.get("title", "no title")
        content = request.form.get("content", "no content")
        category = request.form.get("category", "programming")
        postid = request.form.get("_id", False)

        post = {
                "author" : author,
                "title" : title,
                "content" : content,
                "category" : category,
                "_id" : postid
                }

        return posts.savepost(**post)

    @app.route("/blog/glinks/", methods=("GET",))
    def links():
        """
        Get links
        """
        return posts.links()

    @app.route("/blog/ghprojects", methods=("GET",))
    def projects():
        return jsonify(loads(cacheit("projects", getProjects)))

    @app.route("/blog/getbrowse/<start>")
    def getbrowse(start):
        return posts.browse(10, start*10, categories=[])

    @app.route("/blog/getbrowse/<category>/<start>")
    def getbycategory(category, start):
        return posts.browse(10, start*10, categories=[category])

    return app

app = NeverWhere()

@app.teardown_appcontext
def teardown_couchdb(exception):
    posts = getattr(g, 'posts', None)
    if posts is not None:
        del posts.db

posts = LocalProxy(get_posts)
initial_post = LocalProxy(get_initial)

login_manager.init_app(app)

csrf = CSRFProtect()

csrf.init_app(app)

cache.init_app(app)

if __name__ == "__main__":
    NeverWhere().run(host="localhost", port=8001, debug=True)
