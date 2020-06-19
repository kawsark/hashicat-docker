import os
import requests
from flask import Flask
app = Flask(__name__)

# Initialization
debug = bool(os.getenv('DEBUG'))
print(debug)

# Load file
HTML_file = open("templates/hashicat.html.tpl")
HTML = HTML_file.read()
HTML_file.close()

#Welcome page
@app.route('/')
def main():
    # Get the hashicat image URL
    urlservice_uri = os.getenv('URLSERVICE_URI','http://localhost:30010/url')
    image_url = get_response(urlservice_uri,"url")

    # Get the hashicat caption
    captionservice_uri = os.getenv('METADATA_URI', 'http://localhost:30010/metadata')
    image_caption = get_response(captionservice_uri,"caption")

    # Check if there is a feature flag to show ratings
    ratings = "<!-- ratings: disabled -->"
    enable_ratings = get_response(captionservice_uri,"enable_ratings")
    if (enable_ratings.lower() in ['true','1','yes']):
        HTML_file = open("templates/stars.html.tpl")
        ratings = HTML_file.read()
        HTML_file.close()

    response = HTML.format(url = image_url, caption = image_caption, ratings = ratings)
    return response

# Retrieve a response from the given endpoint
def get_response(uri,item_key):
    result_key = os.getenv('RESULT_KEY','body')

    if debug:
        print("Trying to reach upstream: %s" % uri)

    response = requests.get(uri).json()

    if debug:
        print("Received json response from upstream: %s" % response)

    if result_key in response and item_key in response[result_key]:
        value = response[result_key][item_key]

    else:
        print("WARN: Could not find the key [%s][%s] or in response json, returning None" %(result_key,item_key))
        value = None

    return value