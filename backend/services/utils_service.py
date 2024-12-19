from api.extensions import db
import logging
from helpers import validate_date, decimal_to_float
from decimal import Decimal, InvalidOperation
from api.middlewares import handle_exceptions
from models.models import Vehicles, Households, ParkFees, Residents
from datetime import datetime, timedelta, date

class UtilsService:
    def __init__(self):
        self.logger = logging.getLogger(__name__)
    
    @handle_exceptions   
    def get_park_fee_by_householdID(self, household_id):
        vehicles = db.session.query(
            Vehicles.vehicle_type
        ).filter(
            Vehicles.household_id == household_id
        ).all()

        num_cars, num_motors, num_bicycles = 0, 0, 0
        for vehicle in vehicles:
            if vehicle[0] == 'car':
                num_cars += 1
            elif vehicle[0] == 'motor':
                num_motors += 1
            elif vehicle[0] not in ('car', 'motor'):
                num_bicycles += 1
        
        amount = num_cars*(1200000) + num_motors*(70000)
        return {"amount": amount, "room": f"{household_id}", "num_car": f"{num_cars}", "num_motors": f"{num_motors}"}, 200
        
    @handle_exceptions
    def get_all_park_fee(self):
        query_date = datetime.now().date()

        fee = db.session.query(ParkFees.description).filter(query_date <= ParkFees.due_date).first()
        fee_ids = db.session.query(ParkFees.park_id).filter(query_date <= ParkFees.due_date).all()

        res = {"infor": {"description": [],
                        "detail": []
                        }}
        if fee:
            res['infor']["description"].append(fee[0])

        for fee_id in fee_ids:
            f_id = fee_id[0]
            amount = db.session.query(ParkFees.amount).filter(ParkFees.park_id == f_id).scalar() or None
            household_id = db.session.query(ParkFees.household_id).filter(ParkFees.park_id == f_id).scalar() or None

            if not amount:
                continue

            info = { 
                    'fee' : f'{amount}',
                    'room': f'{household_id}'
            }

            res['infor']['detail'].append(info)

        return (res), 200

    @handle_exceptions
    def add_park_fee(self, data, creator):
        required_fields = ['start_date', 'due_date', 'description']

        if not all(field in data for field in required_fields):
            return {'error': 'Missing required fields'}, 400

        description = data['description'].strip()
        try:
            start_date = validate_date(data['start_date'])
            due_date = validate_date(data['due_date'])
        except (ValueError, InvalidOperation) as e:
            return {'error': str(e)}, 400

        if start_date > datetime.now().date():
            return ({"messages": "Invalid creation date"}), 400

        # Kiểm tra xem đã có fee nào được tạo trong cùng tháng và năm chưa
        current_month = start_date.replace(day=1)
        next_month = (current_month + timedelta(days=32)).replace(day=1)
        existing_fee_same_month = ParkFees.query.filter(
            ParkFees.create_date >= current_month,
            ParkFees.create_date < next_month
        ).first()
        if existing_fee_same_month:
            return ({'error': 'A fee has already been created for this month and year'}), 400    

        households = db.session.query(Households.household_id, Households.num_residents).all()
        for household in households:
            # household_id
            id = household[0]
            if household.num_residents == 0:
                self.logger.warning(f"Skipping household ID {household.household_id} with zero residents.")
                continue

            res, _ = self.get_park_fee_by_householdID(id)
            amount = res["amount"]    
            
            status = "Đã thanh toán" if amount == 0 else "Chưa thanh toán"
            fee = ParkFees(
                amount = amount,
                create_date = start_date,
                due_date = due_date,
                description = description,
                created_by = creator,
                household_id = id,
                status = status
            )

            db.session.add(fee)
            db.session.commit()
        
        return ({"messages": "add park fee successful"}), 200

    @handle_exceptions
    def delete_park_fee(self, data):
        required_fields = ['description']
        if not all(field in data for field in required_fields):
            return {'error': 'Missing required fields'}, 400

        description = data["description"].strip()
        fees = ParkFees.query.filter(ParkFees.description == description).all()
        
        if not fees:
            return ({'error': 'No fees found with the given description'}), 404

        for fee in fees:
            db.session.delete(fee)
        
        db.session.commit()
        self.logger.info(f"Deleted {len(fees)} fees")
        return ({'message': 'Delete successful'}), 200

    def get_unpaid_park_fee(self, query_date):
            return db.session.query(
                ParkFees.park_id, 
                ParkFees.household_id, 
                ParkFees.due_date,
                ParkFees.description,
                ParkFees.amount
            ).join(
                Households, 
                ParkFees.household_id == Households.household_id
            ).filter(
                ParkFees.status == 'Chưa thanh toán', 
                ParkFees.due_date >= query_date,
                ParkFees.create_date <= query_date
            ).all()

    
    @handle_exceptions
    def unpaid_specific_date(self, query_date):
        if datetime.strptime(query_date, '%Y-%m-%d').date() > datetime.now().date():
            return ({"messages": "Invalid query date"}), 400
        
        not_pay_households = self.get_unpaid_park_fee(query_date)

        if not not_pay_households:
            return ({"message": "No unpaid fees found"}), 404

        res = {"infor": []}
        for fee in not_pay_households:

            infor = {
                'room': str(fee.household_id),
                'amount': decimal_to_float(fee.amount),
                'fee_type': str(fee.description)
            }

            res['infor'].append(infor)

        self.logger.info(f"Retrieved {len(res['infor'])} unpaid fees")
        return (res), 200

    @handle_exceptions
    def get_unpay_park_fee(self):
        date = datetime.now().date()
        not_pay_households = self.get_unpaid_park_fee(date)

        if not not_pay_households:
            return ({"message": "No unpaid fees found"}), 404

        res = {"infor": []}
        for fee in not_pay_households:

            infor = {
                'room': str(fee.household_id),
                'amount': decimal_to_float(fee.amount),
                'fee_type': str(fee.description)
            }

            res['infor'].append(infor)

        self.logger.info(f"Retrieved {len(res['infor'])} unpaid fees")
        return (res), 200

    @handle_exceptions
    def get_current_household_fee(self, household_id):
        now = datetime.now().date()
        return db.session.query(ParkFees).filter(ParkFees.household_id == household_id, now <= ParkFees.due_date).first()

    @handle_exceptions
    def user_get_current_fee(self, resident_id):
        households_id = db.session.query(Residents.household_id).filter(Residents.resident_id == resident_id).scalar()
        return self.get_current_household_fee(households_id)

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

    def get_electric_fee_by_householdID(self, household_id):
        pass

    def get_electric_fee_by_householdID(self, household_id):
        pass

    def get_electric_fee_by_householdID(self, household_id):
        pass

    