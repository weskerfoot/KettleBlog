#! /usr/bin/bash

while inotifywait -qqre modify "./src"; do
  fab locbuild
done
