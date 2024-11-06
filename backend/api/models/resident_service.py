from api.models.models import Residents
from sqlalchemy.orm import Session
from sqlalchemy.exc import SQLAlchemyError
import datetime

class Resident_Service:
    def __init__(self, db : Session):
        self.db = db
    def create_resident(self, resident_data): # nho them kiem tra da ton tai resident_id
        try:
            dob = resident_data.get('date_of_birth')
            if dob:
                date_of_birth = datetime.strptime(dob, '%Y-%m-%d').date()

            else:
                date_of_birth = None
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
            
            self.db.add(new_resident)
            self.db.commit()
            self.db.refresh(new_resident)
            return new_resident

        except ValueError as e:

            print(f"Date format error: {e}")
            return {"error": "Invalid date format for date_of_birth. Use YYYY-MM-DD."}
        except Exception as e:
            print(f"Unexpected error: {e}")
            return {"error": "An error occurred while creating resident"}
    
    def get_resident(self, resident_id):
        return self.db.query(Residents).filter(Residents.resident_id == resident_id).first()

    def remove_resident(self, resident_id):
        try:
            resident = self.get_resident(resident_id)
            if resident:
                self.db.delete(resident)
                self.db.commit()
                return True
            return False
        except SQLAlchemyError as e:
            self.db.rollback()
            raise Exception(f'Error removing resident {id} {e}')
        
    def update_resident(self, resident_id, resident_data):
        try:
            resident = self.get_resident(resident_id)
            if resident:
                for key, value in resident_data.items():
                    setattr(self, key, value)
                self.db.commit()
                self.db.refresh(resident_id)
                return True
            else:
                raise Exception('Resident not found')
        except SQLAlchemyError as e:
            self.db.rollback()  
            raise Exception(f'{e}')
            


