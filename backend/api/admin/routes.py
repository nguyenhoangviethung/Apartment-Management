from flask import *
from api.admin import admin_bp
from api.models.models import *
from datetime import datetime, timedelta
from vnpay import VNPAY
from pay import PAY
from functools import wraps
from flask import request, current_app, jsonify
from api.extensions import db
import jwt


@admin_bp.get('/<house_id>/resident')
def get_resident(house_id):
    house_hold = Households.query.filter(house_id == house_id).first()
    result = jsonify({
        "house_id": house_id,
        "household_name": house_hold.household_name,
        "apartment_number": house_hold.apartment_number,
        "floor": house_hold.floor,
        "area": house_hold.area,
        "phone_number": house_hold.phone_number,
        "num_residents": house_hold.num_residents,
        "managed_by": house_hold.managed_by
    })
    return result

@admin_bp.route('/')
def index():
    vnpay = PAY()
    time = datetime.now()
    ip = request.headers.get('X-Forwarded-For', request.remote_addr)
    infor = "TEST CHUC NANG THANH TOAN HOA DON"
    expired = time + timedelta(minutes=15)
    formatted_time = time.strftime('%Y%m%d%H%M%S')
    formatted_expired_time = expired.strftime('%Y%m%d%H%M%S')
    print(time, expired)
    print(ip)
    name = vnpay.qr_payment('10000000', formatted_time, ip, infor, formatted_expired_time)
    return name

@admin_bp.route('pay', methods=['POST'])
def payment(request):
    if request.method == 'POST':
        # Process input data and build url payment
        form = PaymentForm(request.POST)
        if form.is_valid():
            order_type = form.cleaned_data['order_type']
            order_id = form.cleaned_data['order_id']
            amount = form.cleaned_data['amount']
            order_desc = form.cleaned_data['order_desc']
            bank_code = form.cleaned_data['bank_code']
            language = form.cleaned_data['language']
            ipaddr = get_client_ip(request)
            # Build URL Payment
            vnp = vnpay()
            vnp.requestData['vnp_Version'] = '2.1.0'
            vnp.requestData['vnp_Command'] = 'pay'
            vnp.requestData['vnp_TmnCode'] = settings.VNPAY_TMN_CODE
            vnp.requestData['vnp_Amount'] = amount * 100
            vnp.requestData['vnp_CurrCode'] = 'VND'
            vnp.requestData['vnp_TxnRef'] = order_id
            vnp.requestData['vnp_OrderInfo'] = order_desc
            vnp.requestData['vnp_OrderType'] = order_type
            # Check language, default: vn
            if language and language != '':
                vnp.requestData['vnp_Locale'] = language
            else:
                vnp.requestData['vnp_Locale'] = 'vn'
                # Check bank_code, if bank_code is empty, customer will be selected bank on VNPAY
            if bank_code and bank_code != "":
                vnp.requestData['vnp_BankCode'] = bank_code

            vnp.requestData['vnp_CreateDate'] = datetime.now().strftime('%Y%m%d%H%M%S')
            vnp.requestData['vnp_IpAddr'] = ipaddr
            vnp.requestData['vnp_ReturnUrl'] = settings.VNPAY_RETURN_URL
            vnpay_payment_url = vnp.get_payment_url(settings.VNPAY_PAYMENT_URL, settings.VNPAY_HASH_SECRET_KEY)
            print(vnpay_payment_url)
                # Redirect to VNPAY
            return redirect(vnpay_payment_url)
        else:
            print("Form input not validate")
    else:
        return render(request, "payment.html", {"title": "Thanh toán"})
        



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
        return 200;   
