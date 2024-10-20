from api.admin import admin_bp
from flask import jsonify, request
from api.models.models import *
from dotenv import load_dotenv
from helpers import validate_date, decimal_to_float, get_payload
from datetime import datetime, timedelta
from api.extensions import db
from api.models import fee_service
from api.middlewares import admin_required, handle_exceptions
from decimal import Decimal, InvalidOperation
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

load_dotenv()

@admin_bp.route('/')
@admin_required
def index():
    return "ADMIN INDEX VIEW" 

@admin_bp.get('/<household_id>/residents')
@admin_required
@handle_exceptions
def get_resident(household_id):
    residents = Residents.query.filter(Residents.household_id == household_id)
    if residents is None:
        return jsonify({"message": "this household have no ownership"}) , 404
    household = Households.query.filter(Households.household_id == household_id).first()
    if household is None:
        return jsonify({"message": "this household have no ownership"}) , 404
    result = {
        "info": [],
    }
    user = Users.query.filter(household.managed_by == Users.user_id).first()
    if user is None:
        return jsonify({"message": "this household have no ownership"}) , 404
    owner = Residents.query.filter(Residents.user_id == user.user_id).first() 
    result['owner'] = {
            "resident_id": owner.resident_id,
            "resident_name": owner.resident_name,
            "date_of_birth": owner.date_of_birth,
            "id_number": owner.id_number,
            "phone_number": owner.phone_number,
            "status": owner.status
    }
    for resident in residents:
        if resident.user_id == owner.user_id:
            continue
        new_info = {
            "resident_id": resident.resident_id,
            "resident_name": resident.resident_name,
            "date_of_birth": resident.date_of_birth,
            "id_number": resident.id_number,
            "phone_number": resident.phone_number,
            "status": resident.status
        }
        result['info'].append(new_info)

    return jsonify(result), 200

@admin_bp.post('/validate')
@admin_required
@handle_exceptions
def validate_user():
    
    full_name = request.form.get('full_name')
    dob = datetime.strptime(request.form.get('date_of_birth'),'%Y-%m-%d').date()
    id_number = request.form.get('id_number')
    status = request.form.get('status')
    room = request.form.get('room')
    phone_number = request.form.get('phone_number')
    
    existing_resident = Residents.query.filter_by(resident_name=full_name, id_number=id_number).first()
    if existing_resident:
        return jsonify({'message': 'Resident with this name and ID number already exists'}), 400
    
    household = Households.query.filter_by(household_id=room).first()
    if not household:
        return jsonify({'message': 'Room does not exist'}), 404
    
    new_resident = Residents(
        resident_name = full_name,
        date_of_birth = dob,
        id_number = id_number,
        status = status,
        household_id = room,
        phone_number = phone_number
    )
    db.session.add(new_resident)
    db.session.commit()
    return jsonify({'message': 'Resident added successfully'}), 200
    
@admin_bp.get('/residents')
@admin_required
@handle_exceptions
def show_all_residents():
    residents = Residents.query.all()
    resident_list = []
    year = datetime.today().year
    for resident in residents:
        age = year - resident.date_of_birth.year
        resident_data = {
            'full_name' : resident.resident_name,
            'date_of_birth' : resident.date_of_birth,
            'id_number' : resident.id_number,
            'age' : age,
            'room' : resident.household_id,
            'phone_number' : resident.phone_number,
            'status' : resident.status
        }
        resident_list.append(resident_data)
    return jsonify({'resident_info': resident_list}),200

@admin_bp.get('/house<apartment_number>')
@admin_required
@handle_exceptions
def show_house_info(apartment_number):
   
    apartment = Households.query.filter_by(apartment_number = apartment_number).first()
    if not apartment:
        return jsonify({'message': 'apartment number does not exists!!!'}), 404
    pop = apartment.num_residents
    owner = Users.query.filter_by(user_id = apartment.managed_by).first()
    if pop == 0:
        status = 'empty'
    else: 
        status = 'occupied'   
    apartment_data = {
        'area': apartment.area,
        'status': status,
        'owner': owner.username,
        'num_residents': pop,
        'phone_number': apartment.phone_number
    }
    return jsonify({'info': apartment_data}), 200

@admin_bp.post('/update<int:house_id>')
@admin_required
@handle_exceptions
def update_info(house_id):
    apartment = Households.query.filter_by(household_id = house_id).first()
    if not apartment:
        return jsonify({'message': 'Household not found'}), 404
        
    print(request.form)  
    print(request.form.get('household_name'))
    data = {
        'phone_number' : request.form.get('phone_number'),
        'num_residents' : request.form.get('num_residents'),    
    }
    for field, value in data.items():
        if value is not None:
            setattr(apartment, field, value)
    try:
        db.session.commit()
        return jsonify({'message': 'Household updated successfully'}), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({'message': f'An error occurred: {str(e)}'}), 500
    # else:
    #     resident = Residents.query.filter_by(id_number = id).first()
    #     if not resident:
    #         return jsonify({'message': 'Resident not found'}), 404 
    #     data = {
    #         'resident_name' : request.form.get('resident_name'),
    #         'phone_number' : request.form.get('phone_number'),
    #         'status' : request.form.get('status')
    #     }
    #     return 200

