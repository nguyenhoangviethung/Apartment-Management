from flask import *
from api.admin import admin_bp
from api.models.models import *
from datetime import datetime, timedelta
from vnpay import VNPAY
from pay import PAY

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
        
