from flask import Blueprint

admin_bp = Blueprint(name='admin', import_name=__name__, url_prefix='/admin')

from api.admin import routes