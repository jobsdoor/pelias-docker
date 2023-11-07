#!/usr/bin/env bash

cd data

tar -czvf ../data-compressed/interpolation.tgz ./interpolation
tar -czvf ../data-compressed/whosonfirst.tgz ./whosonfirst
tar -czvf ../data-compressed/placeholder.tgz ./placeholder
tar -czvf ../data-compressed/elasticsearch-snapshots.tgz ./elasticsearch-snapshots

cd ../data-compressed

swift upload -S 1073741824 pelias-europe interpolation.tgz
swift upload -S 1073741824 pelias-europe placeholder.tgz
swift upload -S 1073741824 pelias-europe whosonfirst.tgz
