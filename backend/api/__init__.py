from flask import Flask
from backend.config import Config

def create_app(config_class=Config):
    app = Flask(__name__, instance_relative_config=True)
    app.config.from_object(config_class)

    @app.route('/test')
    def test():
        return '<h1>THIS IS TEST FROM INIT</h1>'
    
    return app