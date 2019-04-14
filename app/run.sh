#! /bin/bash

function updateLinks() {
  revision_id=$(curl http://$COUCHDB_USER:$COUCHDB_PASSWORD@127.0.0.1:5984/$COUCHDB_NAME/links | jq -r "._rev")
  echo "$revision_id"
  if [ $? == 0 ];
  then
    curl -XDELETE "http://$COUCHDB_USER:$COUCHDB_PASSWORD@127.0.0.1:5984/$COUCHDB_NAME/links?rev=$revision_id" || true
  fi
  curl -XPUT http://$COUCHDB_USER:$COUCHDB_PASSWORD@127.0.0.1:5984/$COUCHDB_NAME/links -d @link.json || true

}

curl 127.0.0.1:5984 2> /dev/null
while [ $? != 0 ]; do
  curl 127.0.0.1:5984 2> /dev/null
  sleep 5;
done

curl -XPUT http://$COUCHDB_USER:$COUCHDB_PASSWORD@127.0.0.1:5984/$COUCHDB_NAME || true
curl -XPUT http://$COUCHDB_USER:$COUCHDB_PASSWORD@127.0.0.1:5984/$COUCHDB_NAME/_design/blogPosts -d @/blogPosts.json || true

updateLinks

exec python3 "$@"
