from werkzeug.security import generate_password_hash, check_password_hash
from api.models.models import Users

def get_id(user: Users):
    return user.user_id 
    
def set_password(user: Users, password):
    user.password_hash = generate_password_hash(password)

def check_password(user: Users, password):
    return check_password_hash(user.password_hash, password)