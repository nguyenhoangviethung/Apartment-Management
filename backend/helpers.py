from flask import request
import jwt
from config import Config
from decimal import Decimal
from datetime import datetime
from sqlalchemy import event, func
from sqlalchemy.orm import sessionmaker
from models.models import *
from api.extensions import db

def getIP():
    client_ip = request.headers.get('X-Forwarded-For', request.remote_addr)

    return client_ip

def validate_token():
    bearer = request.headers.get('Authorization')
    
    if not bearer:
        return False
    else:
        token = bearer.split()[-1]
        try:
            validate = jwt.decode(token, key=Config.SECRET_KEY, algorithms='HS256')
            return True
        except:
            return False
        
def get_payload():
    if not validate_token():
        return None
    
    bearer = request.headers.get('Authorization')
    token = bearer.split()[-1]
    payload = jwt.decode(token, key=Config.SECRET_KEY, algorithms='HS256')

    return payload

def decimal_to_float(value):
    """Chuyển đổi Decimal sang float để serialization JSON."""
    return float(value) if isinstance(value, Decimal) else value

def validate_date(date_string):
    """Kiểm tra và chuyển đổi chuỗi ngày."""
    try:
        return datetime.strptime(date_string, '%Y-%m-%d').date()
    except ValueError:
        raise ValueError("Invalid date format. Use YYYY-MM-DD")
    
def update_num_residents(mapper, connection, target):
    
    # Count residents associated with the household_id of the changed Resident
    num_residents = db.session.query(func.count(Residents.resident_id)).filter_by(household_id=target.household_id).scalar()
    
    # Update num_residents in Households
    connection.execute(
        Households.__table__.update()
        .where(Households.household_id == target.household_id)
        .values(num_residents=num_residents)
    )
# Attach the event listeners for Residents insert, delete, and update actions
event.listen(Residents, 'after_insert', update_num_residents)
event.listen(Residents, 'after_delete', update_num_residents)
event.listen(Residents, 'after_update', update_num_residents)    
        