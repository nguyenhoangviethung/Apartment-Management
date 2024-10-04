from flask import Blueprint, request, jsonify
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
    
    new_user = Users(
        user_id = uuid.uuid4().bytes,
        username = user_name,
        password_hash = generate_password_hash(password),
        user_email = email
    )

    db.session.add(new_user)
    db.session.commit()

    return jsonify({"message": "user registration successful"}), 200

    
