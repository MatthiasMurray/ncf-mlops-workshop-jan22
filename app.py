import os
import json
from flask import Flask, request, Response
import spacy

app = Flask(__name__)

nlp = spacy.load('en_textcat_goemotions')

@app.route("/")
def hello_world():
    name = os.environ.get("NAME", "World")
    return "Hello {}!".format(name)

@app.route('/predict', methods=['POST'])
def predict():
    content = request.json
    resp = content["response"]
    out = nlp(resp).cats
    return Response(json.dumps(out),  mimetype='application/json')


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=int(os.environ.get("PORT", 8080)))