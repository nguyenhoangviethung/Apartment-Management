from models.models import Residents, Households, Transactions
from sqlalchemy.orm import Session
from sqlalchemy.exc import SQLAlchemyError
from datetime import datetime
from api.extensions import db
import logging
from helpers import validate_date
from api.middlewares import handle_exceptions

class TransactionService:
    def __init__(self):
        self.logger = logging.getLogger(__name__)
    @handle_exceptions
    def convert_datetime(self, string_datetime):
        return datetime.strptime(string_datetime, '%Y%m%d%H%M%S')
    @handle_exceptions
    def get_transaction_by_transaction_id(self, transaction_id):
        return db.session.query(Transactions).filter(Transactions.transaction_id == transaction_id).first()
    @handle_exceptions
    def get_transaction_by_fee_id(self, fee_id):
        return db.session.query(Transactions).filter(Transactions.fee_id == fee_id).first()
    @handle_exceptions
    def get_transaction_by_user_pay(self, user_pay):
        transactions = db.session.query(Transactions).filter(Transactions.user_pay == user_pay).all()
        if not transactions:
            return ("error: No transactions were found"), 404
        data = []
        for transaction in transactions:
            transaction_data = {
                "transaction_id": transaction.transaction_id,
                "fee_id": transaction.fee_id,
                "park_id": transaction.park_id,
                "amount": transaction.amount, 
                "user_pay": transaction.user_pay,
                "user_name": transaction.user_name,
                "transaction_time": transaction.transaction_time,
                "bank_code": transaction.bank_code,
                "type": transaction.type,
                'description': transaction.description
            }
            data.append(transaction_data)
        
        return data, 200
    @handle_exceptions
    def add_transaction(self, data):
        # Tạo đối tượng mới từ class Transactions
        new_transaction = Transactions(
            transaction_id=data['transaction_id'],
            amount=data['amount'], 
            fee_id=data['fee_id'],
            park_id=data['park_id'],
            contribution_id = data['contribution_id'],
            electric_id=data['electric_id'],
            water_id=data['water_id'],
            user_pay=data['user_pay'],
            user_name=data['user_name'],
            transaction_time=self.convert_datetime(data['transaction_time']),
            bank_code=data['bank_code'],
            type=data['type'],
            description=data['description']
        )
        db.session.add(new_transaction)
        db.session.commit()
        return {'message': 'Add transaction successfully'}


    