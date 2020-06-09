FROM python:3.8-slim-buster
WORKDIR /hashicat-web
RUN apt-get update -y; apt-get install dnsutils -y
ADD hashicat-web.py /hashicat-web/hashicat-web.py
ADD static /hashicat-web/static
ADD templates /hashicat-web/templates
RUN pip install Flask
RUN pip install requests
ENV FLASK_APP /hashicat-web/hashicat-web.py
EXPOSE 5000
CMD [ "python", "-m", "flask", "run", "--host=0.0.0.0" ]
#CMD [ "/bin/sleep", "300"]
