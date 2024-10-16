from api.admin import admin_bp
from flask import jsonify, request, redirect, url_for
from api.models.models import *
from dotenv import load_dotenv
from helpers import getIP
from datetime import datetime, timedelta

load_dotenv()

@admin_bp.route('/')
def index():
    return "ADMIN INDEX VIEW"    

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
    
    household_ids = db.session.query(Fees.household_id).filter_by(status = 'Chưa thanh toán').all()
    res = []
    household_ids = sorted(household_ids)
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
    
