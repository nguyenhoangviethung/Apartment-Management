from sqlalchemy import ForeignKey, Column, Enum, INTEGER, JSON, String, DateTime, DECIMAL, Boolean, FLOAT

from api.extensions import db
from flask_login import UserMixin

class Users(UserMixin, db.Model):
    __tablename__ = 'Users'
    user_id = Column(INTEGER, primary_key=True)
    username = Column(String(100), unique=True, nullable=False)
    password_hash = Column(String(512), nullable=False)
    user_role = Column(Enum('admin', 'user', 'sadmin'), default='user')
    user_email = Column(String(100), unique=True)
    last_login = Column(DateTime, default = None)
    phone_number = Column(String(15), default = None)

class Households(db.Model):
    __tablename__ = 'Households'
    household_id = Column(INTEGER,  primary_key=True)
    household_name = Column(String(40), default = f'{household_id}')
    apartment_number = Column(String(10), default = f'{household_id}')
    floor = Column(INTEGER, nullable=False)
    area = Column(DECIMAL(5, 2), nullable=False)
    phone_number = Column(String(15), default = None)
    num_residents = Column(INTEGER, default = None)
    managed_by = Column(INTEGER, ForeignKey('Users.user_id'))


class Residents(db.Model):
    __tablename__ = 'Residents'
    resident_id = Column(INTEGER,  primary_key = True)
    household_id = Column(INTEGER, ForeignKey('Households.household_id'))
    resident_name = Column(String(40), nullable=False)
    date_of_birth = Column(DateTime, default = None)
    id_number = Column(String(20), unique=True, default = None)
    status = Column(Enum('Tạm trú', 'Tạm vắng', 'Thường trú'), default = 'Thường trú')
    phone_number = Column(String(15), default = None)


class Fees(db.Model):
    __tablename__ = 'Fees'
    fee_id = Column(INTEGER,  primary_key=True)
    household_id = Column(INTEGER, ForeignKey('Households.household_id'))
    amount = Column(DECIMAL(10, 2), nullable=False)
    due_date = Column(DateTime, default= None)
    status = Column(Enum('Đã thanh toán', 'Chưa thanh toán'), default='Chưa thanh toán')
    created_by = Column(INTEGER, ForeignKey('Users.user_id'))
    updated_by = Column(INTEGER, ForeignKey('Users.user_id'))
    manage_rate = Column(FLOAT)
    service_rate = Column(FLOAT)


class Contributions(db.Model):
    __tablename__ = 'Contributions'
    contribution_id = Column(INTEGER, primary_key=True)
    household_id = Column(INTEGER, ForeignKey('Households.household_id'))
    contribution_type = Column(String(40), default = None)
    contribution_amount = Column(DECIMAL(10, 2),  default = None)
    contribution_date = Column(DateTime,  default = None)
    contribution_event = Column(JSON,  default = None)
