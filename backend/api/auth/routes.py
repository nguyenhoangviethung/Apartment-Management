from api.auth import auth_bp
from api.extensions import db
from api.models.models import *
from flask import g, url_for, session, abort, request, jsonify, current_app, flash, redirect
from functools import wraps
from flask_mail import Mail, Message
import jwt, datetime
from werkzeug.security import generate_password_hash, check_password_hash
from flask_login import login_user
import re, dns.resolver
import os
from dotenv import load_dotenv
import random

load_dotenv()

def login_require(f):
    @wraps(f)
    def wrap(*args, **kwargs):
        if g.get('user') is None:
            # unauthorized
            return jsonify({"message" : "Check login fail"}), 403
        return f(*args, **kwargs)
    
    return wrap

def admin_required(f):
    @wraps(f)
    def wrap(*args, **kwargs):
        if not g.get('user') or g.get('user').user_role != 'admin':
            # forbidden
            return jsonify({"message": "you are not admin"}), 403  
        return f(*args, **kwargs)
    return wrap

@auth_bp.before_app_request
def check_attribute():
    user_id = session.get('user_id')
    if user_id:
        g.user = db.session.query(Users).filter_by(user_id=user_id).one_or_none()
    else:
        g.user = None

@auth_bp.post('/register')
def register():
    # print('register called')
    username = request.form.get('username')
    password = request.form.get('password')
    email = request.form.get('email')
    
    password_hash = generate_password_hash(password)
    check = Users.query.filter_by(username = username).first()
    if check:
        return jsonify({"error": "username already exists"}), 400
    check_mail = Users.query.filter_by(user_email = email).first()
    if check_mail:
        return jsonify({"error": "user_email already exists"}), 400
    
    regex = r'^\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b'
    if re.match(regex, email) is None:
        return jsonify({'error': 'Invalid email address'}), 400
     
    token = jwt.encode(
        payload = {
            'email': email,
            'username': username,
            'password_hash': password_hash,
            'exp': datetime.datetime.now(datetime.timezone.utc) + datetime.timedelta(hours=1)
        },
        key = current_app.config['SECRET_KEY'],
        algorithm='HS256'
    )

    confirm_link = url_for('auth.confirm_email', token=token, _external=True)
    try:
        domain = email.split('@')[1]
        record = dns.resolver.resolve(domain, 'MX')
        mail = Mail(current_app)
        msg = Message(
            subject = 'confirm_email DO NOT SEND THIS EMAIL TO ANY OTHER!!!',
            body = f'''
            Please confirm your email address!
            Click here to confirm your email address
            {confirm_link}
            ''',
            sender = os.getenv('MAIL_USERNAME'),
            recipients = [email]
        )
        mail.send(msg)
        # success
        return jsonify({'message': 'send confirm-email success'}), 200
    except Exception as e:
        # server error
        return jsonify({'message': 'send confirm-email failure', 'error': str(e)}), 500
    
@auth_bp.route('/confirm_email/<token>', methods=['POST','GET'])
def confirm_email(token):
    try:
        data = jwt.decode(token, current_app.config['SECRET_KEY'], algorithms='HS256')

        email = data.get('email')
        username = data.get('username')
        password_hash = data.get('password_hash')

        new_user = Users(
            username = username,
            password_hash = password_hash,
            user_email = email
        )

        db.session.add(new_user)
        db.session.commit()

        return jsonify({"message": "user registration successful"}), 200
    except jwt.InvalidTokenError:
        # user error
        return jsonify({'message': 'Token invalid!'}), 401
    except jwt.ExpiredSignatureError:
        # user error
        return jsonify({"message": "Token expired!"}), 401

@auth_bp.route('/login', methods=('GET', "POST"))
def login_post():
    if request.method == 'POST':
        username = request.form.get('username')
        password = request.form.get('password')
        remember = False
        if request.form.get('remember') == 'True':
            remember = True
            print('remember is True')
        user = Users.query.filter_by(username = username).first()

        # check if the user actually exists
        if not user or not check_password_hash(user.password_hash, password):
            flash('Please check your login details and try again.')
            return jsonify({"message" : "login failed"}), 403
        
        session.clear()    
        session.setdefault('user_id', user.user_id)
        session.setdefault('user_role', user.user_role)
        
        
        login_user(user, remember=remember)
        
        return jsonify({"message": "login successful"}), 200
    return jsonify({"message": "Login page loaded"}), 200
    
@auth_bp.route('/forgot-password', methods=['GET', 'POST'])
def forgot_password():
    if request.method == 'POST':
        email = request.form.get('email')
        
        user = Users.query.filter_by(user_email=email).one_or_none()
        if user is None:
            return jsonify({"message": "No account registered with this email!!"}), 404
        else:
            validation_code = str(random.randint(1000, 9999))
            session['validation_code'] = validation_code
            session['reset_email'] = email

            mail = Mail(current_app)
            msg = Message(
                'Code for validation',
                recipients=[email],  # email passed from the form
                body=f'Your password reset code is: {validation_code}',
                sender = os.getenv('MAIL_USERNAME')
            )

            mail.send(msg)
            flash('Reset code has been sent to your email!')

            return jsonify({"message": "Mail sent successful"}), 200
    
@auth_bp.route('/validation-code', methods=['GET', 'POST'])
def validation():
    if request.method == 'POST':
        input_code = request.form.get('code')

        stored_code = session.get('validation_code')

        # Check if the entered code matches the stored code
        if input_code != stored_code:
            flash('Invalid code. Please try again.')
            return jsonify({"message": "invalid code"}), 400
        else:
            flash('Code validated successfully! Now you can reset your password.')
            session.pop('validation_code', None)
            return jsonify({"message": "validate successfully"}), 200  # Example: redirect to reset password page

@auth_bp.route('/reset-password', methods=['GET', 'POST'])
def validation_code():
    if request.method == 'POST':
        new_password = request.form.get('new_password')
        stored_email = session.get('reset_email')
        
        user = Users.query.filter_by(user_email=stored_email).first()
        user.set_password(new_password)
        
        db.session.commit()
        session.pop('reset_email', None)
        return jsonify({"message" :"Password has been reset!!!"}), 200
    
@auth_bp.route('/logout')
def logout():
    session.clear()

    return jsonify({"message": "logout"}), 200

