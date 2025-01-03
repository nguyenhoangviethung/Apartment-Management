from models.models import Residents, Households
from sqlalchemy.orm import Session
from sqlalchemy.exc import SQLAlchemyError
from datetime import datetime
from api.extensions import db
import logging
from helpers import validate_date
from api.middlewares import handle_exceptions


class ResidentService:
    def __init__(self):
        self.logger = logging.getLogger(__name__)
    @handle_exceptions
    def add_resident(self, resident_data): # nho them kiem tra da ton tai resident_id
        existing_resident = db.session.query(Residents).filter_by(resident_id=resident_data.get('resident_id')).first()
        if existing_resident:
            return ("error: Resident with this resident_id already exists.") , 400
        dob = resident_data.get('date_of_birth')
        try:
            date_of_birth = validate_date(dob)
        except:
            return ("error: Invalid date") , 400
        if not db.session.query(Households).filter(Households.household_id == resident_data.get('household_id')).first():
            return ('error: Household_id not found') , 400
        new_resident = Residents(
            id_number = resident_data.get('resident_id'),
            user_id = resident_data.get('user_id'),
            household_id = resident_data.get('household_id'),
            resident_name = resident_data.get('resident_name'),
            date_of_birth=date_of_birth,
            status = resident_data.get('status'),
            phone_number = resident_data.get('phone_number')
        )
        
        db.session.add(new_resident)
        db.session.commit()
        db.session.refresh(new_resident)
        return ('message: add resident successfully'), 201

    def get_resident(self, resident_id):
        return db.session.query(Residents).filter(Residents.resident_id == resident_id).first()

    @handle_exceptions
    def remove_resident(self, resident_id):
        resident = self.get_resident(resident_id)
        if resident:
            db.session.delete(resident)
            db.session.commit()
            return ("message: Resident removed successfully"), 201
        return ("message: Resident is not existed"), 404
    @handle_exceptions
    def update_resident(self, resident_id, resident_data):
        resident = self.get_resident(resident_id)
        if resident:
            if resident_data is None:
                return 'warning: please provide at least one field', 401
            for key, value in resident_data.items():
                if key == 'resident_id':
                    continue
                if hasattr(resident, key): 
                    setattr(resident, key, value)
            db.session.commit()
            db.session.refresh(resident)
            return ("message: Resident updated successfully"), 201
        else:
            return ("message: resident_id not found"), 404
            
    def show_all_residents(self):
        residents = Residents.query.all()
        resident_list = []
        year = datetime.today().year
        for resident in residents:
            dob = resident.date_of_birth if not None else None
            
            age = None if dob == None else year - dob.year 
            resident_data = {
                'full_name' : resident.resident_name,
                'date_of_birth' : dob,
                'id_number' : resident.id_number,
                'age' : age,
                'room' : resident.household_id,
                'phone_number' : resident.phone_number,
                'status' : resident.status,
                'household_registration' : resident.household_registration,
                'res_id' : resident.resident_id,
                'user_id' : resident.user_id
            }
            resident_list.append(resident_data)
        return resident_list
