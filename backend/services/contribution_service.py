from models.models import Contributions, Households, Residents
from api.extensions import db
import logging
from api.middlewares import handle_exceptions
from decimal import Decimal, InvalidOperation
from helpers import validate_date, decimal_to_float
from datetime import datetime

class ContributionService:
    def __init__(self):
        self.logger = logging.getLogger(__name__)
    
    def add_contribution_fee(self, data, creator):
        required_fields = ['start_date', 'due_date', 'description', 'amount']

        if not all(field in data for field in required_fields):
            return {'error': 'Missing required fields'}, 400

        try:
            start_date = validate_date(data['start_date'])
            due_date = validate_date(data['due_date'])
            amount = Decimal(data['amount'])
        except (ValueError, InvalidOperation) as e:
            return {'error': str(e)}, 400
        # remind check the white space
        existing_fee = Contributions.query.filter_by(contribution_type=data['description'].strip()).first()

        if existing_fee:
            return {'error': 'A contribution fee with this description already exists'}, 400
        
        households = db.session.query(Households.household_id, Households.area, Households.num_residents).all()

        if not households:
            return {'error': 'No households found'}, 404

        # Tạo danh sách phí đóng góp
        new_contributions = []
        for household in households:
            if household.num_residents == 0:
                self.logger.warning(f"Skipping household ID {household.household_id} with zero residents.")
                continue

            new_contribution = Contributions(
                contribution_amount=amount,
                create_date=start_date,
                due_date=due_date,
                household_id=household.household_id,
                contribution_type=data['description'],
                created_by=creator
            )
            new_contributions.append(new_contribution)
        
        db.session.add_all(new_contributions)
        db.session.commit()
        self.logger.info(f"Added fees for {len(new_contributions)} households.")
        return {'message': 'Add fee successful', 'added_count': len(new_contributions)}, 200


    @handle_exceptions
    def delete_contribution_fee(self, description):
        if not description:
            return {'error': 'Description not provided'}, 400
        
        contribution_fees = Contributions.query.filter(Contributions.contribution_type == description.strip()).all()
        
        if not contribution_fees:
            return {'error': 'No contribution fees found with the given description'}, 404
        
        deleted_fees = [fee.contribution_id for fee in contribution_fees]
        for contribution_fee in contribution_fees:
            db.session.delete(contribution_fee)

        db.session.commit()
        self.logger.info(f"Deleted fees with IDs: {deleted_fees}")
        return {'message': 'Delete successful', 'deleted_count': len(deleted_fees)}, 200

    @handle_exceptions
    def update_contribution_fee(self, data, updater):
        required_fields = ['description', 'amount']

        if not all(field in data for field in required_fields):
            return {'error': 'Missing required fields'}, 400
        
        try:
            amount = Decimal(data['amount'])
        except InvalidOperation:
            return {'error': 'Invalid amount value'}, 400
        
        contribution_fees = Contributions.query.filter(
            Contributions.contribution_type == data['description']
        ).all()

        if not contribution_fees:
            return {'error': 'No contribution fees found with the given description'}, 404
        updated_count = 0
        for contribution_fee in contribution_fees:
            household = Households.query.filter_by(household_id=contribution_fee.household_id).first()
            
            if not household:
                self.logger.warning(f"Household not found for contribution_fee ID {contribution_fee.contribution_id}")
                continue  

            contribution_fee.contribution_amount = amount
            contribution_fee.updated_by = updater
            updated_count += 1

        db.session.commit()
        self.logger.info(f"Updated {updated_count} fees successfully.")
        return {'message': 'Update successful', 'updated_count': updated_count}, 200

    @handle_exceptions
    def get_contributions(self):
        query_date = datetime.now().date()

        result = []

        contributions = (
                db.session.query(
                    Contributions.contribution_type,
                    Contributions.contribution_amount,
                )
                .filter(query_date <= Contributions.due_date)
                .distinct()
                .all()
            )

        result = [{"description": contribution.contribution_type, "amount": contribution.contribution_amount} for contribution in contributions]
        response = {"result": result}
        return response, 200
    
    @handle_exceptions
    def get_contributions_v2(self):
        query_date = datetime.now().date()
        
        result = []

        contributions = (
                db.session.query(
                    Contributions.contribution_type,
                    Contributions.contribution_amount,
                )
                .filter(query_date <= Contributions.due_date)
                .distinct()
                .all()
            )
        
        for contribution in contributions:
            info  = {"description": contribution.contribution_type, "detail": []}
            households = db.session.query(Contributions.household_id).filter(Contributions.contribution_type == contribution.contribution_type).all()
            for household in households:
                id = household.household_id
                info['detail'].append({"amount": contribution.contribution_amount, "room": id})
            
            result.append(info)

        return result, 200
    
    @handle_exceptions
    def get_current_household_fee(self, household_id):
        now = datetime.now().date()
        fees = db.session.query(Contributions).filter(Contributions.household_id == household_id, now <= Contributions.due_date).all()
        
        return fees
    
    @handle_exceptions
    def user_get_current_fee(self, resident_id):
        households_id = db.session.query(Residents.household_id).filter(Residents.resident_id == resident_id).scalar()
        # get fee by household
        return self.get_current_household_fee(households_id)
    
    @handle_exceptions
    def get_fee_by_userID(self, data):
        
        required_fields = ["user_id"]

        if not all(field in data for field in required_fields):
            return {'error': 'Missing required fields'}, 400

        user_id = data["user_id"]
        resident_id = db.session.query(Residents.resident_id).filter(Residents.user_id == user_id).scalar()

        if not resident_id:
            return ({'message': 'you do not have permission'}), 403
        
        household_id = db.session.query(Residents.household_id).filter(Residents.resident_id == resident_id).scalar()
        fees = db.session.query(Contributions).filter(Contributions.household_id == household_id).all()
        response = []

        for fee in fees:
            info = {
                "amount": fee.contribution_amount,
                "due_date": datetime.strftime(fee.due_date, "%Y-%m-%d"),
                "description": fee.contribution_type
            }
            response.append(info)

        return (response), 200
