FROM httpd:2.4-alpine

COPY deploy_app.sh /deploy_app.sh
RUN ["chmod", "+x", "/deploy_app.sh"]

# Overriding CMD from https://github.com/docker-library/httpd/blob/6c8e82e20ecefc94c616439f15d14c4bb215b200/2.4/alpine/Dockerfile
CMD /deploy_app.sh && httpd-foreground