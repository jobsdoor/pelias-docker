#!/usr/bin/env bash

set -uxo pipefail

cd data

tar -czvf ../data-compressed/interpolation.tgz ./interpolation
tar -czvf ../data-compressed/whosonfirst.tgz ./whosonfirst
tar -czvf ../data-compressed/placeholder.tgz ./placeholder
tar -czvf ../data-compressed/elasticsearch-snapshots.tgz ./elasticsearch-snapshots

cd ../data-compressed

swift upload -S 1073741824 pelias-test interpolation.tgz
swift upload -S 1073741824 pelias-test placeholder.tgz
swift upload -S 1073741824 pelias-test whosonfirst.tgz
swift upload -S 1073741824 pelias-test elasticsearch-snapshots.tgz
