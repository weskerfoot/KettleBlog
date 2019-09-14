FROM ubuntu:latest
MAINTAINER wes kerfoot "wjak56@gmail.com"

RUN apt-get update -y
RUN apt-get install -y python3-pip python3-dev build-essential sassc jq curl
RUN curl -sL https://deb.nodesource.com/setup_11.x | bash
RUN apt-get install -y nodejs
RUN npm install -g uglifycss uglifyjs

COPY . ./src

WORKDIR /src

RUN npm install
RUN pip3 install -r /src/requirements.txt
RUN mkdir -p ./build/styles ./build/scripts

RUN npm run-script build_riotblog
RUN npm run-script build_editor
RUN sassc ./styles/riotblog.scss > ./styles/riotblog.intermediate.min.css
RUN cp ./styles/*.css ./build/styles/
RUN uglifycss ./styles/*.css > ./build/styles/riotblog.min.css

COPY run.sh /run.sh
COPY blogPosts.json /blogPosts.json

ENTRYPOINT ["/bin/bash", "/run.sh"]
CMD ["/src/website.py"]

EXPOSE 6969
