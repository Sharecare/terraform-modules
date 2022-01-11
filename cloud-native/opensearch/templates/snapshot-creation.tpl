#!/bin/sh
set -e
apk --update add curl
DATE=$(date +"%Y-%m")
DATEPATH=$(date +"%Y/%m")
DATETIME=$(date +"%Y-%m-%d-%H:%M")
BUCKET=${BUCKET}
TYPE=${TYPE}
until curl -k "https://admin:admin@opensearch-cluster-master.opensearch:9200"; do echo 'Waiting for Opensearch to be available...'; sleep 5; done;
curl -XPUT -k -s --fail --show-error 'https://admin:admin@opensearch-cluster-master.opensearch:9200/_snapshot/snapshot-repository-'"$DATE"'' -H "Content-type: application/json" -d '{"type": "'"$TYPE"'", "settings": {"bucket": "'"$BUCKET"'", "base_path": "'"$DATEPATH"'"}}'
sleep 30
curl -XPUT -k -s --fail --show-error 'https://admin:admin@opensearch-cluster-master.opensearch:9200/_snapshot/snapshot-repository-'"$DATE"'/'"$DATETIME"'?wait_for_completion=true' -H "Content-Type: application/json"
