from flask import flash, redirect, render_template, request, url_for, session
from app.auth import bp
from werkzeug.security import generate_password_hash, check_password_hash
from app.models.users import User
from flask_login import login_user
from flask_mail import Message
from app.extensions import mail

@bp.route('/')
def index():
    return render_template('auth/index.html')

@bp.route('/login')
def login():
    return render_template('auth/login.html')

@bp.route('/login', methods=['POST'])
def login_post():
    
    username = request.form.get('username')
    password = request.form.get('password')
    remember = True if request.form.get('remember') else False

    user = User.query.filter_by(username = username).first()

    # check if the user actually exists
    if not user or not check_password_hash(user.password_hash, password):
        flash('Please check your login details and try again.')
        return redirect(url_for('auth.login'),code = 401) # if the user doesn't exist or password is wrong, reload the page
    session.clear()    
    session.setdefault('user_id',user.user_id)
    session.setdefault('user_role',user.user_role)
    
    
    login_user(user, remember=remember)

   
    return redirect(url_for('main.index'))

@bp.route('/forgot_password/', methods=['GET', 'POST'])
def forgot_password():
    if request.method == 'POST':
        email = request.form.get('email')
        
        user = User.query.filter_by(email=email).first()
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
