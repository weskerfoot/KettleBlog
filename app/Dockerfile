FROM ubuntu:latest

MAINTAINER wes kerfoot "wjak56@gmail.com"

RUN apt-get update -y
RUN apt-get install -y curl
RUN curl -sL https://deb.nodesource.com/setup_13.x | bash
RUN apt-get update -y
RUN apt-get install -y python3-pip python3-dev build-essential sassc jq nodejs
RUN npm install -g uglifycss uglifyjs

COPY . ./src
COPY run.sh /run.sh
COPY blogPosts.json /blogPosts.json

WORKDIR /src

RUN npm install && pip3 install -r /src/requirements.txt && \
      mkdir -p ./build/styles ./build/scripts && \
      npm run-script build_riotblog && \
      npm run-script build_editor

RUN sassc ./styles/riotblog.scss > ./styles/riotblog.intermediate.min.css && \
      cp ./styles/*.css ./build/styles/ && \ 
      uglifycss ./styles/*.css > ./build/styles/riotblog.min.css

ENTRYPOINT ["/bin/bash", "/run.sh"]
CMD ["/src/website.py"]

EXPOSE 6969
