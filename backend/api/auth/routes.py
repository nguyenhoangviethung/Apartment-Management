from flask import Blueprint, request, jsonify, url_for,current_app
from flask_jwt_extended import create_access_token
from flask_mail import Mail, Message
import jwt, datetime
from ..models.models import db, Users
import uuid
from werkzeug.security import generate_password_hash

auth = Blueprint('auth', __name__, url_prefix='/auth')

@auth.route('/register', methods=['POST','GET'])
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
    
    token = jwt.encode(
        payload = {
            'email': email,
            'user_name': user_name,
            'password': password,
            'exp': datetime.datetime.utcnow() + datetime.timedelta(hours=1)
        },
        key = current_app.config['SECRET_KEY'],
        algorithm='HS256'
    )

    confirm_link = url_for('auth.confirm_email', token=token, _external=True)
    try:
        mail = Mail(current_app)
        msg = Message(
            subject = 'confirm_email',
            body = f'''Please confirm your email address!
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

@auth.route('/confirm_email/<token>', methods=['POST','GET'])
def confirm_email(token):
    try:
        data = jwt.decode(token, current_app.config['SECRET_KEY'], algorithms='HS256')

        email = data.get('email')
        user_name = data.get('user_name')
        password = data.get('password')

        new_user = Users(
            user_id = uuid.uuid4().bytes,
            username = user_name,
            password_hash = generate_password_hash(password),
            user_email = email
        )

        db.session.add(new_user)
        db.session.commit()

        return jsonify({"message": "user registration successful"}), 200
    except jwt.InvalidTokenError:
        return jsonify({'message': 'Token invalid!'}), 400
    except jwt.ExpiredSignatureError:
        return jsonify({"message": "Token expired!"}), 400
    
    
