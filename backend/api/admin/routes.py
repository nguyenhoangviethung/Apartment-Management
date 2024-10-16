from api.admin import admin_bp
from flask import jsonify, request
from api.models.models import *
from dotenv import load_dotenv

load_dotenv()

@admin_bp.route('/')
def index():
    return "ADMIN INDEX VIEW" 

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
    
    
