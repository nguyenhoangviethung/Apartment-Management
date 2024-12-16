from werkzeug.security import generate_password_hash, check_password_hash
from models.models import Users
from api.extensions import db
import logging

class UserService:
    def __init__(self):
        self.logger = logging.getLogger(__name__)

    def get_id(self, user: Users):
        return user.user_id 
        
    def set_password(self, user: Users, password):
        user.password_hash = generate_password_hash(password)

    def check_password(self, user: Users, password):
        return check_password_hash(user.password_hash, password)
    
    def update_role(self, user_id):
        try:
            user = db.session.query(Users).filter_by(user_id = user_id).first()
            setattr(user, 'user_role', 'admin')
            db.session.commit()
            return ("message': 'role updated successfully !!"), 200
        except Exception as e:
            return ({'error': f'Unexpected error: {e}'}), 500
        
    def show_all_users(self):
        users = Users.query.all()
        user_list = []
        for user in users:
            user_data = {
                'user_id' : user.user_id,
                'username' : user.username,
                'user_role' : user.user_role,
                'user_email': user.user_email,
                'phone_number': user.phone_number,
            }
            user_list.append(user_data)
        return user_list    

        