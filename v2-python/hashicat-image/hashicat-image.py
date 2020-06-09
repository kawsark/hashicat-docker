import os
import json
from flask import Flask
app = Flask(__name__)

HTML = """
This is the image service. Try hitting /url or /metadata endpoints.
"""

# Welcome page
@app.route('/')
def main():
    return HTML

# Send the url
@app.route('/url')
def url():
    url_str = os.getenv('HASHICAT_URL','http://placekitten.com/800/600')
    url = { "url" : url_str }

    results_dict = {
        "name":"hashicat-image-url",
        "type":"HTTP",
        "body": url
    }

    return json.dumps(results_dict)

# Send the metadata
@app.route('/metadata')
def metadata():
    metadata_str = os.getenv('HASHICAT_META','Welcome to this Meowlicious app')
    metadata = { "caption" : metadata_str }

    results_dict = {
        "name":"hashicat-image-metadata",
        "type":"HTTP",
        "body": metadata
    }

    return json.dumps(results_dict)

