from flask import Blueprint

pay_bp = Blueprint(name='pay', import_name=__name__, url_prefix='/pay')

from api.pay import routes