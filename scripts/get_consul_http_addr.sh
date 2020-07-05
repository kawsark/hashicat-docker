#!/bin/bash
# A script to parse the consul-ui kubernetes service and print out NodePort endpoint

echo "Finding Node IP address from kubectl get nodes"
node_ip=$(kubectl get nodes -o=json | jq -r '.items[0].status.addresses[] | select(.type == "ExternalIP") | .address')

echo "Looking for CONSUL_HTTP_ADDR"
if [[ -z $CONSUL_HTTP_ADDR ]] || [[ $CONSUL_HTTP_ADDR == '' ]]; then
  name=consul-ui
  echo "CONSUL_HTTP_ADDR variable not set, trying to determine the value from $name service."
  node=$(kubectl get nodes -o=json | jq -r '.items[0].status.addresses[] | select(.type == "ExternalIP") | .address')
  s=$(kubectl get svc | grep $name | awk '{print $1}')
  if [[ ! -z $s ]] && [[ $s != '' ]]; then 
    echo "OK: Found consul service: $s"
    p=$(kubectl get svc/$s -o json | jq '.spec.ports[0].nodePort')
    export CONSUL_HTTP_ADDR="http://$node_ip:$p"
  else
    echo "ERROR: could not find at the service with *$name. \
    Please ensure you used consul-helm to deploy Consul and selected to deploy the consul-ui service as a NodePort\
    Alternatively you can set the CONSUL_HTTP_ADDR environment variable to an existing Consul agent."
    exit 1
  fi
fi
echo "Using CONSUL_HTTP_ADDR endpoint: $CONSUL_HTTP_ADDR"