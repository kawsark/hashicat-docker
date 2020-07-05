#!/bin/bash
# A script to create all Intentions for the Hashicat application

set +e
echo "You may get errors if an intention already exists"

consul intention create -deny '*' '*'
consul intention create -allow 'ingress-gateway' 'hashicat'
consul intention create -allow 'ingress-gateway' 'hashicat-web'
consul intention create -allow 'hashicat-web' 'hashicat-image'
consul intention create -allow 'hashicat-web' 'hashicat-url'
consul intention create -allow 'hashicat-web' 'hashicat-metadata'