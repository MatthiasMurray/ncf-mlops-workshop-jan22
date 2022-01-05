import os
from flask import Flask, request
import spacy

nlp = spacy.load('en_textcat_goemotions')

app = Flask(__name__)

@app.route("/", methods=['GET'])
def func():
    content = request.json
    resp = content["response"]
    out = nlp(resp).cats
    return out

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=int(os.environ.get("PORT", 5000)))