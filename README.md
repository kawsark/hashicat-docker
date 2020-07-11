# hashicat-docker
A repo for the Kittens-as-a-service Hashicat application to be deployed as containers. The corresponding blog post for this application is here: [Kittens-as-a-Service: Layer 7 Traffic Management & Security with Consul Connect](https://medium.com/hashicorp-engineering/kittens-as-a-service-layer-7-traffic-management-security-with-consul-connect-f5965fac5aa?source=friends_link&sk=ad4b747d7f71889772569cb7f069b8ad)

There are a few versions of the Hashicat application in this repo. 
- [V1: simple](v1-simple/) - The Hashicat application in a Docker container.
- [V2: python](v2-python/) - This version contains two services, a python web client and a phyton api that returns image URL and metadata.
- [V3: python and go](v3-python-go/) - This version contains three services, a python web client, a Go API to return image URL, and a Go API to return image metadata.
