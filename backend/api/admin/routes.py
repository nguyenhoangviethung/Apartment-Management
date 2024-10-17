from api.admin import admin_bp
from flask import jsonify, request, current_app, redirect, url_for
from api.models.models import *
from dotenv import load_dotenv
from helpers import getIP
from datetime import datetime, timedelta
from functools import wraps
from api.admin import admin_bp

from api.extensions import db

import jwt


load_dotenv()

@admin_bp.route('/')
def index():
    return "ADMIN INDEX VIEW" 

@admin_bp.get('/<household_id>/resident')
def get_resident(household_id):
    residents = Residents.query.filter(Residents.household_id == household_id)
    household = Households.query.filter(Households.household_id == household_id).first()

    result = {
        "info": [],
    }
    print(household.managed_by)
    owner = Residents.query.filter(household.managed_by == Residents.resident_id).first()
    result['owner'] = {
            "resident_id": owner.resident_id,
            "resident_name": owner.resident_name,
            "date_of_birth": owner.date_of_birth,
            "id_number": owner.id_number,
            "phone_number": owner.phone_number,
            "status": owner.status
    }
    for resident in residents:
        if resident.resident_id == household.managed_by:
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
    household_ids = db.session.query(Fees.household_id).filter_by(Fees.status == 'Chưa thanh toán').all()
    res = []
    print(household_ids)
    # household_ids = sorted(household_ids)
    for household_id in household_ids:
        # get household_id
        
        household_id = household_id[0]
        service_rate = db.session.query(Fees.service_rate).filter_by(household_id=household_id).scalar or 0
        manage_rate = db.session.query(Fees.manage_rate).filter_by(household_id=household_id).first() or 0
        area = db.session.query(Households.area).filter_by(household_id=household_id).scalar() or 0
        amount = (service_rate + manage_rate)*float(area)

        info = {
                'room_number': f'{household_id}',
                'fee' : f'{amount}'
            }

        res.append(info)

    result = jsonify(res)
    
    return result, 200

@admin_bp.route('/contribution-fee', methods=['GET', 'POST'])
def contribution_fee():
    
    events = db.session.query(Contributions.contribution_event).scalar()
    print(events)

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
    



def token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        auth_header = request.headers.get('Authorization')
        if auth_header and auth_header.startswith('Bearer '):
            token = auth_header.split(' ')[1]
        else:
            return jsonify({'message': 'Token is missing'}), 401

        try:
            data = jwt.decode(token, current_app.config['SECRET_KEY'], algorithms=['HS256'])
        except jwt.ExpiredSignatureError:
            return jsonify({'message': 'Token has expired'}), 401
        except jwt.InvalidTokenError:
            return jsonify({'message': 'Invalid token'}), 401

        return f(data, *args, **kwargs)

    return decorated

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
            'room' : resident.household_id
        }
        resident_list.append(resident_data)
    return jsonify({'resident_info': resident_list}),200

@admin_bp.get('/house<apartment_number>')
def show_house_info(apartment_number):
    apartment = Households.query.filter_by(apartment_number = apartment_number).first()
    pop = apartment.num_residents
    if pop == 0:
        status = 'empty'
    else: 
        status = 'occupied'   
    apartment_data = {
        'area': apartment.area,
        'status': status,
        'owner': apartment.managed_by,
        'num_residents': pop
    }
    return jsonify({'info': apartment_data}), 200

@admin_bp.post('/update<id>')
def update_info(id):
    int_id = int(id)
    if int_id < 1000:
        apartment = Households.query.filter_by(apartment_number = id).first()
        if not apartment:
            return jsonify({'message': 'Household not found'}), 404
        
        print(request.form)  
        print(request.form.get('household_name'))
        data = {
            'household_name' : request.form.get('household_name'),
            'phone_number' : request.form.get('phone_number'),
            'num_residents' : request.form.get('num_residents')    
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
    else:
        resident = Residents.query.filter_by(id_number = id).first()
        if not resident:
            return jsonify({'message': 'Resident not found'}), 404 
        data = {
            'resident_name' : request.form.get('resident_name'),
            'phone_number' : request.form.get('phone_number'),
            'status' : request.form.get('status')
        }
        return 200
    
@admin_bp.route('/test', methods = ['GET', 'POST'])
def test():
    if request.method == 'POST':
        create_date = datetime.now().date()
        service_rate = request.form['service_rate']
        manage_rate = request.form['manage_rate']

        households = db.session.query(Households.household_id, Households.area).all()

        # print(households)

        for household in households:
            area = household[1]
            id = household[0]
            # date = datetime.strptime(create_date, '%Y-%m-%d').date()
            fee = Fees(
                amount = (float(service_rate) + float(manage_rate))*float(area),
                due_date =  create_date + timedelta(days=5),
                manage_rate = manage_rate,
                service_rate = service_rate,
                household_id = id
            )
            
            db.session.add(fee)
            db.session.commit()

        return "test"
