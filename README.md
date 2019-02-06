A simple single-page blog written in RiotJS and Flask

It is still very much a work in progress, but you can see it in action at https://wesk.tech/blog

Includes a tag that pulls projects from Github and puts them in a carousel-like
UI, as well as a post editor that handles markdown.

To build:

docker-compose build

edit `.envrc` to include COUCHDB_USER and COUCHDB_PASSWORD

create `app/riotblog_local.cfg` and add these variables
- SECRET_KEY (whatever you want)
- ADMIN_PASSWORD (whatever you want)
- COUCHDB_NAME (the name of the couchdb database)
