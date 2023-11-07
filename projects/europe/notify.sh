#!/bin/bash
set -uxo pipefail

# Set your Pushbullet API token here
API_TOKEN=""

pelias compose pull

pelias elastic start &&
    pelias elastic wait &&
    pelias elastic create

# Check if elastic was successful
if [ $? -eq 0 ]; then
    # Send a notification using Pushbullet
    curl --header "Access-Token: $API_TOKEN" \
        --header 'Content-Type: application/json' \
        --data-binary '{"type": "note", "title": "Elastic stage complete", "body": "Elastic stage complete."}' \
        --request POST \
        https://api.pushbullet.com/v2/pushes
else
    # Send a notification using Pushbullet
    curl --header "Access-Token: $API_TOKEN" \
        --header 'Content-Type: application/json' \
        --data-binary '{"type": "note", "title": "Elastic stage failed", "body": "Elastic stage failed."}' \
        --request POST \
        https://api.pushbullet.com/v2/pushes

    exit 1
fi

pelias download all &&
    pelias prepare all &&
    pelias import all

# Check if the download was successful
if [ $? -eq 0 ]; then
    # Send a notification using Pushbullet
    curl --header "Access-Token: $API_TOKEN" \
        --header 'Content-Type: application/json' \
        --data-binary '{"type": "note", "title": "Download complete", "body": "Your download has finished."}' \
        --request POST \
        https://api.pushbullet.com/v2/pushes
else
    # Send a notification using Pushbullet
    curl --header "Access-Token: $API_TOKEN" \
        --header 'Content-Type: application/json' \
        --data-binary '{"type": "note", "title": "Download failed", "body": "Download failed."}' \
        --request POST \
        https://api.pushbullet.com/v2/pushes

    exit 1
fi

pelias compose up

# Check if the tests were successful
if [ $? -eq 0 ]; then
    # Send a notification using Pushbullet
    curl --header "Access-Token: $API_TOKEN" \
        --header 'Content-Type: application/json' \
        --data-binary '{"type": "note", "title": "Compose up successfully", "body": "Compose up successfully."}' \
        --request POST \
        https://api.pushbullet.com/v2/pushes
else
    # Send a notification using Pushbullet
    curl --header "Access-Token: $API_TOKEN" \
        --header 'Content-Type: application/json' \
        --data-binary '{"type": "note", "title": "Compose up failed", "body": "Compose up failed."}' \
        --request POST \
        https://api.pushbullet.com/v2/pushes

    exit 1
fi

pelias compose down

# Cleanup temporary files

# These folders can be entirely deleted after the import into elastic search
rm -rf ./data/openaddresses &&
    rm -rf ./data/tiger &&
    rm -rf ./data/openstreetmap &&
    rm -rf ./data/polylines &&
    find ./data/interpolation -mindepth 1 -maxdepth 1 ! -name "street.db" ! -name "address.db" -exec rm -rf {} \; &&
    find ./data/placeholder -mindepth 1 -maxdepth 1 ! -name "store.sqlite3" -exec rm -rf {} \;

if [ $? -eq 0 ]; then
    # Send a notification using Pushbullet
    curl --header "Access-Token: $API_TOKEN" \
        --header 'Content-Type: application/json' \
        --data-binary '{"type": "note", "title": "Cleaned up temporary files", "body": "Cleaned up temporary files"}' \
        --request POST \
        https://api.pushbullet.com/v2/pushes
else
    # Send a notification using Pushbullet
    curl --header "Access-Token: $API_TOKEN" \
        --header 'Content-Type: application/json' \
        --data-binary '{"type": "note", "title": "Failed to clean up temporary files", "body": "Failed to clean up temporary files"}' \
        --request POST \
        https://api.pushbullet.com/v2/pushes
fi

source ~/ocs_v3.sh

swift upload pelias-europe ./data

if [ $? -eq 0 ]; then
    # Send a notification using Pushbullet
    curl --header "Access-Token: $API_TOKEN" \
        --header 'Content-Type: application/json' \
        --data-binary '{"type": "note", "title": "Uploaded files to swift", "body": "Uploaded files to swift"}' \
        --request POST \
        https://api.pushbullet.com/v2/pushes
else
    # Send a notification using Pushbullet
    curl --header "Access-Token: $API_TOKEN" \
        --header 'Content-Type: application/json' \
        --data-binary '{"type": "note", "title": "Failed to upload files to swift", "body": "Failed to upload files to swift"}' \
        --request POST \
        https://api.pushbullet.com/v2/pushes
fi
