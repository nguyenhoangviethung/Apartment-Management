from api.auth import auth_bp
from api.extensions import db
from sqlalchemy import select
from api.models.models import *
from flask import g, redirect, url_for, request, session
from functools import wraps



def login_require(f):
    @wraps(f)
    def wrap(*args, **kwargs):
        if g.get('user') is None:
            return redirect(url_for(endpoint='test'))
        return f(*args, **kwargs)
    
    return wrap

def admin_require(f):
    @wraps(f)
    def wrap(*args, **kwargs):
        if g.get('role') != 'admin':
            return "KHONG PHAI ADMIN"
        return f(*args, **kwargs)
    
    return wrap

@auth_bp.route('/login', methods=('GET', 'POST'))
def login():
    if request.method == 'POST':
        name, password, role = request.form['user_name'], request.form['password_hash'], request.form['role']
        user = db.session.query(Users, Users.user_id, Users.user_role).filter_by(user_name=name, password_hash=password).one_or_none()
        if user is None:
            return "CO GI DO DEO DUNG"
        session.clear()
        session['user_id'] = user.__getattr__('user_id')
        session['role'] = user.__getattr__('user_role')
        return "OKE ROI NHE"

@auth_bp.before_app_request
def check():
    user_id = session.get('user_id')
    role = session.get('role')
    if user_id is None:
        g.user = None
    else:
        g.user = db.session.query(Users).filter_by(user_id=user_id)
        g.role = db.session.query(Users.user_role).filter_by(user_id=user_id)

@auth_bp.route('/logout')
def logout():
    session.clear()

    return "da xoa session"

@auth_bp.route('/test-login')
@login_require
def test_login():
    return "MAY DA DANG NHAP ROI NHE"

@auth_bp.route('/test-admin')
@admin_require
def test_admin():
    return "MAY CHINH LA ADMIN"