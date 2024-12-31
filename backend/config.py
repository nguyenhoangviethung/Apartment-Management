import os
from dotenv import load_dotenv

load_dotenv()

class Config:
    SECRET_KEY = os.getenv('SECRET_KEY')
    SQLALCHEMY_DATABASE_URI = os.getenv('SQLALCHEMY_DATABASE_URI')
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    JSON_SORT_KEYS = os.getenv('JSON_SORT_KEYS')
    MAIL_SERVER = 'smtp.gmail.com'
    MAIL_PORT = 465
    MAIL_USERNAME = os.getenv('MAIL_USERNAME')
    MAIL_PASSWORD = os.getenv('APP_PASSWORD')
    MAIL_USE_SSL = True
    MAIL_USE_TLS = False
    SWAGGER_URL = os.getenv('SWAGGER_URL')
    API_URL = os.getenv('API_URL')
    API_SECRET_CLOUDINARY = os.getenv('API_SECRET_CLOUDINARY')
    API_PUBLIC_CLOUDINARY = os.getenv('API_PUBLIC_CLOUDINARY')
    CLOUD_NAME_CLOUDINARY = os.getenv('CLOUD_NAME_CLOUDINARY')
    API_ENV_VAR = os.getenv('API_ENV_VAR')