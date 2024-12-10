from models.models import Residents, Households
from sqlalchemy.orm import Session
from sqlalchemy.exc import SQLAlchemyError
from datetime import datetime
from api.extensions import db
import logging
from helpers import validate_date

class ResidentService:
    def __init__(self):
        self.logger = logging.getLogger(__name__)

    def create_resident(self, resident_data): # nho them kiem tra da ton tai resident_id
        try:
            existing_resident = db.query(Residents).filter_by(resident_id=resident_data.get('resident_id')).first()
            if existing_resident:
                raise Exception({"error": "Resident with this resident_id already exists."})
            dob = resident_data.get('date_of_birth')
            if dob:
                try:
                    date_of_birth = datetime.strptime(dob, '%Y-%m-%d').date()
                except ValueError:
                    raise Exception({"error": "Invalid date format for date_of_birth. Use YYYY-MM-DD."})
            else:
                date_of_birth = None
            if not db.query(Households).filter(Households.household_id == resident_data.get('household_id')).first():
                raise Exception(f'Household_id not found') 
            new_resident = Residents(
                resident_id = resident_data.get('resident_id'),
                user_id = resident_data.get('user_id'),
                household_id = resident_data.get('household_id'),
                resident_name = resident_data.get('resident_name'),
                date_of_birth=date_of_birth,
                id_number = resident_data.get('id_number'),
                status = resident_data.get('status'),
                phone_number = resident_data.get('phone_number')
            )
            
            db.add(new_resident)
            db.commit()
            db.refresh(new_resident)
            return new_resident
        except Exception as e:
            raise Exception(f'{e}')
    
    
    def add_resident(self, data):
        required_fields = ["resident_id", "household_id", "resident_name","status"]
        if not all(field in data for field in required_fields):
            return {'error': 'Missing required fields'}, 400
        
        existing_resident = db.session.query(Residents).filter_by(resident_id=data.get('resident_id')).first()
        if existing_resident:
            return ({"error": "Resident with this resident_id already exists."}), 404
        
        dob = data.get('date_of_birth')
        if dob:
            date_of_birth = validate_date(data.get('date_of_birth')) or None
        else:
            date_of_birth = None

        if not db.session.query(Households).filter(Households.household_id == data.get('household_id')).first():
                return (f'Household_id not found'), 404    

        new_resident = Residents(
            resident_id = data.get('resident_id'),
            user_id = data.get('user_id'),
            household_id = data.get('household_id'),
            resident_name = data.get('resident_name'),
            date_of_birth=date_of_birth,
            id_number = data.get('id_number'),
            status = data.get('status'),
            phone_number = data.get('phone_number'),
            household_registration = data.get('household_registration')
        )

        db.session.add(new_resident)
        db.session.commit()
        return ("messages: add resident succesfull"), 200

    def get_resident(self, resident_id):
        return db.query(Residents).filter(Residents.resident_id == resident_id).first()

    def remove_resident(self, resident_id):
        try:
            resident = self.get_resident(resident_id)
            if resident:
                db.delete(resident)
                db.commit()
                return True
            return False
        except SQLAlchemyError as e:
            db.rollback()
            raise Exception(f'Error removing resident {id} {e}')
        
    def update_resident(self, resident_id, resident_data):
        try:
            resident = self.get_resident(resident_id)
            if resident:
                for key, value in resident_data.items():
                    if hasattr(resident, key):  # Kiểm tra xem resident có thuộc tính đó không
                        setattr(resident, key, value)
                db.commit()
                db.refresh(resident)
                return True
            else:
                raise Exception('Resident not found')
        except SQLAlchemyError as e:
            db.rollback()  
            raise Exception(f'{e}')
            
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
                'res_id' : resident.resident_id
            }
            resident_list.append(resident_data)
        return resident_list

