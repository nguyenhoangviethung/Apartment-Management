class Config:
    SECRET_KEY = 'dev'
    SQLALCHEMY_DATABASE_URI = 'mysql+pymysql://root:nguyentiendung@localhost/cnpm'
    SQLALCHEMY_TRACK_MODIFICATIONS = False