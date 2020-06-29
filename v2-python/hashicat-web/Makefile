.DEFAULT_GOAL := all

tag = 0.0.1
docker_username = kawsark
name = hashicat-web

all: clean build start

build: clean
	docker build -t $(docker_username)/$(name):$(tag) .

start: 
	docker rm -f $(name) || true
	docker run -dit \
	  --name $(name) \
	  -e URLSERVICE_URI="http://localhost:30010/url" \
	  -e METADATA_URI="http://localhost:30010/metadata" \
	  -p 30011:5000 $(docker_username)/$(name):$(tag)
	docker port $(name)
	echo "Access the app at forwarded port"

start_local:
	FLASK_APP=./hashicat-web.py python3 -m flask run --host=0.0.0.0

clean:
	docker rm -f $(name) || true
	docker rmi $(docker_username)/$(name):$(tag) || true

push: build
	docker push $(docker_username)/$(name):$(tag)

.PHONY: clean build start push