apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: ambassador-certs-${PROVIDER}
  namespace: ingress
spec:
  secretName: ambassador-certs-${PROVIDER}
  issuerRef:
    name: letsencrypt-${PROVIDER}
    kind: Issuer
  commonName: ${COMMOM_NAME}
  dnsNames:
  - '${COMMOM_NAME}'
  - '*.${COMMOM_NAME}'