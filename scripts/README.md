### Building and Running the image
- Edit [Dockerfile](scripts/Dockerfile) if needed
```
docker build -t <user_name>/hashicat:0.0.1 .
docker run -dit -p 8080:80 <user_name>/hashicat:0.0.1
```
- Open browser to localhost:8080