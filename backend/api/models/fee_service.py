from api.models.models import Fees
from api.extensions import db

def add_fee(fee: Fees):
    db.session.add(fee)
    db.session.commit()