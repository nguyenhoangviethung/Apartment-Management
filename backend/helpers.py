from flask import request
import jwt
from config import Config
from decimal import Decimal
from datetime import datetime

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
        