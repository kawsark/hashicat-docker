#!/bin/bash
# Delete hashicat pods to test intentions

prefix=hashicat
for pod in $(kubectl get pods | grep $prefix | awk '{print $1}')
do
  echo "Deleting Pod: $pod"
  kubectl delete pod/$pod &
done