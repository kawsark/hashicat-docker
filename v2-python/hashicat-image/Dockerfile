FROM python:3.8-slim-buster
WORKDIR /
ADD ./hashicat-image.py /app.py
RUN pip install Flask
ENV FLASK_APP /app.py
EXPOSE 5000
CMD [ "python", "-m", "flask", "run", "--host=0.0.0.0" ]
