from sqlalchemy import ForeignKey, Column, Enum, INTEGER, JSON, String, Date, DECIMAL, FLOAT, NVARCHAR, DateTime

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
    url_image = Column(NVARCHAR(2083), default="https://res.cloudinary.com/dxjwzkk8j/image/upload/v1733854843/default.png")

class Households(db.Model):
    __tablename__ = 'Households'
    household_id = Column(INTEGER,  primary_key=True)
    household_name = Column(String(40), default = f'{household_id}')
    apartment_number = Column(String(10), default = f'{household_id}')
    floor = Column(INTEGER, nullable=False)
    area = Column(DECIMAL(5, 2), nullable=False)
    phone_number = Column(String(15), default = None)
    num_residents = Column(INTEGER, default = None)
    managed_by = Column(INTEGER, ForeignKey('Users.user_id', ondelete="CASCADE"))


class Residents(db.Model):
    __tablename__ = 'Residents'
    resident_id = Column(INTEGER,  primary_key = True)
    user_id = Column(INTEGER, ForeignKey(Users.user_id, ondelete="CASCADE"))
    household_id = Column(INTEGER, ForeignKey('Households.household_id', ondelete="CASCADE"))
    resident_name = Column(String(40), nullable=False)
    date_of_birth = Column(Date, default = None)
    id_number = Column(String(20), unique=True, default = None)
    status = Column(Enum('Tạm trú', 'Tạm vắng', 'Thường trú'), default = 'Thường trú')
    phone_number = Column(String(15), default = None)
    household_registration = Column(String(150), default = None)


class Fees(db.Model):
    __tablename__ = 'Fees'
    fee_id = Column(INTEGER,  primary_key=True)
    description = Column(NVARCHAR(150), nullable=False)
    household_id = Column(INTEGER, ForeignKey('Households.household_id', ondelete="CASCADE"))
    amount = Column(DECIMAL(10, 2), nullable=False)
    create_date = Column(Date, default = None)
    due_date = Column(Date, default = None)
    status = Column(Enum('Đã thanh toán', 'Chưa thanh toán'), default='Chưa thanh toán')
    created_by = Column(INTEGER, ForeignKey('Users.user_id', ondelete="CASCADE"))
    updated_by = Column(INTEGER, ForeignKey('Users.user_id', ondelete="CASCADE"))
    manage_rate = Column(FLOAT)
    service_rate = Column(FLOAT)


class Contributions(db.Model):
    __tablename__ = 'Contributions'
    contribution_id = Column(INTEGER, primary_key=True)
    household_id = Column(INTEGER, ForeignKey('Households.household_id', ondelete="CASCADE"))
    contribution_type = Column(String(40), default = None)
    contribution_amount = Column(DECIMAL(10, 2),  default = None)
    contribution_event = Column(JSON,  default = None)
    due_date = Column(Date, default = None)
    create_date = Column(Date, default = None)
    created_by = Column(INTEGER, ForeignKey('Users.user_id', ondelete="CASCADE"))
    updated_by = Column(INTEGER, ForeignKey('Users.user_id', ondelete="CASCADE"))
    status = Column(Enum('Đã thanh toán', 'Chưa thanh toán'), default='Chưa thanh toán')

class TokenBlacklist(db.Model):
    id = Column(db.Integer, primary_key=True)
    token = Column(db.String(512), unique=True, nullable=False)
    revoked = Column(db.Boolean, default=True)

class ParkingFees(db.Model):
    __tablename__ = 'ParkingFees'
    park_id = Column(INTEGER, primary_key=True)
    description = Column(String(40), default=None, nullable=False)
    amount = Column(DECIMAL(10, 2), default=None, nullable=False)
    status = Column(Enum('Đã thanh toán', 'Chưa thanh toán'), default='Chưa thanh toán')
    due_date = Column(Date, default = None)
    create_date = Column(Date, default = None)
    created_by = Column(INTEGER, ForeignKey('Users.user_id', ondelete="CASCADE"))
    updated_by = Column(INTEGER, ForeignKey('Users.user_id', ondelete="CASCADE"))
    household_id = Column(INTEGER, ForeignKey('Households.household_id', ondelete="CASCADE"))
    
class Vehicles(db.Model):
    __tablename__ = 'Vehicles'
    vehicles_id = Column(INTEGER, primary_key=True)
    household_id = Column(INTEGER, ForeignKey('Households.household_id', ondelete="CASCADE"))
    license_plate = Column(String(10), default=None, unique=True)
    vehicle_type = Column(Enum("car", "motor", "bicycle"), default="bicycle")
    

class Transactions(db.Model):
    __tablename__ = 'Transactions'
    transaction_id = Column(db.String(36), nullable=False, primary_key=True)
    fee_id = Column(db.Integer, ForeignKey('Fees.fee_id', ondelete="CASCADE"))
    park_id = Column(INTEGER, ForeignKey('ParkingFees.park_id', ondelete="CASCADE"))
    contribution_id = Column(INTEGER, ForeignKey('Contributions.contribution_id', ondelete="CASCADE"))
    amount = Column(DECIMAL(10,2), nullable=False)
    user_pay = Column(INTEGER, ForeignKey('Users.user_id'))
    user_name = Column(db.String(40), nullable=False)
    transaction_time = Column(DateTime, nullable=False)
    bank_code = Column(db.String(10))
    type = Column(db.String(10), nullable=False)
    description = Column(NVARCHAR(150), nullable=False)

class Electrics(db.Model):
    __tablename__ = 'Electric'
    customer_id = Column(String(11), nullable=False, primary_key=True)
    amount = Column(DECIMAL(10,2), nullable=False)
    status = Column(Enum('Đã thanh toán', 'Chưa thanh toán'), default='Chưa thanh toán')

class Waters(db.Model):
    __tablename__ = 'Water'
    customer_id = Column(String(9), nullable=False, primary_key=True)
    amount = Column(DECIMAL(10,2), nullable=False)
    status = Column(Enum('Đã thanh toán', 'Chưa thanh toán'), default='Chưa thanh toán')