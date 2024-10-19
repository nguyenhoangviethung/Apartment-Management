from sqlalchemy import ForeignKey, Column, Enum, INTEGER, JSON, String, Date, DECIMAL, FLOAT, NVARCHAR

from api.extensions import db

class Users(db.Model):
    __tablename__ = 'Users'
    user_id = Column(INTEGER, primary_key=True)
    username = Column(String(100), unique=True, nullable=False)
    password_hash = Column(String(512), nullable=False)
    user_role = Column(Enum('admin', 'user', 'sadmin'), default='user')
    user_email = Column(String(100), unique=True)
    last_login = Column(Date, default = None)
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
    user_id = Column(INTEGER, ForeignKey(Users.user_id))
    household_id = Column(INTEGER, ForeignKey('Households.household_id'))
    resident_name = Column(String(40), nullable=False)
    date_of_birth = Column(Date, default = None)
    id_number = Column(String(20), unique=True, default = None)
    status = Column(Enum('Tạm trú', 'Tạm vắng', 'Thường trú'), default = 'Thường trú')
    phone_number = Column(String(15), default = None)


class Fees(db.Model):
    __tablename__ = 'Fees'
    fee_id = Column(INTEGER,  primary_key=True)
    description = Column(NVARCHAR(150), nullable=False)
    household_id = Column(INTEGER, ForeignKey('Households.household_id'))
    amount = Column(DECIMAL(10, 2), nullable=False)
    create_date = Column(Date, default = None)
    due_date = Column(Date, default = None)
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
    contribution_date = Column(Date,  default = None)
    contribution_event = Column(JSON,  default = None)

class TokenBlacklist(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    token = db.Column(db.String(512), unique=True, nullable=False)
    revoked = db.Column(db.Boolean, default=True)