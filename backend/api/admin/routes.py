from api.admin import admin_bp
from flask import jsonify, request
from models.models import *
from dotenv import load_dotenv
from helpers import validate_date, decimal_to_float, get_payload
from datetime import datetime, timedelta
from api.extensions import db
from services import fee_service, contribution_service, households_service, resident_service, utils_service
from api.middlewares import admin_required, handle_exceptions
from decimal import Decimal, InvalidOperation
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

load_dotenv()

# cần chỉnh sửa chỗ này, move ra khỏi folder model, tạo folder riêng tên là services
contribution_service = contribution_service.ContributionService()
households_service = households_service.HouseholdsService()
resident_service = resident_service.ResidentService()
fee_service = fee_service.FeeService()
utils_service = utils_service.UtilsService()

@admin_bp.route('/')
@admin_required
def index():
    return "ADMIN INDEX VIEW" 

@admin_bp.get('/<household_id>/residents')
@admin_required
@handle_exceptions
def get_resident(household_id):
    
    response, status_code = households_service.get_residents_by_household_id(household_id)
    return jsonify(response), status_code

@admin_bp.post('/add-resident')
@admin_required
@handle_exceptions
def add_resident():
    # Lấy thông tin từ request form
    data = request.form.to_dict()
    response, status_code = resident_service.add_resident(data)
    return jsonify(response), status_code
    
@admin_bp.post('remove-resident/<resident_id>')
@admin_required
@handle_exceptions
def remove_resident(resident_id):
    response, status_code = resident_service.remove_resident(resident_id)
    return response, status_code

@admin_bp.post('update-resident/<int:resident_id>')
@admin_required
@handle_exceptions
def update_resident(resident_id):
    data = request.form.to_dict()
    response, status_code = resident_service.update_resident(resident_id, data)
    return response, status_code

@admin_bp.post('/validate')#có thể bỏ
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
    try:
        resident_list = resident_service.show_all_residents()
        return jsonify({'resident_info': resident_list}),200
    except Exception as e:
        return jsonify({'error': f'Unexpected error: {e}'}), 500

@admin_bp.get('/house')
@admin_required
@handle_exceptions
def show_all_house():
    house_list, code = households_service.get_all_house()
    return jsonify({'info': house_list}), code

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
    id = request.form.get('id_num')
    phone_number = request.form.get('phone_number')
    message, code = households_service.update_info(house_id, id, phone_number)
    return jsonify(message), code
    # apartment = Households.query.filter_by(household_id = house_id).first()
    # if not apartment:
    #     return jsonify({'message': 'Household not found'}), 404
    # id = request.form.get('id_num')
    # resident = Residents.query.filter_by(id_number = id).first()
    # if not resident:
    #     return jsonify({'message': 'No resident with this id'}), 404
    # data = {
    #     'managed_by' : resident.user_id,
    #     'num_residents' : request.form.get('num_residents'),    
    # }
    # for field, value in data.items():
    #     if value is not None:
    #         setattr(apartment, field, value)
    # try:
    #     db.session.commit()
    #     return jsonify({'message': 'Household updated successfully'}), 200
    # except Exception as e:
    #     db.session.rollback()
    #     return jsonify({'message': f'An error occurred: {str(e)}'}), 500
    
@admin_bp.post('/update-res/<int:res_id>')#có thể bỏ
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
    
    response, status_code = fee_service.fee_by_household_id(household_id)
    return jsonify(response), status_code
    
@admin_bp.route('/not-pay')
@admin_required
@handle_exceptions
def not_pay():
    response, status_code = fee_service.not_pay()
    return jsonify(response), status_code

@admin_bp.route('/add-fee', methods=['GET', 'POST'])
@admin_required
@handle_exceptions
def add_fee():
    data = request.form.to_dict()

    payload = get_payload()
    creator = payload.get('user_id')    

    respose, status_code = fee_service.add_fee(data, creator)
    return jsonify(respose), status_code

@admin_bp.route('/fees', methods=['GET', 'POST'])
@admin_required
@handle_exceptions
def get_fees():
    response, status_code = fee_service.get_fees()
    return jsonify(response), status_code   

@admin_bp.route('/update-fee', methods=['POST'])
@admin_required
@handle_exceptions
def update_fee():
    data = request.form.to_dict()
    # get updater
    payload = get_payload()
    updater = payload.get('user_id')

    response, status_code = fee_service.update_fee(data, updater)
    return jsonify(response), status_code

@admin_bp.route('/delete-fee', methods=['POST'])
@admin_required
@handle_exceptions
def delete_fee():
    description_fee = request.form.get('description')
    
    response, status_code = fee_service.delete_fee(description_fee)
    return jsonify(response), status_code

@admin_bp.route('/add-contributions', methods = ['POST'])
@admin_required
@handle_exceptions
def add_contributions():
    data = request.form.to_dict()

    payload = get_payload()
    creator = payload.get('user_id')

    response, status_code = contribution_service.add_contribution_fee(data, creator)
    return jsonify(response), status_code

@admin_bp.route('/update-contributions-fee', methods = ['POST'])
@admin_required
@handle_exceptions
def update_contributions_fee():
    data = request.form.to_dict()

    payload = get_payload()
    updater = payload.get('user_id')

    response, status_code = contribution_service.update_contribution_fee(data, updater)
    return jsonify(response), status_code

@admin_bp.route('delete-contribution-fee', methods = ['POST'])
@admin_required
@handle_exceptions
def delete_contribution_fee():
    description_fee = request.form.get('description')
    response, status_code = contribution_service.delete_contribution_fee(description_fee)
    return jsonify(response), status_code    

@admin_bp.route('/contributions', methods=['GET', 'POST'])
@admin_required
@handle_exceptions
def get_contributions():
    res, status_code = contribution_service.get_contributions()
    return jsonify(res), status_code

@admin_bp.route("/park-fee/<household_id>", methods = ['POST'])
@admin_required
@handle_exceptions
def get_park_fee(household_id):
    # check white space
    response, status_code = utils_service.get_park_fee_by_householdID(household_id)

    return jsonify(response), status_code

@admin_bp.route("/park-fee-room", methods = ['POST'])
@admin_required
@handle_exceptions
def get_park_fee_v2():
    # check white space
    household_id = request.form["household_id"].strip()

    response, status_code = utils_service.get_park_fee_by_householdID(household_id)

    return jsonify(response), status_code

@admin_bp.route('/add-park-fee', methods = ['POST'])
@admin_required
@handle_exceptions
def add_park_fee():
    data = request.form.to_dict()
    payload = get_payload()
    creator = payload.get('user_id')
    response, status_code = utils_service.add_park_fee(data, creator)

    return jsonify(response), status_code

@admin_bp.route('/delete-park-fee', methods = ['POST'])
@admin_required
@handle_exceptions
def delete_park_fee():
    data = request.form.to_dict()

    response, status_code = utils_service.delete_park_fee(data)

    return jsonify(response), status_code

@admin_bp.route('/get-unpaid-park-fee')
@admin_required
@handle_exceptions
def get_unpaid_park_fee():
    response, status_code = utils_service.get_unpay_park_fee()

    return jsonify(response), status_code

@admin_bp.route('/get-unpaid-park-fee', methods = ['POST'])
@admin_required
@handle_exceptions
def get_unpaid_park_fee_by_specific_data():
    data = request.form.to_dict()
    query_date = data["query_date"]
    
    response, status_code = utils_service.unpaid_specific_date(query_date)

    return jsonify(response), status_code
    