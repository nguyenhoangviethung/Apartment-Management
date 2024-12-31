from flask_sqlalchemy import SQLAlchemy
from flask_mail import Mail
from flask_migrate import Migrate
import cloudinary
import cloudinary.uploader
from cloudinary.utils import cloudinary_url
from config import Config

db = SQLAlchemy()
mail = Mail()
migrate = Migrate()

