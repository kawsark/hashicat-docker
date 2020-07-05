#!/bin/bash
# A script to delete all Intentions for the Hashicat application

set +e
echo "Note: you may get errors if an intention does not exist"

consul intention delete '*' '*'
consul intention delete 'ingress-gateway' 'hashicat'
consul intention delete 'ingress-gateway' 'hashicat-web'
consul intention delete 'hashicat-web' 'hashicat-image'
consul intention delete 'hashicat-web' 'hashicat-url'
consul intention delete 'hashicat-web' 'hashicat-metadata'
