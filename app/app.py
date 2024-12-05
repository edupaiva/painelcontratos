from flask import Flask

app = Flask(__name__)

# Definição de uma rota simples
@app.route('/')
def hello():
    return 'Hello, World!'

if __name__ == "__main__":
    app.run(debug=True, use_reloader=True, host="0.0.0.0", port=8012)