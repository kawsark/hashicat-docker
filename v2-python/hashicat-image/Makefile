.DEFAULT_GOAL := all

tag = 0.0.1
docker_username = kawsark
name = hashicat-image

all: clean build start

build: 
	docker build -t $(docker_username)/$(name):$(tag) .

start: 
	docker rm -f $(name) || true
	docker run -dit \
	  --name $(name) \
	  -e HASHICAT_URL="http://placekitten.com/800/800" \
	  -e HASHICAT_META="Welcome to Garfield's Meowlicious app" \
	  -p 30010:5000 $(docker_username)/$(name):$(tag)
	docker port $(name)
	echo "Access the app at forwarded port"

clean:
	docker rm -f $(name) || true
	docker rmi $(docker_username)/$(name):$(tag) || true

push: build
	docker push $(docker_username)/$(name):$(tag)

.PHONY: clean build start push