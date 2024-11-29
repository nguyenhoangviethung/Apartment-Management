from api.admin import admin_bp
from flask import jsonify, request
from api.models.models import *
from api.models.resident_service import *
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

@admin_bp.post('/add-resident')
@admin_required
@handle_exceptions
def add_resident():
    # Lấy thông tin từ request form
    data = request.form.to_dict()
    required_fields = ["resident_id", "household_id", "resident_name","status"]
    for field in required_fields:
        if field not in data or not data[field]:
            return jsonify({"error": f"Missing required field: {field}"}), 400
    
    resident_service = Resident_Service(db.session)
    try:
        new_resident = resident_service.create_resident(data)
        return jsonify({"message": "Resident created successfully"}), 201
    except Exception as e:
        return jsonify({'error': f'Unexpected error: {e}'}), 500
    
@admin_bp.post('remove-resident/<resident_id>')
@admin_required
@handle_exceptions
def remove_resident(resident_id):
    try:
        resident_remove = Resident_Service(db.session)
        if resident_remove.remove_resident(resident_id):
            return jsonify({"message": "Resident removed successfully"}), 201
        else:
            return jsonify("message: resident_id not found"), 404
    except Exception as e:
        return jsonify({'error': f'Unexpected error: {e}'}), 500

@admin_bp.post('update-resident/<int:resident_id>')
@admin_required
@handle_exceptions
def update_resident(resident_id):
    try:
        data = request.form.to_dict()
        resident_update = Resident_Service(db.session)
        if resident_update.update_resident(resident_id, data):
            return jsonify({"message": "Resident updated successfully"}), 201
        else:
            return jsonify("message: resident_id not found"), 404
    except Exception as e:
        return jsonify({'error': f'Unexpected error: {e}'}), 500


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
    
    existing_resident = Residents.query.filter_by(id_number=id_number).first()
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
        dob = resident.date_of_birth if not None else None
        
        age = None if dob == None else year - dob.year 
        resident_data = {
            'full_name' : resident.resident_name,
            'date_of_birth' : dob,
            'id_number' : resident.id_number,
            'age' : age,
            'room' : resident.household_id,
            'phone_number' : resident.phone_number,
            'status' : resident.status,
            'res_id' : resident.resident_id
        }
        resident_list.append(resident_data)
    return jsonify({'resident_info': resident_list}),200

@admin_bp.get('/house')
@admin_required
@handle_exceptions
def show_all_house():
    apartments = Households.query.all()
    house_list = []
    for apartment in apartments:    
        pop = apartment.num_residents
        owner = Users.query.filter_by(user_id = apartment.managed_by).first()
        owner_name = owner.username if owner else 'Unknown'
        if pop == 0:
            status = 'empty'
        else: 
            status = 'occupied'   
        apartment_data = {
            'area': apartment.area,
            'status': status,
            'owner': owner_name,
            'num_residents': pop,
            'phone_number': apartment.phone_number,
            'apartment_number': apartment.apartment_number
        }
        house_list.append(apartment_data)
    return jsonify({'info': house_list}), 200

@admin_bp.get('/house<apartment_number>')
@admin_required
@handle_exceptions
def show_house_info(apartment_number):
   
    apartment = Households.query.filter_by(apartment_number = apartment_number).first()
    if not apartment:
        return jsonify({'message': 'apartment number does not exists!!!'}), 404
    pop = apartment.num_residents
    owner = Users.query.filter_by(user_id = apartment.managed_by).first()
    owner_name = owner.username if owner else 'Unknown'
    if pop == 0:
        status = 'empty'
    else: 
        status = 'occupied'   
    apartment_data = {
        'area': apartment.area,
        'status': status,
        'owner': owner_name,
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
    id = request.form.get('id_num')
    resident = Residents.query.filter_by(id_number = id).first()
    if not resident:
        return jsonify({'message': 'No resident with this id'}), 404
    data = {
        'managed_by' : resident.user_id,
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
    
@admin_bp.post('/update-res/<int:res_id>')
@admin_required
@handle_exceptions
def update_res(res_id):
    resident = Residents.query.filter_by(resident_id = res_id).first()
    if not resident:
        return jsonify({'message': 'Resident not found!!!'}), 404
    
    data = {
        'full_name' : request.form.get('full_name'),
        'date_of_birth' : datetime.strptime(request.form.get('date_of_birth'),'%Y-%m-%d').date(),
        'status' : request.form.get('status'),
        'phone_number' : request.form.get('phone_number')
    }
    for field, value in data.items():
        if value is not None:
            setattr(resident,field,value)
            db.session.commit()
    
    return jsonify({'message': 'Household updated successfully'}), 200
    

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

# @admin_bp.before_app_request()

@admin_bp.route('/contribution-fees')
@admin_required
@handle_exceptions
def get_contribution_fees():
    return "oke"