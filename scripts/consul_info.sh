#!/bin/bash
# A script to print out consul information using the CLI such as consul members and consul catalog services

# First find the directory for set_consul_http_addr.sh and invoke it
path="."
[[ -f ./scripts/get_consul_http_addr.sh ]] && path="./scripts"
source $path/get_consul_http_addr.sh

# consul members
echo "$ consul members"
consul members || (echo "ERROR: could not run consul members. Please ensure Consul CLI is set up correctly.")

# consul catalog services -tags
echo "$ consul catalog services -tags"
consul catalog services -tags || (echo "ERROR: could not run consul catalog services. Please ensure Consul CLI is set up correctly.")