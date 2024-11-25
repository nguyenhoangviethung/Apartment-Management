from api.models.models import Fees, Households, Residents
from api.extensions import db
from datetime import datetime

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

def get_current_household_fee(household_id):
       now = datetime.now().date()
       return db.session.query(Fees).filter(Fees.household_id == household_id, now <= Fees.due_date).first()

def user_get_current_fee(resident_id):
    households_id = db.session.query(Residents.household_id).filter(Residents.resident_id == resident_id).scalar()
    return get_current_household_fee(households_id)