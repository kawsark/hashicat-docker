all: clean

endpoints: config0
	scripts/endpoints.sh

validate:
	scripts/validate.sh

install:
	kubectl apply -f ./v1-simple/k8s
	kubectl apply -f ./v2-python/k8s-connect
	kubectl apply -f ./v3-python-go/k8s-connect

0_deploy:
	kubectl apply -f ./v1-simple/k8s
	scripts/nodeport.sh hashicat-service

1_ingress:
	source "scripts/set_consul_http_addr.sh" \
	  && consul config write ./central_config/ingress1.hcl
	scripts/nodeport.sh ingress-gateway

1_canary:
	kubectl apply -f ./v2-python/k8s-connect
	source "scripts/set_consul_http_addr.sh" \
	  && consul config write ./central_config/ingress2.hcl
	scripts/nodeport.sh ingress-gateway

3_routing:
	kubectl apply -f ./v3-python-go/k8s-connect
	source "scripts/set_consul_http_addr.sh" \
	  && consul config write ./central_config/image-router-url-header.hcl
	scripts/nodeport.sh ingress-gateway

4_blue_green:
	source "scripts/set_consul_http_addr.sh" \
	  && consul config write ./central_config/image-router-url-and-metadata.hcl
	scripts/nodeport.sh ingress-gateway

5_shifting:
	source "scripts/set_consul_http_addr.sh" \
	  && consul config write ./central_config/metadata-resolver.hcl \
	  && consul config write ./central_config/metadata-splitter_0_100.hcl

6_shifting_50:
	source "scripts/set_consul_http_addr.sh" \
	&& consul config write ./central_config/metadata-resolver.hcl \
	&& consul config write ./central_config/metadata-splitter_0_100.hcl

6_shifting_100:
	source "scripts/set_consul_http_addr.sh" \
	&& consul config write ./central_config/metadata-resolver.hcl \
	&& consul config write ./central_config/metadata-splitter_0_100.hcl

consul_info:
	scripts/consul_info.sh

clean:
	kubectl delete -f ./v1-simple/k8s
	kubectl delete -f ./v2-python/k8s-connect
	kubectl delete -f ./v3-python-go/k8s-connect

.PHONY: clean