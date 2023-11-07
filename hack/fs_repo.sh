#!/usr/bin/env bash

# create repository
curl -X PUT "localhost:9200/_snapshot/fs_pelias?pretty" -H 'Content-Type: application/json' -d @fs_repo.json

# create snapshot
curl -X PUT "localhost:9200/_snapshot/fs_pelias/pelias-$(date +%d-%m-%g-%s)?pretty"

# get all snapshots
curl -X GET "localhost:9200/_snapshot/fs_pelias/_all?pretty"

# get snapshot status
curl -X GET "localhost:9200/_snapshot/_status?pretty"
