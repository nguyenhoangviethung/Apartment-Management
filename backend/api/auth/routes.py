from flask import Blueprint, request, jsonify, url_for,current_app, session
from flask_jwt_extended import create_access_token
from flask_mail import Mail, Message
import jwt, datetime
from ..models.models import *
import uuid
from werkzeug.security import generate_password_hash
from api.auth import auth_bp
import re, dns.resolver

@auth_bp.route('/register', methods=['POST','GET'])
def register():
    print('register called')
    user_name = request.form.get('user_name')
    password = request.form.get('password')
    email = request.form.get('email')

    regex = r'^\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b'
    if re.match(regex, email) is None:
        return jsonify({'error': 'Invalid email address'})
    
    password_hash = generate_password_hash(password)
    check = Users.query.filter_by(username = user_name).first()
    if check:
        return jsonify({"error": "user_name already exists"}), 400
    check = Users.query.filter_by(user_email = email).first()
    if check:
        return jsonify({"error": "user_email already exists"}), 400
    
    token = jwt.encode(
        payload = {
            'email': email,
            'user_name': user_name,
            'password_hash': password_hash,
            'exp': datetime.datetime.utcnow() + datetime.timedelta(hours=1)
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
            sender = 'nguyenhoangviethung@gmail.com',
            recipients = [email]
        )
        mail.send(msg)
        return jsonify({'message': 'send confirm-email success'})
    except Exception as e:
        return jsonify({'message': 'send confirm-email failure', 'error': str(e)})
    

@auth_bp.route('/confirm_email/<token>', methods=['POST','GET'])
def confirm_email(token):
    try:
        data = jwt.decode(token, current_app.config['SECRET_KEY'], algorithms='HS256')

        email = data.get('email')
        user_name = data.get('user_name')
        password_hash = data.get('password_hash')

        new_user = Users(
            user_id = uuid.uuid4().bytes,
            username = user_name,
            password_hash = password_hash,
            user_email = email
        )

        db.session.add(new_user)
        db.session.commit()

        return jsonify({"message": "user registration successful"}), 200
    except jwt.InvalidTokenError:
        return jsonify({'message': 'Token invalid!'}), 400
    except jwt.ExpiredSignatureError:
        return jsonify({"message": "Token expired!"}), 400
    
    
