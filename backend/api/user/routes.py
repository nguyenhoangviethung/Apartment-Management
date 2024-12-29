from flask import redirect, url_for, jsonify, request
from api.user import user_bp
from helpers import getIP
from datetime import datetime, timedelta
from api.middlewares import token_required, handle_exceptions
from api.extensions import db
from models.models import *
from services import fee_service, cloudinary_service, contribution_service, utils_service, user_service
import cloudinary
import uuid
from pytz import utc

fee_service = fee_service.FeeService()
contribution_service = contribution_service.ContributionService()
utils_service = utils_service.UtilsService()
user_service = user_service.UserService()

@user_bp.route('/')
def index():
    try:
        # Dữ liệu để cập nhật
        data = {'amount': 660000, 'status': 'Chưa thanh toán'}
        result = fee_service.update_status(data, fee_id = 111)
        
        return result
    except Exception as e:
        return f'Lỗi: {str(e)}'
    
def process_payment(user_id, identifier, amount, description, transaction_type):
    vnp_Amount = int(amount * 100)
    vnp_IpAddr = getIP()
    vnp_OrderInfo = f'Transaction {transaction_type} {identifier} {amount} for by {user_id} {description}'
    CreateDate = datetime.now()
    # test thu nen can fix
    ExpireDate = CreateDate + timedelta(minutes=430)
    vnp_CreateDate = CreateDate.strftime('%Y%m%d%H%M%S')
    vnp_ExpireDate = ExpireDate.strftime('%Y%m%d%H%M%S')
    vnp_TxnRef = str(uuid.uuid4())
    payment_url = url_for(
        'pay.payment',
        vnp_Amount=vnp_Amount,
        vnp_IpAddr=vnp_IpAddr,
        vnp_OrderInfo=vnp_OrderInfo,
        vnp_CreateDate=vnp_CreateDate,
        vnp_ExpireDate=vnp_ExpireDate,
        vnp_TxnRef=vnp_TxnRef,
        _external = True
    )

    return jsonify({
        "payment_url": payment_url
    })
@handle_exceptions
@user_bp.get('/<int:user_id>/<int:fee_id>/<int:amount>/<string:description>/pay-fee')
def pay_fee(user_id, fee_id, amount, description):
    return process_payment(user_id, fee_id, amount, description, transaction_type="Fee"), 200

@handle_exceptions
@user_bp.get('/<int:user_id>/<int:park_id>/<int:amount>/<string:description>/pay-park-fee')
def pay_park_fee(user_id, park_id, amount, description):
    return process_payment(user_id, park_id, amount, description, transaction_type="Parking"), 200

@handle_exceptions
@user_bp.get('/<int:user_id>/<int:contribution_id>/<int:amount>/<string:description>/pay-contribution-fee')
def pay_contribution_fee(user_id, contribution_id, amount, description):
    return process_payment(user_id, contribution_id, amount, description, transaction_type="Contribution"), 200
@handle_exceptions
@user_bp.get('/<string:customer_id>/pay-electric-fee')
def pay_electric_fee(customer_id,):
    data, status_code = utils_service.get_electric_fee(customer_id)
    if isinstance(data, str):
        return data, status_code
    return process_payment(user_id = 2 , identifier = customer_id, description = "Thu ho", amount = int(data['amount']), transaction_type = "Electric"), 200
@handle_exceptions
@user_bp.get('/<string:customer_id>/pay-water-fee')
def pay_water_fee(customer_id,):
    data, status_code = utils_service.get_water_fee(customer_id)
    if isinstance(data, str):
        return data, status_code
    return process_payment(user_id = 2 , identifier = customer_id, description = "Thu ho", amount = int(data['amount']), transaction_type = "Water"), 200
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
def fees(request_data):
    # data = {"user_id": request_data["user_id"]}
    response, status_code = fee_service.get_fee_by_userID(request_data)
    return jsonify(response), status_code
    
@user_bp.route('/contributions')
@token_required
def contributions(request_data):
    response, status_code = contribution_service.get_fee_by_userID(request_data)

    return jsonify(response), status_code
    
@user_bp.route('/park-fees')
@token_required
def park_fees(request_data):
    response, status_code = utils_service.get_fee_by_userID(request_data)

    return jsonify(response), status_code

@user_bp.route('/upload-image', methods=["POST"])
@token_required
@handle_exceptions
def upload_image(data):
    
    default_img: str = "https://res.cloudinary.com/dxjwzkk8j/image/upload/v1733854843/default.png"

    path_to_image = request.form.get("path_to_image", default_img)
    uploaded_file = request.files.get("file")  

    try:
        user_id = data.get('user_id')
        if not user_id:
            return jsonify({"error": "Missing user_id"}), 400

        img_name = f"avatar/{str(user_id)}"

        if uploaded_file:
            res = cloudinary_service.save_and_upload_image(
                file=uploaded_file,
                public_id=img_name,
                upload_folder="temp_uploads"
            )
        else:
            res = cloudinary_service.upload_image_to_cloudinary(
                path_to_img=path_to_image,
                public_id=img_name
            )

        img_url = res.get("secure_url")
        if not img_url:
            return jsonify({"error": "Image URL not found"}), 500

        return jsonify({"img_url": img_url}), 200

    except cloudinary.exceptions.Error as e:
        return jsonify({"error": "Failed to upload image", "details": str(e)}), 500

    except KeyError as e:
        return jsonify({"error": f"Missing key in response: {str(e)}"}), 500

    except Exception as e:
        return jsonify({"error": "An unexpected error occurred", "details": str(e)}), 500

@user_bp.post('/become-resident/<int:res_id>')
@token_required
@handle_exceptions
def to_resident(data, res_id):
    response, status_code = user_service.convert_to_resident(data, res_id)
    return jsonify(response), status_code

@user_bp.post('/get-electric-bill/')
@handle_exceptions
def get_electric_bill():
    data = request.form.to_dict()
    customer_id = data['customer_id']
    response, status_code = utils_service.get_electric_fee(customer_id)
    return response, status_code

@user_bp.post('/get-water-bill/')
@handle_exceptions
def get_water_bill():
    data = request.form.to_dict()
    customer_id = data['customer_id']
    response, status_code = utils_service.get_water_fee(customer_id)
    return response, status_code