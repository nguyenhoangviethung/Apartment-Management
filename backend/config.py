import os
from dotenv import load_dotenv

load_dotenv()

class Config:
    SECRET_KEY = os.getenv('SECRET_KEY')
    SQLALCHEMY_DATABASE_URI = os.getenv('SQLALCHEMY_DATABASE_URI')
    SQLALCHEMY_TRACK_MODIFICATIONS = False

    MAIL_SERVER = 'smtp.gmail.com'
    MAIL_PORT = 465
    MAIL_USERNAME = os.getenv('MAIL_USERNAME')
    MAIL_PASSWORD = 'pofr qfsm ivkw jyvr'
    MAIL_USE_SSL = True
    MAIL_USE_TLS = False
    SWAGGER_URL = os.getenv('SWAGGER_URL')
    API_URL = os.getenv('API_URL')