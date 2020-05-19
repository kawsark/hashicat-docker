FROM httpd:2.4-alpine

COPY deploy_app.sh /deploy_app.sh
RUN ["chmod", "+x", "/deploy_app.sh"]
RUN ["/deploy_app.sh"]
