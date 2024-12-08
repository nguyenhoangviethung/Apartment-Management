from api.models.models import Contributions
from api.extensions import db
from datetime import datetime

def add_contribution_fee(contribution_fee: Contributions):
    db.session.add(contribution_fee)
    db.session.commit()