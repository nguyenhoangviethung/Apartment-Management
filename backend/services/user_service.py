from werkzeug.security import generate_password_hash, check_password_hash
from models.models import Users
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