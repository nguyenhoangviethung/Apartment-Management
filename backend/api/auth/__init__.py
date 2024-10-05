from flask import Blueprint

auth_bp = Blueprint(name='auth', import_name=__name__, url_prefix='/auth/')

from api.auth import routes
