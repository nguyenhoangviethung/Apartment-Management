from api.auth import auth_bp
from api.extensions import db
from sqlalchemy import select
from api.models.models import *
from flask import g, redirect, url_for, session, abort, request
from functools import wraps
from flask import Blueprint, request, jsonify
from ..models.models import db, Users
import uuid
from werkzeug.security import generate_password_hash


def login_require(f):
    @wraps(f)
    def wrap(*args, **kwargs):
        if g.get('user') is None:
            # unauthorized
            return redirect(url_for(endpoint='test'), code=401)
        return f(*args, **kwargs)
    
    return wrap

def admin_required(f):
    @wraps(f)
    def wrap(*args, **kwargs):
        if not g.get('user') or g.get('user').user_role != 'admin':
            # forbidden
            return abort(403)  
        return f(*args, **kwargs)
    return wrap

@auth_bp.before_app_request
def check_attribute():
    user_id = session.get('user_id')
    if user_id:
        g.user = db.session.query(Users).filter_by(user_id=user_id).one_or_none()
    else:
        g.user = None



@auth_bp.route('/register', methods=['POST','GET'])
def register():
    print('register called')
    data = request.get_json()

    user_name = data.get('user_name')
    password = data.get('password')
    email = data.get('email')

    check = Users.query.filter_by(username = user_name).first()
    if check:
        return jsonify({"error": "user_name already exists"}), 400
    check = Users.query.filter_by(user_email = email).first()
    if check:
        return jsonify({"error": "user_email already exists"}), 400
    
    new_user = Users(
        user_id = uuid.uuid4().bytes,
        username = user_name,
        password_hash = generate_password_hash(password),
        user_email = email
    )

    db.session.add(new_user)
    db.session.commit()

    return jsonify({"message": "user registration successful"}), 200

    
