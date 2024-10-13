from flask import request, redirect
import os
from dotenv import load_dotenv
from random import randint
from vnpay import VNPAY

load_dotenv()

class PAY:

    def qr_payment(self, vnp_Amount, vnp_CreateDate, vnp_IpAddr, vnp_OrderInfo, vnp_ExpireDate):
        payment = VNPAY()

        payment.requestData['vnp_Version'] = '2.1.1'
        payment.requestData['vnp_Command'] = 'pay'
        payment.requestData['vnp_TmnCode'] = os.getenv('VNP_TMNCODE')
        payment.requestData['vnp_Amount'] = vnp_Amount
        payment.requestData['vnp_BankCode'] = 'VNPAYQR'
        payment.requestData['vnp_CreateDate'] = vnp_CreateDate
        payment.requestData['vnp_CurrCode'] = 'VND'
        payment.requestData['vnp_IpAddr'] = vnp_IpAddr
        payment.requestData['vnp_Locale'] = 'vn'
        payment.requestData['vnp_OrderInfo'] = vnp_OrderInfo
        # 250000 thanh toan hoa don, need more flexible
        payment.requestData['vnp_OrderType'] = 'billpayment'
        payment.requestData['vnp_ReturnUrl'] = 'https://apartment-management-kjj9.onrender.com/'
        payment.requestData['vnp_ExpireDate'] = vnp_ExpireDate
        payment.requestData['vnp_TxnRef'] = randint(10000, 99999)
        
        vnpay_payment_url = payment.get_payment_url(os.getenv('VNP_URL'), os.getenv('VNP_HASHSECRET'))
        print(vnpay_payment_url)
        return redirect(vnpay_payment_url)
        

