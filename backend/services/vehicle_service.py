from models.models import Vehicles, Households
from api.extensions import db
from api.middlewares import handle_exceptions
import logging

class VehicleService:
    def __init__(self):
        self.logger = logging.getLogger(__name__)
        
    @handle_exceptions
    def add_vehicle(self, data):
        existing_vehicle = db.session.query(Vehicles).filter_by(vehicles_id=data.get('vehicles_id')).first()
        if existing_vehicle:
            return ("error: Resident with this resident_id already exists.") , 400
        
        if data.get('vehicle_type') in ['car', 'motor'] and not data.get('license_plate'):
            return {"error": "Vehicle must have a license plate"}, 400
        
        new_vehicle = Vehicles(
            vehicles_id = data.get('vehicles_id'),
            household_id = data.get('household_id'),
            license_plate = data.get('license_plate'),
            vehicle_type = data.get('vehicle_type')
        )
        db.session.add(new_vehicle)
        db.session.commit()
        db.session.refresh(new_vehicle)
        return ('message: add vehicle successfully'), 201
    
    def list_vehicles(self):
        vehicles = db.session.query(Vehicles).all()
        vehicle_list = []
        for vehicle in vehicles:
            vehicle_data = {
                'vehicles_id' : vehicle.vehicles_id,
                'household_id' : vehicle.household_id,
                'license_plate' : vehicle.license_plate,
                'vehicle_type' : vehicle.vehicle_type
            }
            vehicle_list.append(vehicle_data)
            
        return vehicle_list
    
    def remove_vehicle(self, vehicle_id):
        vehicle = db.session.query(Vehicles).filter_by(vehicles_id=vehicle_id).first()
        if vehicle:
            db.session.delete(vehicle)
            db.session.commit()
            return ("message: Vehicle removed successfully"), 201
        return ("message: Vehicle does not existed"), 404