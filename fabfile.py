from __future__ import with_statement
from fabric.api import *
from fabric.contrib.console import confirm
from fabric.contrib.project import rsync_project
import fabric.operations as op

env.hosts = ["wes@mgoal.ca:444"]

@task
def buildTags():
    with lcd("./build"):
        local("riot ../src/tags scripts/tags.min.js")

@task
def buildScss():
    with lcd("./build"):
        local("sassc ../src/styles/riotblog.scss > styles/riotblog.min.css")

@task
def minifyJS():
    with lcd("./build"):
        local("uglifyjs ../src/scripts/riotblog.js > scripts/riotblog.min.js")

@task
def buildVenv():
    with cd("~/build"):
        run("virtualenv -p $(which python3) ~/build/venv")
        with prefix("source ~/build/venv/bin/activate"):
            run("pip3 install -r requirements.txt")

@task
def copyFiles():
    local("cp ./{blog.ini,blog.service,requirements.txt} ./build/")
    local("cp ./src/*py ./build/")
    local("cp ./src/styles/*.css ./build/styles/")
    local("cp -r ./src/templates ./build/templates")

@task
def upload():
    run("rm -r ~/build")
    run("mkdir -p ~/build")
    rsync_project(local_dir="./build/", remote_dir="~/build/", delete=True, exclude=[".git"])

@task
def serveUp():
    sudo("rm -r /srv/http/riotblog")
    sudo("cp -r /home/wes/build /srv/http/riotblog")
    sudo("cp /home/wes/build/blog.service /etc/systemd/system/blog.service")
    sudo("systemctl daemon-reload")
    sudo("systemctl enable blog.service")
    sudo("systemctl restart blog.service")

@task(default=True)
def build():
    local("rm -r ./build")
    local("mkdir -p build/{scripts,styles}")
    buildTags()
    buildScss()
    minifyJS()
    copyFiles()
    upload()
    buildVenv()
    serveUp()
