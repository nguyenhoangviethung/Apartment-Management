from flask import redirect, url_for, jsonify, request
from api.user import user_bp
from helpers import getIP
from datetime import datetime, timedelta
from api.middlewares import token_required, handle_exceptions
from api.extensions import db
from api.models.models import *
from api.models import fee_service

@user_bp.route('/<int:household_id>/<int:amount>/pay')
def pay(household_id, amount):
    vnp_Amount = amount*100
    vnp_IpAddr = getIP()
    vnp_OrderInfo = f'Transaction for {household_id}'
    CreateDate = datetime.now()
    ExpireDate = CreateDate + timedelta(minutes = 10)
    vnp_CreateDate = CreateDate.strftime('%Y%m%d%H%M%S')
    vnp_ExpireDate = ExpireDate.strftime('%Y%m%d%H%M%S')

    return redirect(url_for('pay.payment', vnp_Amount=vnp_Amount, vnp_IpAddr=vnp_IpAddr, vnp_OrderInfo=vnp_OrderInfo, vnp_CreateDate=vnp_CreateDate, vnp_ExpireDate=vnp_ExpireDate))
    
@user_bp.get('/info')
@token_required
@handle_exceptions
def user_info(data):
    user = Users.query.filter_by(user_id = data.get('user_id')).first()
    info = {
        'user_id' : user.user_id,
        'username' : user.username,
        'user_role' : user.user_role,
        'user_email': user.user_email,
        'phone_number': user.phone_number,
        
    }
    return jsonify({'info': info}), 200
    
@user_bp.post('/update')   
@token_required
@handle_exceptions 
def update_user_info(data):
    user = Users.query.filter_by(user_id = data.get('user_id')).first()
    
    data = {
        'username' : request.form.get('new_name'),
        'user_email' : request.form.get('new_email'),
        'phone_number' : request.form.get('new_number')
    }
    for field, value in data.items():
        if value is not None:
            setattr(user, field, value)
            
    db.session.commit()
    return jsonify({'message': 'User info updated successfully!!!'}), 200        

@user_bp.route('/fees')
@token_required
def fees(data):
    user_id = data.get('user_id')
    resident_id = db.session.query(Residents.resident_id).filter(Residents.user_id == user_id).scalar()
    if not resident_id:
        return jsonify({'message': 'you do not have permission'}), 403
    
    fee_info = fee_service.user_get_current_fee(resident_id)
    result = {
        'amount' : fee_info.amount,
        'due_date' : fee_info.due_date,
        'status' : fee_info.status,
        'name_fee' : fee_info.description
    }
    return jsonify(result), 200
