from flask import request, redirect, jsonify,render_template
import os
from dotenv import load_dotenv
from random import randint
from vnpay import VNPAY
from api.pay import pay_bp
from datetime import datetime, timedelta
from services import fee_service, user_service,transaction_service, utils_service, contribution_service
load_dotenv()

fee_service = fee_service.FeeService()
user_service = user_service.UserService()
transaction_service = transaction_service.TransactionService()
utils_service = utils_service.UtilsService()
contribution_service = contribution_service.ContributionService()
@pay_bp.route('/payment')
def payment():
    vnp_Amount = request.args.get('vnp_Amount', type = int)
    vnp_IpAddr = request.args.get('vnp_IpAddr', type = str)
    vnp_OrderInfo = request.args.get('vnp_OrderInfo', type = str)
    vnp_CreateDate = request.args.get('vnp_CreateDate', type = str)
    vnp_ExpireDate = request.args.get('vnp_ExpireDate', type = str)
    vnp_TxnRef = request.args.get('vnp_TxnRef', type =str)
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
    payment.requestData['vnp_TxnRef'] = vnp_TxnRef
            
    vnpay_payment_url = payment.get_payment_url(os.getenv('VNP_URL'), os.getenv('VNP_HASHSECRET'))
    # print(vnpay_payment_url)

    return jsonify(vnpay_payment_url), 200

@pay_bp.route('/payment-return')
def payment_return():
    inputData = request.args
    print(inputData)
    if inputData:
        payment = VNPAY()
        payment.responseData = inputData.to_dict()

        order_id = inputData['vnp_TxnRef']
        amount = inputData['vnp_Amount']
        amount = float(amount)/100
        order_desc = inputData['vnp_OrderInfo']
        vnp_TransactionNo = inputData['vnp_TransactionNo']
        vnp_ResponseCode = inputData['vnp_ResponseCode']
        vnp_TmnCode = inputData['vnp_TmnCode']
        vnp_PayDate = inputData['vnp_PayDate']
        vnp_BankCode = inputData['vnp_BankCode']
        vnp_CardType = inputData['vnp_CardType']

        if payment.validate_response(os.getenv('VNP_HASHSECRET')):
            if vnp_ResponseCode == '00':
                desc = order_desc.strip().split()
                if desc[1] == 'Electric':
                    tp = utils_service.get_electric_fee(desc[2])
                    utils_service.update_electric(desc[2])
                    data = {
                        "description": "Electricity Bill",
                        "amount": amount,
                        "status": "Paid"
                    }
                    return render_template("transaction_success.html", **data), 302
                if desc[1] == 'Water':
                    tp = utils_service.get_water_fee(desc[2])
                    utils_service.update_water(desc[2])
                    data = {
                        "description": "Water Bill",
                        "amount": amount,
                        "status": "Paid"
                    }
                    return render_template("transaction_success.html", **data), 302
                data = dict()
                description = desc[7:-1]
                description.append(desc[-1])
                description_str = " ".join(map(str, description))
                print(description_str)
                data = {
                    "description": description_str,
                    "amount": amount,
                    "transaction_id": order_id,
                    "fee_id": None,
                    "park_id": None,
                    "contribution_id": None,
                    "user_pay": desc[6],
                    "user_name": user_service.get_username(desc[6]),
                    "transaction_time": vnp_PayDate,
                    "bank_code": vnp_BankCode,
                    "type": vnp_CardType,
                }
                if desc[1] == 'Fee':
                    fee = fee_service.get_fee_by_fee_id(fee_id = desc[2])
                    remain_amount = float(fee.amount) - amount
                    data_= {}
                    if remain_amount == 0 or remain_amount < 0:
                        data_['status'] = 'Đã thanh toán'
                    fee_service.update_status(data_, fee_id = desc[2])    
                    data['fee_id'] = desc[2]
                    transaction_service.add_transaction(data)
                if desc[1] == 'Contribution':
                    contribution = contribution_service.get_contribution_by_contribution_id(desc[2])
                    remain_amount = float(contribution.contribution_amount) + amount
                    data_ = {}
                    if remain_amount:
                        data_['status'] = 'Đã thanh toán'
                        data_['amount'] = remain_amount
                    contribution_service.update_status(data_, contribution_id = desc[2])   
                    data["contribution_id"] = desc[2]
                    transaction_service.add_transaction(data)

                if desc[1] == 'Parking':
                    park_fee = utils_service.get_park_fee_by_park_id(park_id = desc[2])
                    remain_amount = float(park_fee.amount) - amount
                    data_ = {}
                    if remain_amount == 0 or remain_amount < 0:
                        data_['status'] = 'Đã thanh toán'
                    utils_service.update_status(data_, park_id = desc[2])   
                    data['park_id'] = desc[2]
                    transaction_service.add_transaction(data)
                data = {
                    "description": description_str,
                    "amount": amount,
                    "status": "Paid"
                }
                return render_template("transaction_success.html", **data), 302
                                  
            else:
                data = {
                    "description": description_str,
                    "amount": amount,
                    "status": "Unpaid"
                }
                return render_template("transaction_success.html", **data), 406
        else:
            return jsonify({'Message': 'sai checksum'}), 400
    else:
            return jsonify({'RspCode': '99', 'Message': 'Invalid request'}), 400

        
        