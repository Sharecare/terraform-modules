#!/bin/sh
set -e
apk --update add curl
until curl -k "https://admin:admin@opensearch-cluster-master.opensearch:9200"; do echo "Waiting for Opensearch to be available...""; sleep 5; done;
until curl -k "http://opensearch-dashboards.opensearch:5601"; do echo "Waiting for Kibana to be available...""; sleep 5; done;
sleep 40
echo "adding to saved objects"
curl -XPOST -k -s --fail --show-error "http://admin:admin@opensearch-dashboards.opensearch:5601/api/saved_objects/_import?overwrite=true" -H "osd-xsrf: true" -H "kbn-xsrf: true" -H "securitytenant: global" --form file=@/usr/share/init-files/export.ndjson
echo "adding to policy to logs"
curl -XPUT  -k -s --fail --show-error "https://admin:admin@opensearch-cluster-master.opensearch:9200/_plugins/_ism/policies/delete_old_logs" -H "Content-Type: application/json" -d @/usr/share/init-files/deleteold-logs-indices.json
echo "adding to policy to metricbeat"
curl -XPUT  -k -s --fail --show-error "https://admin:admin@opensearch-cluster-master.opensearch:9200/_plugins/_ism/policies/delete_old_metricbeat_indices" -H "Content-Type: application/json" -d @/usr/share/init-files/deleteold-metricbeat-indices.json
echo "adding to rollup-job to metricbeat"
curl -XPUT  -k -s --fail --show-error "https://admin:admin@opensearch-cluster-master.opensearch:9200/_plugins/_rollup/jobs/metricbeat-rollup" -H "Content-Type: application/json" -d @/usr/share/init-files/rollup-metricbeat.json
echo "sucessfully finished"