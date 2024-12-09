from flask import request, redirect, jsonify
import os
from dotenv import load_dotenv
from random import randint
from vnpay import VNPAY
from api.pay import pay_bp
from datetime import datetime, timedelta

load_dotenv()


@pay_bp.route('/payment')
def payment():
    vnp_Amount = request.args.get('vnp_Amount', type = int)
    vnp_IpAddr = request.args.get('vnp_IpAddr', type = str)
    vnp_OrderInfo = request.args.get('vnp_OrderInfo', type = str)
    vnp_CreateDate = request.args.get('vnp_CreateDate', type = str)
    vnp_ExpireDate = request.args.get('vnp_ExpireDate', type = str)

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
    #todo
    payment.requestData['vnp_ReturnUrl'] = 'https://apartment-management-kjj9.onrender.com/pay/payment-return'
    payment.requestData['vnp_ExpireDate'] = vnp_ExpireDate
    payment.requestData['vnp_TxnRef'] = randint(10000, 99999)
            
    vnpay_payment_url = payment.get_payment_url(os.getenv('VNP_URL'), os.getenv('VNP_HASHSECRET'))
    # print(vnpay_payment_url)

    return jsonify(vnpay_payment_url), 200

@pay_bp.route('/ipn')
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

@pay_bp.route('/payment-return')
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
                return jsonify({'message':'thanh toan thanh cong'}), 302
            else:
                return jsonify({'message':'thanh toan that bai'}), 406
        else:
                # Invalid Signature
            return jsonify({'Message': 'sai checksum'}), 400
    else:
            return jsonify({'RspCode': '99', 'Message': 'Invalid request'}), 400

        
        