#!/bin/bash

node=$(kubectl get nodes -o=json | jq -r '.items[0].status.addresses[] | select(.type == "ExternalIP") | .address')

# Get Endpoints for Hashicat application
for x in $@; do
  name=$x
  check=$(kubectl get svc/$x 2>/dev/null)
  if [[ $? != 0 ]]; then
    echo "Looking for $x service name with a prefix ..."
    name=$(kubectl get svc | grep $x | awk '{print $1}')
  fi

  ports=$(kubectl get svc/$name -o json | jq '.spec.ports[].nodePort')
   for p in $ports; do
     e="http://$node:$p"
     echo "Access $name @: $e"
     if [[ $CURL_ENDPOINT = 'True' ]]; then 
       curl $e
    fi
   done
done