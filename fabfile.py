from __future__ import with_statement
from fabric.api import *
from fabric.contrib.console import confirm
from fabric.contrib.project import rsync_project
import fabric.operations as op

env.hosts = ["wes@mgoal.ca:444"]

@task
def buildScss():
    with lcd("./build"):
        local("sassc ../src/styles/riotblog.scss > styles/riotblog.min.css")
        local("sassc ../src/styles/projects.scss > styles/projects.min.css")

@task
def buildJS():
    local("rollup -c rollup.config.js")
    local("uglifyjs build/bundle.js > build/scripts/riotblog.min.js")

@task
def buildVenv():
    with cd("~/build"):
        run("virtualenv -p $(which python3) ~/build/venv")
        with prefix("source ~/build/venv/bin/activate"):
            run("pip3 install -r requirements.txt")

@task
def buildLocalVenv():
    with lcd("~/primop.me/build"):
        local("virtualenv -p $(which python3) ~/primop.me/build/venv")
        with prefix("source ~/primop.me/build/venv/bin/activate"):
            local("pip3 install -r requirements.txt")

@task
def copyFiles():
    local("cp ./{blog.ini,blog.service,requirements.txt} ./build/")
    local("cp ./src/*py ./build/")
    local("cp ./src/styles/*.css ./build/styles/")
    local("uglifycss ./build/styles/*css > ./build/styles/primop.me.min.css")
    local("cp -r ./src/templates ./build/templates")

@task
def upload():
    run("mkdir -p ~/build")
    rsync_project(local_dir="./build/", remote_dir="~/build/", delete=False, exclude=[".git"])

@task
def serveUp():
    sudo("rm -fr /srv/http/riotblog")
    sudo("cp -r /home/wes/build /srv/http/riotblog")
    sudo("cp /home/wes/build/blog.service /etc/systemd/system/blog.service")
    sudo("systemctl daemon-reload")
    sudo("systemctl enable blog.service")
    sudo("systemctl restart blog.service")

@task(default=True)
def build():
    local("mkdir -p build/{scripts,styles}")
    buildScss()
    buildJS()
    copyFiles()
    upload()
    buildVenv()
    serveUp()

@task
def update():
    local("mkdir -p build/{scripts,styles}")
    buildScss()
    buildJS()
    copyFiles()
    upload()
    serveUp()

@task
def locbuild():
    local("rm -rf ./build")
    local("mkdir -p build/{scripts,styles}")
    local("cp requirements.txt ./build/requirements.txt")
    buildLocalVenv()
    buildScss()
    buildJS()
    copyFiles()
    local("sudo rm -fr /srv/http/riotblog")
    local("sudo mkdir -p /srv/http/riotblog")
    local("sudo cp -r ./build/* /srv/http/riotblog/")
    local("sudo cp /home/wes/primop.me/blog.service /etc/systemd/system/blog.service")
    local("sudo systemctl daemon-reload")
    local("sudo systemctl enable blog.service")
    local("sudo systemctl restart blog.service")
