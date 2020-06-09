### Building and Running the image locally
- Edit [Dockerfile](scripts/Dockerfile) if needed
```
docker build -t <user_name>/hashicat:0.0.1 .
docker run -dit -p 8080:80 <user_name>/hashicat:0.0.1
```
- Open browser to localhost:8080

### Deploying the app on Kubernetes
```
cd k8s
kubectl apply -f hashicat-deployment.yaml
kubectl apply -f hashicat-service.yaml
kubectl get nodes -o wide
kubectl get svc/hashicat-service
```
- Grab the public IP address of any one of the GKE nodes under the `EXTERNAL-IP` column.
- Grab the Node port # from the `hashicat-service` service under the `PORTS` column. It should be in the 30000+ range. E.g. if you see `80:31581/TCP`, then use `31581` as the node port # (your port # will likely be different).
- Now access the application using curl or a browser:
```
curl -s http://<node_host>:<node_port>
```
