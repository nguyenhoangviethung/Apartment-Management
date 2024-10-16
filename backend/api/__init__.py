from flask import Flask
from config import Config
from api.extensions import db, migrate
from api.models.models import *
from api.models.models import db
from flask_login import LoginManager
from flask_swagger_ui import get_swaggerui_blueprint
from flask_cors import CORS


def create_app(config_class=Config):
    app = Flask(__name__, instance_relative_config=True)
    app.config.from_object(config_class)

    db.init_app(app)
    migrate.init_app(app, db)
    with app.app_context():
        db.create_all()

    from api.auth import auth_bp
    app.register_blueprint(auth_bp)

    login_manager = LoginManager()
    login_manager.login_view = 'auth.login'
    login_manager.init_app(app)

    CORS(app)
    @login_manager.user_loader
    def load_user(user_id):
        return Users.query.get(user_id)
    
    swagger_bp = get_swaggerui_blueprint(app.config.get('SWAGGER_URL'), app.config.get('API_URL'), config={'app_name': 'auth api'})
    app.register_blueprint(swagger_bp, url_prefix= app.config.get('SWAGGER_URL'))                                       

    from api.admin import admin_bp
    app.register_blueprint(admin_bp)

    from api.pay import pay_bp
    app.register_blueprint(pay_bp)

    @app.route('/')
    def test():
        return '<h1>THIS IS INDEX FROM INIT</h1>'
    
    return app