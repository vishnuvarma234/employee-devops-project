from flask import Flask, jsonify

app = Flask(__name__)

@app.route("/")
def home():
    return "🚀 Version 2 - CI/CD Pipeline Working Successfully!"
@app.route("/health")
def health():
    return jsonify({
        "status": "healthy",
        "application": "employee-devops-project",
        "version": "1.0.0"
    })

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)