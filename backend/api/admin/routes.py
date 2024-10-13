from api.admin import admin_bp
from flask import request, jsonify, redirect
from datetime import datetime, timedelta
from pay import PAY
import os

@admin_bp.route('/', methods = ['GET'])
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

@admin_bp.route('/qrpayment', methods = ['POST'])
def qr():
    if request.method == 'POST':
        amount = request.form.get('amount')
        created_time = datetime.now()
        expired_time = created_time + timedelta(minutes=15)
        infor = 'CHUYEN TIEN QR CODE'
        ip = request.headers.get('X-Forwarded-For', request.remote_addr)
        payment = PAY().qr_payment(amount, created_time, ip, infor, expired_time)

        vnpay_payment_url = payment.get_payment_url(os.getenv('VNP_URL'), os.getenv('VNP_HASHSECRET'))

        redirect()

        return jsonify({"message" : "qrpayment oke"})
    
    else:
        return redirect('https:google.com')