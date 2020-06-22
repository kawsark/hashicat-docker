#!/bin/bash

echo "0. Checking CLI tools: jq, consul, kubectl, curl ..."
tools='["jq","consul","curl"]'
which jq || (echo "ERROR: jq tool not found, please download and put on your path: https://stedolan.github.io/jq/download/" && exit 1)
for t in $(echo $tools | jq -r '.[]')
do
  echo $t || (echo "ERROR: Could not find $t" && exit 1)
done
echo "OK: Found all the tools, we are off to a good start!"

echo "1. Checking kubectl cluster-info ..."
kubectl cluster-info

# Check for API server IP address
s=$(kubectl cluster-info | grep master | awk '{print $NF}')
if [[ ! -z $s ]] && [[ $s != '' ]]; then 
  echo "OK: Master is running at: $s"
else
  echo "ERROR: could not determine master IP. Please check kubectl Configuration."
  exit 1
fi

# Check for Nodes
echo "2. Checking for 1+ nodes from kubectl ..."
n=$(kubectl get nodes -o json | jq '.items | length')
if [[ $n != '0' ]]; then
  echo "OK: Found $n nodes from kubectl"
  node_ip=$(kubectl get nodes -o=json | jq -r '.items[0].status.addresses[] | select(.type == "ExternalIP") | .address')
else
  echo "ERROR: Did not find at least one running node from kubectl get nodes."
fi


# Check for Consul server pod
name=consul-server-0
echo "3. Checking for $name pod ..."
s=$(kubectl get pod | grep $name | awk '{print $1}')
if [[ ! -z $s ]] && [[ $s != '' ]]; then 
  echo "OK: Found consul server pod 0: $s"
else
  echo "ERROR: could not find at least one pod with $name. Please ensure you used consul-helm to deploy Consul."
  exit 1
fi

# Check for CONSUL_HTTP_ADDR or consul-ui service
echo "4. Looking for CONSUL_HTTP_ADDR"
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

# Ping Consul UI endpoint
echo "5. Checking for consul-ui service at endpoint: $CONSUL_HTTP_ADDR ..."
curl $CONSUL_HTTP_ADDR || (echo "ERROR: Could not reach endpoint $CONSUL_HTTP_ADDR with curl. Please ensure you have access to this endpoint." && exit 1)
echo "OK"

# Run Consul members
echo "5. Running consul members"
consul members || (echo "ERROR: could not run consul members. Please ensure Consul CLI is set up correctly.")
echo "OK"



echo "All checks passed!"