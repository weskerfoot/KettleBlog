FROM ubuntu:latest

MAINTAINER wes kerfoot "wjak56@gmail.com"

RUN mkdir -p /{styles,scripts} && mkdir -p /src

RUN apt-get update -y
RUN apt-get install -y curl
RUN curl -sL https://deb.nodesource.com/setup_13.x | bash
RUN apt-get update -y
RUN apt-get install -y python3-pip python3-dev build-essential sassc jq nodejs
RUN npm install -g uglifycss uglifyjs

COPY requirements.txt /requirements.txt
RUN pip3 install -r /requirements.txt

COPY package-lock.json package.json /
RUN npm install

COPY rollup.config.riotblog.js rollup.config.editor.js /scripts/
COPY link.json list.js admin.py posts.py projects.py website.py ./src/

# Docker has ridiculous behaviour with regards to COPY
# COPY foo bar /baz/ won't actually copy the directories, but their contents
COPY templates /src/templates
COPY images /src/images
COPY blogPosts.json run.sh /

COPY scripts /scripts
RUN npm run-script build_riotblog && npm run-script build_editor

COPY styles /styles
RUN sassc /styles/riotblog.scss > /styles/riotblog.intermediate.min.css && \
      uglifycss /styles/*.css > /styles/riotblog.min.css

ENTRYPOINT ["/bin/bash", "/run.sh"]
CMD ["/src/website.py"]

EXPOSE 6969
