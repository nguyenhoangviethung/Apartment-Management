from api.models.models import Fees, Households
from api.extensions import db

def add_fee(fee: Fees):
    db.session.add(fee)
    db.session.commit()

def get_unpaid_fees(date):
        return db.session.query(
            Fees.fee_id, 
            Fees.household_id, 
            Fees.service_rate, 
            Fees.manage_rate, 
            Fees.due_date,
            Households.area,
            Fees.description
        ).join(
            Households, 
            Fees.household_id == Households.household_id
        ).filter(
            Fees.status == 'Chưa thanh toán', 
            Fees.due_date >= date
        ).all()

def get_householdID(fee_id):
        return db.session.query(
            Fees.household_id
        ).filter(
            Fees.fee_id == fee_id
        ).all()