from api.admin import admin_bp
from flask import request, jsonify, redirect, url_for
from datetime import datetime, timedelta
import os
from vnpay import VNPAY
from random import randint
from api.models.models import *
from dotenv import load_dotenv

load_dotenv()

@admin_bp.route('/')
def index():
    return "ADMIN INDEX VIEW"

@admin_bp.route('/payment')
def payment():
    vnp_Amount = 10000000
    vnp_CreateDate = datetime.now().strftime('%Y%m%d%H%M%S')
    vnp_IpAddr = request.headers.get('X-Forwarded-For', request.remote_addr)
    vnp_OrderInfo = 'THANH TOAN HOA DON'
    vnp_ExpireDate = datetime.now() + timedelta(minutes=10)
    vnp_ExpireDate = vnp_ExpireDate.strftime('%Y%m%d%H%M%S')

    payment = VNPAY()
        
    payment.requestData['vnp_Version'] = '2.1.0'
    payment.requestData['vnp_Command'] = 'pay'
    payment.requestData['vnp_TmnCode'] = os.getenv('VNP_TMNCODE')
    payment.requestData['vnp_Amount'] = vnp_Amount
    # payment.requestData['vnp_BankCode'] = 'NCB'
    payment.requestData['vnp_CreateDate'] = vnp_CreateDate
    payment.requestData['vnp_CurrCode'] = 'VND'
    payment.requestData['vnp_IpAddr'] = vnp_IpAddr
    payment.requestData['vnp_Locale'] = 'vn'
    payment.requestData['vnp_OrderInfo'] = vnp_OrderInfo
        # 250000 thanh toan hoa don, need more flexible
    payment.requestData['vnp_OrderType'] = 'billpayment'
    payment.requestData['vnp_ReturnUrl'] = 'http://127.0.0.1:5000/admin/payment-return'
    payment.requestData['vnp_ExpireDate'] = vnp_ExpireDate
    payment.requestData['vnp_TxnRef'] = randint(10000, 99999)
            
    vnpay_payment_url = payment.get_payment_url(os.getenv('VNP_URL'), os.getenv('VNP_HASHSECRET'))
    # print(vnpay_payment_url)

    return redirect(vnpay_payment_url)

@admin_bp.route('/ipn')
def ipn():
    inputData = request.args
    if inputData:
        payment = VNPAY()
        payment.responseData = inputData.to_dict()

        order_id = inputData['vnp_TxnRef']
        amount = inputData['vnp_Amount']
        order_desc = inputData['vnp_OrderInfo']
        vnp_TransactionNo = inputData['vnp_TransactionNo']
        vnp_ResponseCode = inputData['vnp_ResponseCode']
        vnp_TmnCode = inputData['vnp_TmnCode']
        vnp_PayDate = inputData['vnp_PayDate']
        vnp_BankCode = inputData['vnp_BankCode']
        vnp_CardType = inputData['vnp_CardType']

        if payment.validate_response(os.getenv('VNP_HASHSECRET')):
            # Check & Update Order Status in your Database
            # Your code here
            firstTimeUpdate = True
            totalamount = True
            if totalamount:
                if firstTimeUpdate:
                    if vnp_ResponseCode == '00':
                        print('Payment Success. Your code implement here')
                    else:
                        print('Payment Error. Your code implement here')

                    # Return VNPAY: Merchant update success
                    result = jsonify({'RspCode': '00', 'Message': 'Confirm Success'})
                else:
                        # Already Update
                    result = jsonify({'RspCode': '02', 'Message': 'Order Already Update'})
            else:
                    # invalid amount
                result = jsonify({'RspCode': '04', 'Message': 'invalid amount'})
        else:
                # Invalid Signature
            result = jsonify({'RspCode': '97', 'Message': 'Invalid Signature'})
    else:
            result = jsonify({'RspCode': '99', 'Message': 'Invalid request'})

    return result

@admin_bp.route('/payment-return')
def payment_return():
    inputData = request.args
    if inputData:
        payment = VNPAY()
        payment.responseData = inputData.to_dict()

        order_id = inputData['vnp_TxnRef']
        amount = inputData['vnp_Amount']
        order_desc = inputData['vnp_OrderInfo']
        vnp_TransactionNo = inputData['vnp_TransactionNo']
        vnp_ResponseCode = inputData['vnp_ResponseCode']
        vnp_TmnCode = inputData['vnp_TmnCode']
        vnp_PayDate = inputData['vnp_PayDate']
        vnp_BankCode = inputData['vnp_BankCode']
        vnp_CardType = inputData['vnp_CardType']

        if payment.validate_response(os.getenv('VNP_HASHSECRET')):
            if vnp_ResponseCode == '00':
                result = jsonify({'message':'thanh toan thanh cong'})
            else:
                result = jsonify({'message':'thanh toan that bai'})
        else:
                # Invalid Signature
            result = jsonify({'Message': 'sai checksum'})
    else:
            result = jsonify({'RspCode': '99', 'Message': 'Invalid request'})
    
    return result

@admin_bp.route('/fee/<int:household_id>')
def fee(household_id):
    
    service_rate = db.session.query(Fees.service_rate).filter_by(household_id=household_id).scalar() or 0
    manage_rate = db.session.query(Fees.manage_rate).filter_by(household_id=household_id).scalar() or 0
    area = db.session.query(Households.area).filter_by(household_id=household_id).scalar() or 0
    service_charge = service_rate*float(area)
    manage_charge = manage_rate*float(area)
    amount = (service_rate + manage_rate)*float(area)

    return jsonify(
        {
            'service_charge': f'{service_charge}', 
            'manage_charge' : f'{manage_charge}', 
            'fee' : f'{amount}'
        }
    )

@admin_bp.route('/not-pay')
def not_pay():
    
    household_ids = db.session.query(Fees.household_id).filter_by(status = 'Chưa thanh toán').all()
    res = []
    for household_id in household_ids:
        # get household_id
        household_id = household_id[0]
        service_rate = db.session.query(Fees.service_rate).filter_by(household_id=household_id).scalar() or 0
        manage_rate = db.session.query(Fees.manage_rate).filter_by(household_id=household_id).scalar() or 0
        area = db.session.query(Households.area).filter_by(household_id=household_id).scalar() or 0
        amount = (service_rate + manage_rate)*float(area)

        infor = {
                'room_number': f'{household_id}',
                'fee' : f'{amount}'
            }

        res.append(infor)

    result = jsonify(res)

    return result
