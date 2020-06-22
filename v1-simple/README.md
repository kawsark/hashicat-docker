### Deploy the app locally on Docker
```
docker run -dit --name hashicat -p 9180:80 kawsark/hashicat:0.0.1
```
- Open browser to localhost:9180

To modify the image properties and caption, you can set the environment variables: `PLACEHOLDER`, `WIDTH`, `HEIGHT`, and `PREFIX`. For example, we will modify the URL and Width below. 
```
docker rm -f hashicat
docker run -dit -p 9180:80 --name hashicat -e PLACEHOLDER=placedog.net -e WIDTH=400 kawsark/hashicat:0.0.1
```
- Alternative URL examples: placedog.net, fillmurray.com, placecage.com, placebeard.it, loremflickr.com, baconmockup.com, placeimg.com, placebear.com, placeskull.com, stevensegallery.com.

### Building and Running the image locally
- Edit [Dockerfile](scripts/Dockerfile) if needed
```
docker build -t <user_name>/hashicat:0.0.1 .
docker run -dit --name hashicat -p 9180:80 <user_name>/hashicat:0.0.1
```
- Open browser to localhost:9180

### Deploying the app on Kubernetes
```
kubectl apply -f k8s
kubectl get nodes -o wide
kubectl get svc/hashicat-service
```
- Grab the public IP address of any one of the GKE nodes under the `EXTERNAL-IP` column.
- Grab the Node port # from the `hashicat-service` service under the `PORTS` column. It should be in the 30000+ range. E.g. if you see `80:31581/TCP`, then use `31581` as the node port # (your port # will likely be different).
- Now access the application using curl or a browser:
```
curl -s http://<node_host>:<node_port>
```
