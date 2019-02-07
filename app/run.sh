#! /bin/bash

curl localhost:5984 2> /dev/null
while [ $? != 0 ]; do
  curl localhost:5984 2> /dev/null
  sleep 5;
done

curl -XPUT http://$COUCHDB_USER:$COUCHDB_PASSWORD@localhost:5984/blog || true
curl -XPUT http://$COUCHDB_USER:$COUCHDB_PASSWORD@localhost:5984/blog/_design/blogPosts -d @/blogPosts.json || true
exec python3 "$@"
