from flask import Flask
from config import Config
from .models.models import db

def create_app(config_class=Config):
    app = Flask(__name__, instance_relative_config=True)
    app.config.from_object(config_class)
    
    db.init_app(app)

    from api.auth import routes
    app.register_blueprint(routes.auth)
    return app