#! /usr/bin/env bash

# This will be run by CI

cd app
docker build -t registry.gitlab.com/weskerfoot/kettleblog:$1 .
docker push registry.gitlab.com/weskerfoot/kettleblog:$1
