from api.admin import admin_bp
from flask import jsonify, request, current_app, redirect, url_for
from api.models.models import *
from dotenv import load_dotenv
from helpers import getIP, validate_token, get_payload
from datetime import datetime, timedelta
from functools import wraps
from api.admin import admin_bp
from api.extensions import db
import jwt
from api.models import fee_service


load_dotenv()

@admin_bp.route('/')
def index():
    return "ADMIN INDEX VIEW" 

@admin_bp.get('/<household_id>/residents')
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

@admin_bp.route('/fee/<int:household_id>')
def fee(household_id):
    
    service_rate = db.session.query(Fees.service_rate).filter_by(household_id=household_id).scalar() or None
    manage_rate = db.session.query(Fees.manage_rate).filter_by(household_id=household_id).scalar() or None
    area = db.session.query(Households.area).filter_by(household_id=household_id).scalar() or None

    if not service_rate or not manage_rate or not area:
        return jsonify({"message" : "cannot query from db"}), 404

    service_charge = service_rate*float(area)
    manage_charge = manage_rate*float(area)
    amount = (service_rate + manage_rate)*float(area)

    result = jsonify(
        {
            'service_charge': f'{service_charge}', 
            'manage_charge' : f'{manage_charge}', 
            'fee' : f'{amount}'
        }
    )

    return result, 200

@admin_bp.route('/not-pay')
def not_pay():
    
    date = datetime.now().date()
    notPayHouseholds = db.session.query(Fees.fee_id, Fees.household_id).filter(Fees.status == 'Chưa thanh toán', Fees.due_date >= date).all()
    res = []
    
    for notPayHousehold in notPayHouseholds:
        fee_id, household_id = notPayHousehold[0], notPayHousehold[1]
        service_rate = db.session.query(Fees.service_rate).filter_by(fee_id = fee_id).scalar()
        manage_rate = db.session.query(Fees.manage_rate).filter_by(fee_id = fee_id).scalar()
        due_date = db.session.query(Fees.due_date).filter_by(fee_id = fee_id).scalar()
        area = db.session.query(Households.area).filter_by(household_id = household_id).scalar()
        amount = (float(service_rate) + float(manage_rate))*float(area)
        service_fee = float(service_rate)*float(area)
        manage_fee = float(manage_rate)*float(area)

        infor = {
            'room': f'{household_id}',
            'amount': f'{amount}',
            'due_date': f'{due_date}',
            'service_fee': f'{service_fee}',
            'manage_fee': f'{manage_fee}'
        }
    
        res.append(infor)

    result = jsonify(res)

    return result, 200

@admin_bp.route('/contribution-fee', methods=['GET', 'POST'])
def contribution_fee():
    
        


    return 'OKE'
    
@admin_bp.route('/payment')
def payment():
    amount = 100000
    vnp_Amount = amount*100
    vnp_IpAddr = getIP()
    vnp_OrderInfo = 'TEST CHUC NANG THANH TOAN'
    CreateDate = datetime.now()
    ExpireDate = CreateDate + timedelta(minutes = 10)
    vnp_CreateDate = CreateDate.strftime('%Y%m%d%H%M%S')
    vnp_ExpireDate = ExpireDate.strftime('%Y%m%d%H%M%S')

    return redirect(url_for('pay.payment', vnp_Amount=vnp_Amount, vnp_IpAddr=vnp_IpAddr, vnp_OrderInfo=vnp_OrderInfo, vnp_CreateDate=vnp_CreateDate, vnp_ExpireDate=vnp_ExpireDate))
    
@admin_bp.post('/validate<user_id>')
# @token_required
def validate_user(data, user_id):
    role = data.get('is_admin')
    if role == 'false':
        return jsonify({'message': 'user unauthorized'}), 403
    
    full_name = request.form.get('full_name')
    dob = datetime.strptime(request.form.get('date_of_birth'),'%Y-%m-%d').date()
    id_number = request.form.get('id_number')
    status = request.form.get('status')
    room = request.form.get('room')
    # phone_number = request.form.get('phone_number')
    
    new_resident = Residents(
        resident_name = full_name,
        date_of_birth = dob,
        id_number = id_number,
        
    )
    # user = Users.query.filter_by(user_id = user_id).one_or_none()
    # user.set
    
@admin_bp.get('/residents')
# @token_required
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
def show_house_info(apartment_number):
    apartment = Households.query.filter_by(apartment_number = apartment_number).first()
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
    
@admin_bp.route('/add-fee', methods = ['GET', 'POST'])
def add_fee():
    if request.method == 'POST':
        create_date = datetime.now().date()
        service_rate = request.form['service_rate']
        manage_rate = request.form['manage_rate']

        households = db.session.query(Households.household_id, Households.area).all()

        if not service_rate or not manage_rate:
            return jsonify({'message': 'add fee fail'}), 404 

        for household in households:
            area = household[1]
            id = household[0]
            
            fee = Fees(
                amount = (float(service_rate) + float(manage_rate))*float(area),
                create_date = create_date,
                due_date =  create_date + timedelta(days=5),
                manage_rate = manage_rate,
                service_rate = service_rate,
                household_id = id
            )
        
            fee_service.add_fee(fee)

        return jsonify({'message': 'add fee successful'}), 200
    

@admin_bp.route('/test')
def test():
    if not validate_token():
        return redirect(url_for('admin.index'))
    
    return 'oke'
