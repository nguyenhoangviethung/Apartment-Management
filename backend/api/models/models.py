from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.dialects.mysql import BINARY, ENUM, INTEGER
from sqlalchemy import ForeignKey
from werkzeug.security import generate_password_hash, check_password_hash
from api.extensions import db
from flask_login import UserMixin

class Users(UserMixin, db.Model):
    __tablename__ = 'Users'
    user_id = db.Column(INTEGER, primary_key=True)
    username = db.Column(db.String(50), unique=True, nullable=False)
    password_hash = db.Column(db.String(512), nullable=False)
    user_role = db.Column(ENUM('admin', 'user'), default='user')
    user_email = db.Column(db.String(100), unique=True)
    last_login = db.Column(db.DateTime)
    def get_id(self):
        return self.user_id 
    def set_password(self, password):
        self.password_hash = generate_password_hash(password)

    def check_password(self, password):
        return check_password_hash(self.password_hash, password)


class Households(db.Model):
    __tablename__ = 'Households'
    household_id = db.Column(INTEGER,  primary_key=True)
    household_name = db.Column(db.String(40))
    apartment_number = db.Column(db.String(10), nullable=False)
    floor = db.Column(db.Integer, nullable=False)
    area = db.Column(db.DECIMAL(5, 2), nullable=False)
    phone_number = db.Column(db.String(15))
    num_residents = db.Column(db.Integer)
    managed_by = db.Column(INTEGER, ForeignKey('Users.user_id'))


class Residents(db.Model):
    __tablename__ = 'Residents'
    resident_id = db.Column(INTEGER,  primary_key=True)
    household_id = db.Column(INTEGER, ForeignKey('Households.household_id'))
    resident_name = db.Column(db.String(40), nullable=False)
    date_of_birth = db.Column(db.Date)
    id_number = db.Column(db.String(20), unique=True)
    temporary_absence = db.Column(db.Boolean, default=False)
    temporary_residence = db.Column(db.Boolean, default=False)


class Fees(db.Model):
    __tablename__ = 'Fees'
    fee_id = db.Column(INTEGER,  primary_key=True)
    household_id = db.Column(INTEGER, ForeignKey('Households.household_id'))
    amount = db.Column(db.DECIMAL(10, 2), nullable=False)
    due_date = db.Column(db.Date)
    status = db.Column(ENUM('Đã thanh toán', 'Chưa thanh toán'), default='Chưa thanh toán')
    created_by = db.Column(INTEGER, ForeignKey('Users.user_id'))
    updated_by = db.Column(INTEGER, ForeignKey('Users.user_id'))
    manage_rate = db.Column(db.Float)
    service_rate = db.Column(db.Float)


class Contributions(db.Model):
    __tablename__ = 'Contributions'
    contribution_id = db.Column(INTEGER, primary_key=True)
    household_id = db.Column(INTEGER, ForeignKey('Households.household_id'))
    contribution_type = db.Column(db.String(40))
    contribution_amount = db.Column(db.DECIMAL(10, 2))
    contribution_date = db.Column(db.Date)
