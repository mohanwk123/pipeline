from flask import Flask
import psycopg2

app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello, World! Deployed via CI/CD Pipeline!"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
