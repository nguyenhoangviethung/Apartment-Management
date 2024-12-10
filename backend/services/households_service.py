from models.models import Residents, Households, Users
from api.middlewares import handle_exceptions
from api.extensions import db
import logging

class HouseholdsService:
    def __init__(self):
        self.logger = logging.getLogger(__name__)

    @handle_exceptions    
    def get_residents_by_household_id(self, household_id):
        residents = Residents.query.filter(Residents.household_id == household_id)
        if residents is None:
            return ({"message": "this household have no ownership"}), 404
        household = Households.query.filter(Households.household_id == household_id).first()
        if household is None:
            return ({"message": "this household have no ownership"}), 404
        result = {
            "info": [],
        }
        user = Users.query.filter(household.managed_by == Users.user_id).first()
        if user is None:
            return ({"message": "this household have no ownership"}) , 404
        owner = Residents.query.filter(Residents.user_id == user.user_id).first() 
        result['owner'] = {
                "resident_id": owner.resident_id,
                "resident_name": owner.resident_name,
                "date_of_birth": owner.date_of_birth,
                "id_number": owner.id_number,
                "phone_number": owner.phone_number,
                "status": owner.status
        }
        for resident in residents:
            if resident.user_id == owner.user_id:
                continue
            new_info = {
                "resident_id": resident.resident_id,
                "resident_name": resident.resident_name,
                "date_of_birth": resident.date_of_birth,
                "id_number": resident.id_number,
                "phone_number": resident.phone_number,
                "status": resident.status
            }
            result['info'].append(new_info)

        return result, 200