from flask import redirect, url_for, jsonify, request
from api.user import user_bp
from helpers import getIP
from datetime import datetime, timedelta
from api.middlewares import token_required, handle_exceptions
from api.extensions import db
from api.models.models import *

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
        'username' : user.username,
        'user_role' : user.user_role,
        'user_email': user.user_email,
        'phone_number': user.phone_number
    }
    return jsonify({'info': info}), 200
    
# @user_bp.route('/update')   
# @token_required
# @handle_exceptions 
# def update_info(data):
#     user = Users.query.filter_by(user_id = data.get('user_id')).first()
#     username = request.form.get('new_name')
    
#     user_email
#     phone_number