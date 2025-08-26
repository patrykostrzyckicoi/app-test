from flask import Flask, jsonify
import random

QUOTES = [
    "Nie ma rzeczy niemozliwych.",
    "Kazda wielka podroz zaczyna sie od jednego kroku.",
    "Kod, ktory sie nie zmienia, jest martwy."
]

def create_app() -> Flask:
    app = Flask(__name__)

    @app.route("/health")
    def health():
        return jsonify(status="ok")

    @app.route("/quote")
    def quote():
        return jsonify(quote=random.choice(QUOTES))

    return app

if __name__ == "__main__":
    create_app().run(host="0.0.0.0", port=9000)
