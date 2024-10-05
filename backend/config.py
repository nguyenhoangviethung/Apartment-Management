import os
from dotenv import load_dotenv

load_dotenv()

class Config:
    SECRET_KEY = 'dev'
    SQLALCHEMY_DATABASE_URI = 'mysql+pymysql://'+ os.getenv('MYSQL_USER') + ':' + os.getenv('MYSQL_PASSWORD') + '@localhost/'+ os.getenv('MYSQL_DATABASE')
    SQLALCHEMY_TRACK_MODIFICATIONS = False

    MAIL_SERVER = 'smtp.gmail.com'
    MAIL_PORT = 465
    MAIL_USERNAME = 'nguyenhoangviethung@gmail.com'
    MAIL_PASSWORD = 'bfrq ebrv avbi jzqx'
    MAIL_USE_SSL = True
    MAIL_USE_TLS = False