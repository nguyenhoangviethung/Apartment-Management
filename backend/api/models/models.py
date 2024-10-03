from sqlalchemy import Column, Integer, String, Float, Boolean, DateTime, ForeignKey, NVARCHAR, CHAR, Enum, BINARY
from sqlalchemy.orm import relationship
from api.extensions import db
from datetime import datetime

class Users(db.Model):
    __tablename__ = 'users'
    user_id = Column(BINARY(16), nullable=False, primary_key=True, unique=True)
    user_name = Column(NVARCHAR(40), nullable=False)
    password_hash = Column(String(255), nullable=False)
    user_role = Column(Enum('admin', 'user'), default='user')

class Households(db.Model):
    __tablename__ = 'households'
    household_id = Column(BINARY(16), nullable=False, primary_key=True, unique=True)
    household_name = Column(NVARCHAR(40), nullable=False)
    apartment_number = Column(NVARCHAR(10), nullable=False)
    floor = Column(Integer, nullable=False)
    area = Column(Float, nullable=False)
    phone_number = Column(Integer(), nullable=False)
    num_residents = Column(Integer, nullable=False)

class Residents(db.Model):
    __tablename__ = 'residents'
    resident_id = Column(BINARY(16), nullable=False, primary_key=True, unique=True)
    household_id = Column(BINARY(16), ForeignKey(Households.household_id))

class Contributions(db.Model):
    __tablename__ = 'contributions'
    contribution_id = Column(BINARY(16), nullable=False, primary_key=True, unique=True)
    household_id = Column(BINARY(16), ForeignKey(Households.household_id))
    contribution_amount = Column(Float, default=0)
    contribtion_date = Column(DateTime, default=datetime.now())

class Fees(db.Model):
    __tablename__ = 'fees'
    fee_id = Column(BINARY(16), primary_key=True, nullable=False, unique=True)
    household_id = Column(BINARY(16), ForeignKey(Households.household_id))
    service_rate = Column(Float, nullable=False)
    management_rate = Column(Float, nullable=False)
    amount = Column(Float, nullable=False)
    due_date = Column(DateTime, nullable=False)
    status = Column(Boolean, default=False, nullable=False)


