all: clean

endpoints: config0
	scripts/endpoints.sh

validate:
	scripts/validate.sh

install:
	kubectl apply -f ./v1-simple/k8s
	kubectl apply -f ./v2-python/k8s-connect
	kubectl apply -f ./v3-python-go/k8s-connect

consul_http_addr:
	scripts/get_consul_http_addr.sh

0_deploy:
	kubectl apply -f ./v1-simple/k8s
	scripts/nodeport.sh hashicat-service

1_ingress:	
	consul config write ./central_config/ingress1.hcl
	scripts/nodeport.sh ingress-gateway
	
2_canary:
	kubectl apply -f ./v2-python/k8s-connect
	consul config write ./central_config/ingress2.hcl	
	scripts/nodeport.sh ingress-gateway

2_routing:
	consul config write central_config/hashicat-router.hcl

3_routing:
	kubectl apply -f ./v3-python-go/k8s-connect
	consul config write ./central_config/image-router-url-header.hcl

4_blue_green:
	consul config write ./central_config/image-router-url-and-metadata.hcl

5_shifting:
	kubectl apply -f ./v3-python-go/k8s-connect-traffic-shifting
	consul config write ./central_config/metadata-resolver.hcl
	consul config write ./central_config/metadata-splitter_100_0.hcl

5_shifting_50:
	consul config write ./central_config/metadata-resolver.hcl
	consul config write ./central_config/metadata-splitter_50_50.hcl

5_shifting_100:
	consul config write ./central_config/metadata-resolver.hcl
	consul config write ./central_config/metadata-splitter_0_100.hcl

root_certs:
	curl -s "${CONSUL_HTTP_ADDR}/v1/connect/ca/roots" | jq .

view_leaf_certs:
	scripts/view_leaf_certs.sh

list_intentions:
	curl -s "${CONSUL_HTTP_ADDR}/v1/connect/intentions" \
	| jq -r '.[] | [.SourceName, .DestinationName, .Action] | @csv' \
	| sed -e s/','/' --> '/ -e s/','/': '/

create_intentions:
	scripts/create_intentions.sh

delete_intentions:
	scripts/delete_intentions.sh

consul_info:
	scripts/consul_info.sh

list_consul_configs:
	consul config list -kind service-router
	consul config list -kind service-splitter
	consul config list -kind service-resolver

apply_consul_configs:
	consul config write ./central_config/ingress1.hcl
	consul config write ./central_config/ingress2.hcl
	consul config write ./central_config/image-router-url-header.hcl
	consul config write ./central_config/image-router-url-and-metadata.hcl
	consul config write ./central_config/metadata-resolver.hcl
	consul config write ./central_config/metadata-splitter_0_100.hcl
	consul config write ./central_config/metadata-splitter_50_50.hcl
	consul config write ./central_config/metadata-splitter_0_100.hcl

clean_consul_configs: 
	consul config delete -kind service-router -name hashicat-image
	consul config delete -kind service-splitter -name hashicat-metadata
	consul config delete -kind service-resolver -name hashicat-metadata
	consul config delete -kind service-router -name hashicat-metadata
	consul config delete -kind service-router -name hashicat

clean: clean_consul_configs
	kubectl delete -f ./v1-simple/k8s
	kubectl delete -f ./v2-python/k8s-connect
	kubectl delete -f ./v3-python-go/k8s-connect

.PHONY: clean