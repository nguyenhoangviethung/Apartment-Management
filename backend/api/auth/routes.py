from api.auth import auth_bp
from api.extensions import db
from sqlalchemy import select
from api.models.models import *
from flask import g, redirect, url_for, session, abort, request, jsonify, current_app
from functools import wraps
from flask_jwt_extended import create_access_token
from flask_mail import Mail, Message
import jwt, datetime
import uuid
from werkzeug.security import generate_password_hash
from flask import flash, redirect, render_template, request, url_for, session
from werkzeug.security import generate_password_hash, check_password_hash
from flask_login import login_user
from flask_mail import Message
from api.extensions import mail

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
    # print('register called')
    

    user_name = request.form['user_name']
    password = request.form['password']
    email = request.form['email']

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
            'exp': datetime.datetime.now() + datetime.timedelta(hours=1)
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

@auth_bp.route('/confirm_email/<token>', methods=['POST','GET'])
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
    
    


@auth_bp.route('/')
def index():
    return render_template('auth/index.html')

@auth_bp.route('/login')
def login():
    return render_template('auth/login.html')

@auth_bp.route('/login', methods=['POST'])
def login_post():
    
    username = request.form.get('username')
    password = request.form.get('password')
    remember = True if request.form.get('remember') else False

    user = db.query(Users).filter_by(username = username).first()

    # check if the user actually exists
    if not user or not check_password_hash(user.password_hash, password):
        flash('Please check your login details and try again.')
        return redirect(url_for('auth.login'),code = 401) # if the user doesn't exist or password is wrong, reload the page
    session.clear()    
    session.setdefault('user_id',user.user_id)
    session.setdefault('user_role',user.user_role)
    
    
    login_user(user, remember=remember)

   
    return redirect(url_for('main.index'))

@auth_bp.route('/forgot_password/', methods=['GET', 'POST'])
def forgot_password():
    if request.method == 'POST':
        email = request.form.get('email')
        
        user = db.query(Users).filter_by(email=email).first()
        if not user:
            flash('No account registered with this email!!')
            return redirect(url_for('auth.forgot_password'))

        msg = Message(
            'Code for validation',
            recipients=[email],  # email passed from the form
            body='Your password reset code is: 123456'
        )
        mail.send(msg)
        flash('Reset code has been sent to your email!')
        return redirect(url_for('auth.login'))
    
    return render_template('auth/forgot_password.html')
