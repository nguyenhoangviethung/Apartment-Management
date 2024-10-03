from flask import Flask
from config import Config
from api.extensions import db
from api.models.models import *

def create_app(config_class=Config):
    app = Flask(__name__, instance_relative_config=True)
    app.config.from_object(config_class)

    db.init_app(app)
    with app.app_context():
        db.create_all()

    from api.auth import auth_bp
    app.register_blueprint(auth_bp)

    @app.route('/test')
    def test():
        return '<h1>THIS IS TEST FROM INIT</h1>'
    
    return app