@admin_bp.route('/fee/<int:household_id>')
@admin_required
@handle_exceptions
def fee(household_id):
    
    service_rate = db.session.query(Fees.service_rate).filter_by(household_id=household_id).scalar() or None
    manage_rate = db.session.query(Fees.manage_rate).filter_by(household_id=household_id).scalar() or None
    area = db.session.query(Households.area).filter_by(household_id=household_id).scalar() or None

    res = {'info': []}

    if not service_rate or not manage_rate or not area:
        return jsonify(res), 400

    service_charge = service_rate*float(area)
    manage_charge = manage_rate*float(area)
    amount = (service_rate + manage_rate)*float(area)

    info = {
            'service_charge': f'{service_charge}', 
            'manage_charge' : f'{manage_charge}', 
            'fee' : f'{amount}'
    }

    res['info'].append(info)

    result = jsonify(res)

    return result, 200

@admin_bp.route('/not-pay')
@admin_required
@handle_exceptions
def not_pay():
    date = datetime.now().date()
    not_pay_households = fee_service.get_unpaid_fees(date)

    if not not_pay_households:
        return jsonify({"message": "No unpaid fees found"}), 404

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
    return jsonify(res), 200

    
@admin_bp.route('/add-fee', methods=['GET', 'POST'])
@admin_required
@handle_exceptions
def add_fee():
    data = request.form
    required_fields = ['start_date', 'due_date', 'service_rate', 'manage_rate', 'description']
    
    # Validation dữ liệu đầu vào
    if not all(field in data for field in required_fields):
        return jsonify({'error': 'Missing required fields'}), 400
    
    try:
        start_date = validate_date(data['start_date'])
        due_date = validate_date(data['due_date'])
        service_rate = Decimal(data['service_rate'])
        manage_rate = Decimal(data['manage_rate'])
    except (ValueError, InvalidOperation) as e:
        return jsonify({'error': str(e)}), 400
    
    # Kiểm tra xem mô tả đã tồn tại chưa
    existing_fee = Fees.query.filter_by(description=data['description']).first()
    if existing_fee:
        return jsonify({'error': 'A fee with this description already exists'}), 400
    
    # Kiểm tra xem đã có fee nào được tạo trong cùng tháng và năm chưa
    current_month = start_date.replace(day=1)
    next_month = (current_month + timedelta(days=32)).replace(day=1)
    existing_fee_same_month = Fees.query.filter(
        Fees.create_date >= current_month,
        Fees.create_date < next_month
    ).first()
    if existing_fee_same_month:
        return jsonify({'error': 'A fee has already been created for this month and year'}), 400
    
    households = db.session.query(Households.household_id, Households.area, Households.num_residents).all()
    # get updater
    payload = get_payload()
    creator = payload.get('user_id')
    
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
        
        fee_service.add_fee(fee)
    
    logger.info(f"Added fees for {len(households)} households")
    return jsonify({'message': 'Add fee successful'}), 200

@admin_bp.route('/fees', methods=['GET', 'POST'])
@admin_required
@handle_exceptions
def get_fees():
    if request.method == 'POST':
        try:
            query_date = validate_date(request.form['date'])
        except KeyError:
            return jsonify({'error': 'Date not provided in the request'}), 400
        except ValueError as e:
            return jsonify({'error': str(e)}), 400
    else:
        query_date = datetime.now().date()

    fee = db.session.query(Fees.description).filter(query_date <= Fees.due_date).first()

    res = {"infor": []}
    if fee:
        res['infor'].append(fee[0])

    return jsonify(res), 200   

@admin_bp.route('/update-fee', methods=['POST'])
@admin_required
@handle_exceptions
def update_fee():
    data = request.form
    required_fields = ['description', 'manage_rate', 'service_rate']
    
    if not all(field in data for field in required_fields):
        return jsonify({'error': 'Missing required fields'}), 400

    try:
        manage_rate = Decimal(data['manage_rate'])
        service_rate = Decimal(data['service_rate'])
    except InvalidOperation:
        return jsonify({'error': 'Invalid rate values'}), 400

    fees = Fees.query.filter(Fees.description == data['description']).all()
    
    if not fees:
        return jsonify({'error': 'No fees found with the given description'}), 404
    # get updater
    payload = get_payload()
    updater = payload.get('user_id')

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
    return jsonify({'message': 'Update successful'}), 200

@admin_bp.route('/delete-fee', methods=['POST'])
@admin_required
@handle_exceptions
def delete_fee():
    description_fee = request.form.get('description')
    
    if not description_fee:
        return jsonify({'error': 'Description not provided'}), 400

    fees = Fees.query.filter(Fees.description == description_fee).all()
    
    if not fees:
        return jsonify({'error': 'No fees found with the given description'}), 404

    for fee in fees:
        db.session.delete(fee)
    
    db.session.commit()
    logger.info(f"Deleted {len(fees)} fees")
    return jsonify({'message': 'Delete successful'}), 200
    