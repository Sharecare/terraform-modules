# Default values for ambassador.
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.

replicaCount: 3
daemonSet: false

namespace:
  name: ingress

# Additional container environment variable
env:
  # {}
  # Exposing statistics via StatsD
  STATSD_ENABLED: true
  STATSD_HOST: localhost
  # sets the minimum number of seconds between Envoy restarts
  # AMBASSADOR_RESTART_TIME: 15
  # sets the number of seconds that the Envoy will wait for open connections to drain on a restart
  # AMBASSADOR_DRAIN_TIME: 5
  # sets the number of seconds that Ambassador will wait for the old Envoy to clean up and exit on a restart
  # AMBASSADOR_SHUTDOWN_TIME: 10
  # labels Ambassador with an ID to allow for configuring multiple Ambassadors in a cluster
  # AMBASSADOR_ID: default

imagePullSecrets: []

securityContext:
  runAsUser: 8888

image:
  repository: quay.io/datawire/ambassador
  tag: 1.7.4
  pullPolicy: IfNotPresent

nameOverride: ""
fullnameOverride: ""
dnsPolicy: "ClusterFirst"
hostNetwork: false

service:
  type: LoadBalancer

  # Note that target http ports need to match your ambassador configurations service_port
  # https://www.getambassador.io/reference/modules/#the-ambassador-module
  http:
    port: 80
    targetPort: 8080

  https:
    port: 443
    targetPort: 8443

  annotations:
    getambassador.io/config: |
      ---
      apiVersion: ambassador/v1
      kind: Module
      name: ambassador
      config:
        diagnostics:
          enabled: true
        enable_grpc_web: true  
      ---
      apiVersion: ambassador/v1
      kind: TLSContext
      name: tls-${PROVIDER}
      hosts: ['*.${COMMON_NAME}', '${COMMON_NAME}']
      secret: ambassador-certs-${PROVIDER}
      redirect_cleartext_from: 8080
      alpn_protocols: h2[, http/1.1]
      min_tls_version: v1.2
      max_tls_version: v1.3

  # externalTrafficPolicy:
  # loadBalancerSourceRanges:
  #   - YOUR_IP_RANGE

adminService:
  create: true
  type: ClusterIP
  port: 8877
  # NodePort used if type is NodePort
  # nodePort: 38877

rbac:
  # Specifies whether RBAC resources should be created
  create: true
  namespaced: true


crds:
  enabled: true
  created: true
  keep: false

scope:
  # tells Ambassador to only use resources in the namespace or namespace set by namespace.name
  singleNamespace: false

serviceAccount:
  # Specifies whether a service account should be created
  create: true
  # The name of the service account to use.
  # If not set and create is true, a name is generated using the fullname template
  name:

initContainers: []

volumes: []

volumeMounts: []

podLabels:
  service: statsd-sink

podAnnotations:
  {}
  # prometheus.io/scrape: "true"
  # prometheus.io/port: "9102"

resources:
  {}
  # If you do want to specify resources, uncomment the following
  # lines, adjust them as necessary, and remove the curly braces after 'resources:'.
  # limits:
  #  cpu: 100m
  #  memory: 128Mi
  # requests:
  #  cpu: 100m
  #  memory: 128Mi

nodeSelector: {}

tolerations: []

affinity: {}

# Enabling the prometheus exporter creates a sidecar and configures ambassador to use it
prometheusExporter:
  enabled: false
  repository: prom/statsd-exporter
  tag: v0.8.1
  pullPolicy: IfNotPresent
  # You can configure the statsd exporter to modify the behavior of mappings and other features.
  # See documentation: https://github.com/prometheus/statsd_exporter/tree/v0.8.1#metric-mapping-and-configuration
  # Uncomment the following line if you wish to specify a custom configuration:
  # configuration: |
  #   ---
  #   mappings:
  #   - match: 'envoy.cluster.*.upstream_cx_connect_ms'
  #     name: "envoy_cluster_upstream_cx_connect_time"
  #     timer_type: 'histogram'
  #     labels:
  #       cluster_name: "$1"

ambassadorConfig: ""

pro:
  enabled: false
  image:
    repository: quay.io/datawire/ambassador_pro
    tag: amb-sidecar-0.4.0
  ports:
    auth: 8500
    ratelimit: 8501
    ratelimitDebug: 8502
  logLevel: info
  licenseKey:
    value: ""
    secret:
      enabled: true
      create: true