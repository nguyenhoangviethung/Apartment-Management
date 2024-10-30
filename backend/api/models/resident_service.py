from api.models.models import Residents
from sqlalchemy.orm import Session
from sqlalchemy.exc import SQLAlchemyError

class Resident_Service:
    def __init__(self, db : Session):
        self.db = db
    def create_resident(self, resident_data):
        try:
            resident = Residents(**resident_data)
            self.db.add(resident)
            self.db.commit()
            self.db.refresh(resident)
            return resident
        except SQLAlchemyError as e:
            self.db.rollback()
            raise Exception(f'Error creating resident {e}')
    
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


