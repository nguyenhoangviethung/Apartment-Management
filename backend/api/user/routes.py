from flask import redirect, url_for
from api.user import user_bp
from helpers import getIP
from datetime import datetime, timedelta

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
    
