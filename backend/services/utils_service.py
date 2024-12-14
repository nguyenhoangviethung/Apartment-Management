from api.extensions import db
import logging
from helpers import validate_date
from decimal import Decimal, InvalidOperation
from api.middlewares import handle_exceptions
from models.models import Vehicles

class UtilsService:
    def __init__(self):
        self.logger = logging.getLogger(__name__)
    
    @handle_exceptions   
    def get_park_fee_by_householdID(self, household_id):
        vehicles = db.session.query(
            Vehicles.vehicle_type
        ).filter(
            Vehicles.household_id == household_id
        ).all()

        num_cars, num_motors, num_bicycles = 0, 0, 0
        for vehicle in vehicles:
            if vehicle[0] == 'car':
                num_cars += 1
            elif vehicle[0] == 'motor':
                num_motors += 1
            elif vehicle[0] not in ('car', 'motor'):
                num_bicycles += 1
        
        amount = num_cars*(1200000) + num_motors*(70000)
        return {"amount": amount, "room": f"{household_id}", "num_car": f"{num_cars}", "num_motors": f"{num_motors}"}, 200
        

    def get_electric_fee_by_householdID(self, household_id):
        pass

    def get_electric_fee_by_householdID(self, household_id):
        pass

    def get_electric_fee_by_householdID(self, household_id):
        pass

    