from werkzeug.security import generate_password_hash, check_password_hash
from models.models import Users, Residents
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
    
    def get_username(self, user_id):
        user = db.session.query(Users).filter(Users.user_id == user_id).first()
        return user.username
    
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

    def convert_to_resident(self, data, id):    
        try:
            resident = db.session.query(Residents).filter_by(resident_id = id).first()
            if not resident:
                return("message: resident not found"), 404
            if resident.user_id != None:
                return ("message: 'this resident is already an user"), 403
            setattr(resident, 'user_id', data.get('user_id'))
            db.session.commit()
            return ("message': 'role updated successfully !!"), 200
        except Exception as e:
            db.session.rollback()
            return ({'error': f'Unexpected error: {e}'}), 500
