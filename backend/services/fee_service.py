from models.models import Fees, Households, Residents
from api.extensions import db
from datetime import datetime, timedelta
import logging
from helpers import validate_date, decimal_to_float
from decimal import Decimal, InvalidOperation
from api.middlewares import handle_exceptions

logger = logging.getLogger(__name__)

class FeeService:

    def __init__(self):
        self.logger = logging.getLogger(__name__)
    @handle_exceptions
    def get_fee_by_household_id(self, household_id):
        return db.session.query(Fees).filter(Fees.household_id == household_id).all()
    @handle_exceptions
    def get_fee_by_fee_id(self, fee_id):
        return db.session.query(Fees).filter(Fees.fee_id == fee_id).first()
    @handle_exceptions
    def add_fee(self, data, creator):
        required_fields = ['start_date', 'due_date', 'service_rate', 'manage_rate', 'description']
            
        # Validation dữ liệu đầu vào
        if not all(field in data for field in required_fields):
            return ({'error': 'Missing required fields'}), 400
        
        try:
            start_date = validate_date(data['start_date'])
            due_date = validate_date(data['due_date'])
            service_rate = Decimal(data['service_rate'])
            manage_rate = Decimal(data['manage_rate'])
        except (ValueError, InvalidOperation) as e:
            return ({'error': str(e)}), 400
        
        # Kiểm tra xem mô tả đã tồn tại chưa
        existing_fee = Fees.query.filter_by(description=data['description']).first()
        if existing_fee:
            return ({'error': 'A fee with this description already exists'}), 400
        
        # Kiểm tra xem đã có fee nào được tạo trong cùng tháng và năm chưa
        current_month = start_date.replace(day=1)
        next_month = (current_month + timedelta(days=32)).replace(day=1)
        existing_fee_same_month = Fees.query.filter(
            Fees.create_date >= current_month,
            Fees.create_date < next_month
        ).first()
        if existing_fee_same_month:
            return ({'error': 'A fee has already been created for this month and year'}), 400
        
        households = db.session.query(Households.household_id, Households.area, Households.num_residents).all()
        
        for household in households:
            if household.num_residents == 0:
                continue
            
            area = Decimal(household.area)
            amount = (service_rate + manage_rate) * area
            
            fee = Fees(
                amount=amount,
                create_date=start_date,
                due_date=due_date,
                manage_rate=manage_rate,
                service_rate=service_rate,
                household_id=household.household_id,
                description=data['description'],
                created_by=creator
            )
            
            db.session.add(fee)
            db.session.commit()
        
        logger.info(f"Added fees for {len(households)} households")
        return ({'message': 'Add fee successful'}), 200

    def get_unpaid_fees(self, date):
            return db.session.query(
                Fees.fee_id, 
                Fees.household_id, 
                Fees.service_rate, 
                Fees.manage_rate, 
                Fees.due_date,
                Households.area,
                Fees.description
            ).join(
                Households, 
                Fees.household_id == Households.household_id
            ).filter(
                Fees.status == 'Chưa thanh toán', 
                Fees.due_date >= date
            ).all()

    def get_householdID(self, fee_id):
            return db.session.query(
                Fees.household_id
            ).filter(
                Fees.fee_id == fee_id
            ).all()

    def get_current_household_fee(self, household_id):
        now = datetime.now().date()
        return db.session.query(Fees).filter(Fees.household_id == household_id, now <= Fees.due_date).first()

    def user_get_current_fee(self, resident_id):
        households_id = db.session.query(Residents.household_id).filter(Residents.resident_id == resident_id).scalar()
        return self.get_current_household_fee(households_id)

    @handle_exceptions
    def get_fees(self):
        query_date = datetime.now().date()

        fee = db.session.query(Fees.description).filter(query_date <= Fees.due_date).first()
        fee_ids = db.session.query(Fees.fee_id).filter(query_date <= Fees.due_date).all()

        res = {"infor": {"description": [],
                        "detail": []
                        }}
        if fee:
            res['infor']["description"].append(fee[0])

        for fee_id in fee_ids:
            f_id = fee_id[0]
            service_rate = db.session.query(Fees.service_rate).filter(Fees.fee_id == f_id).scalar() or None
            manage_rate = db.session.query(Fees.manage_rate).filter(Fees.fee_id == f_id).scalar() or None
            amount = db.session.query(Fees.amount).filter(Fees.fee_id == f_id).scalar() or None
            household_id = db.session.query(Fees.household_id).filter(Fees.fee_id == f_id).scalar() or None

            if not service_rate or not manage_rate or not amount:
                continue

            info = { 
                    'fee' : f'{amount}',
                    'room': f'{household_id}'
            }

            res['infor']['detail'].append(info)

        return (res), 200 

    @handle_exceptions
    def update_fee(self, data, updater):
        required_fields = ['description', 'manage_rate', 'service_rate']
        
        if not all(field in data for field in required_fields):
            return ({'error': 'Missing required fields'}), 400

        try:
            manage_rate = Decimal(data['manage_rate'])
            service_rate = Decimal(data['service_rate'])
        except InvalidOperation:
            return ({'error': 'Invalid rate values'}), 400

        fees = Fees.query.filter(Fees.description == data['description']).all()
        
        if not fees:
            return ({'error': 'No fees found with the given description'}), 404
        
        for fee in fees:
            household = Households.query.filter_by(household_id=fee.household_id).first()
            
            if not household:
                logger.warning(f"Household not found for fee ID {fee.id}")
                continue

            area = Decimal(household.area)
            amount = (service_rate + manage_rate) * area

            fee.manage_rate = manage_rate
            fee.service_rate = service_rate
            fee.amount = amount
            fee.updated_by = updater

        db.session.commit()
        logger.info(f"Updated {len(fees)} fees")
        return ({'message': 'Update successful'}), 200

    @handle_exceptions
    def delete_fee(self, description):
        if not description:
            return ({'error': 'Description not provided'}), 400
        fees = Fees.query.filter(Fees.description == description).all()
        
        if not fees:
            return ({'error': 'No fees found with the given description'}), 404

        for fee in fees:
            db.session.delete(fee)
        
        db.session.commit()
        logger.info(f"Deleted {len(fees)} fees")
        return ({'message': 'Delete successful'}), 200

    @handle_exceptions
    def not_pay(self):
        date = datetime.now().date()
        not_pay_households = self.get_unpaid_fees(date)

        if not not_pay_households:
            return ({"message": "No unpaid fees found"}), 404

        res = {"infor": []}
        for fee in not_pay_households:
            service_rate = Decimal(fee.service_rate)
            manage_rate = Decimal(fee.manage_rate)
            area = Decimal(fee.area)

            amount = (service_rate + manage_rate) * area
            service_fee = service_rate * area
            manage_fee = manage_rate * area

            infor = {
                'room': str(fee.household_id),
                'amount': decimal_to_float(amount),
                'due_date': fee.due_date.strftime('%Y-%m-%d'),
                'service_fee': decimal_to_float(service_fee),
                'manage_fee': decimal_to_float(manage_fee),
                'fee_type': str(fee.description)
            }

            res['infor'].append(infor)

        logger.info(f"Retrieved {len(res['infor'])} unpaid fees")
        return (res), 200

    @handle_exceptions
    def fee_by_household_id(self, household_id):
        service_rate = db.session.query(Fees.service_rate).filter_by(household_id=household_id).scalar() or None
        manage_rate = db.session.query(Fees.manage_rate).filter_by(household_id=household_id).scalar() or None
        area = db.session.query(Households.area).filter_by(household_id=household_id).scalar() or None

        res = {'info': []}

        if not service_rate or not manage_rate or not area:
            return (res), 400

        service_charge = service_rate*float(area)
        manage_charge = manage_rate*float(area)
        amount = (service_rate + manage_rate)*float(area)

        info = {
                'service_charge': f'{service_charge}', 
                'manage_charge' : f'{manage_charge}', 
                'fee' : f'{amount}'
        }

        res['info'].append(info)

        return res, 200
    
    @handle_exceptions
    def get_fee_by_userID(self, data):

        required_fields = ["user_id"]

        if not all(field in data for field in required_fields):
            return {'error': 'Missing required fields'}, 400

        user_id = data["user_id"]
        resident_id = db.session.query(Residents.resident_id).filter(Residents.user_id == user_id).scalar()

        if not resident_id:
            return ({'message': 'you do not have permission'}), 403
        
        fee_info = self.user_get_current_fee(resident_id)

        result = {
            'amount' : fee_info.amount,
            'due_date' : datetime.strftime(fee_info.due_date, "%Y-%m-%d"),
            'status' : fee_info.status,
            'name_fee' : fee_info.description
        }
        return (result), 200
    
    @handle_exceptions
    def update_status(self, data, fee_id):
        fee = self.get_fee_by_fee_id(fee_id)

        if fee is None:
            return 'Fee not found'
        valid_statuses = ['Đã thanh toán', 'Chưa thanh toán']
       
        for key, value in data.items():
            if key not in fee.__table__.columns:
                continue  
            if key == 'status' and value not in valid_statuses:
                return f'Invalid status value: {value}'
            setattr(fee, key, value)
        db.session.commit()
        db.session.refresh(fee)
        return ('message: transaction successfully'), 302
    
    
