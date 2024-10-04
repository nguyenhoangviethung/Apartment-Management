class Config:
    SECRET_KEY = 'dev'
    SQLALCHEMY_DATABASE_URI = 'mysql+pymysql://root:Dungdepzai1!@localhost/cnpm'
    SQLALCHEMY_TRACK_MODIFICATIONS = False

    MAIL_SERVER = 'smtp.gmail.com'
    MAIL_PORT = 465
    MAIL_USERNAME = 'nguyenhoangviethung@gmail.com'
    MAIL_PASSWORD = 'bfrq ebrv avbi jzqx'
    MAIL_USE_SSL = True
    MAIL_USE_TLS = False