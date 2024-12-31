from flask import jsonify, request, current_app
import jwt
from functools import wraps
from helpers import get_payload, validate_token
import logging
from sqlalchemy.exc import SQLAlchemyError
from api.extensions import db

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def login_require(f):
    @wraps(f)
    def wrap(*args, **kwargs):
        if not validate_token():
            return jsonify({'message': 'you have not loged in'}), 403

        return f(*args, *kwargs)
    return wrap

def admin_required(f):
    @wraps(f)
    def wrap(*args, **kwargs):
        if not get_payload():
            return jsonify({'message': 'token error'}), 401
        
        payload = get_payload()
        user_role = payload.get('role')
        if user_role not in ('admin', 'sadmin'):
            return jsonify({'message': 'you are not admin'}), 403
        
        return f(*args, **kwargs)
        
    return wrap

def token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        if not get_payload():
            return jsonify({'message': 'token error'}), 401
        
        data = get_payload()

        return f(data, *args, **kwargs)

    return decorated

def handle_exceptions(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        try:
            return f(*args, **kwargs)
        except SQLAlchemyError as e:
            logger.error(f"Database error: {str(e)}")
            db.session.rollback()
            return jsonify({'error': 'Database error occurred'}), 500
        except Exception as e:
            logger.error(f"Unexpected error: {str(e)}")
            return jsonify({'error': 'An unexpected error occurred'}), 500
    return decorated_function