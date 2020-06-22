# Find directory where set_consul_http_addr.sh and invoke it
path="."
[[ -f ./scripts/set_consul_http_addr.sh ]] && path="./scripts"
source $path/set_consul_http_addr.sh

echo "$ consul members"
consul members || (echo "ERROR: could not run consul members. Please ensure Consul CLI is set up correctly.")

echo "$ consul catalog services -tags"
consul catalog services -tags || (echo "ERROR: could not run consul catalog services. Please ensure Consul CLI is set up correctly.")