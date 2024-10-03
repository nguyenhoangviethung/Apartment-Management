from api.auth import auth_bp
from api.extensions import db
from sqlalchemy import select
from api.models.models import *
from flask import g, redirect, url_for, session, abort, request
from functools import wraps



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

@auth_bp.post('/add')
def add():
    name, password = request.form['user_name'], request.form['password']
    user = db.session.query(Users).filter_by(user_name=name, password_hash=password).one_or_none()
    if user is None:
        return "somthing went wrong"
    
    session.clear()
    session.setdefault('user_id', user.user_id)
    session.setdefault('user_role', user.user_role)

    return "PASS LOGIN"

@auth_bp.route('/admin')
@admin_required
def admin():
    return "admin"

@auth_bp.route('/logout')
def logout():
    session.clear()
    return "clear session"

@auth_bp.route('/login')
@login_require
def login():
    return "access success"

