from api.models.models import Contributions, Households
from api.extensions import db
import logging
from api.middlewares import handle_exceptions
from decimal import Decimal, InvalidOperation
from helpers import validate_date
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
        
        existing_fee = Contributions.query.filter_by(contribution_type=data['description']).first()

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
        
        contribution_fees = Contributions.query.filter(Contributions.contribution_type == description).all()
        
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

    def get_contributions(self):
        query_date = datetime.now().date()

        fee = (
            db.session.query(Contributions.contribution_type)
            .filter(query_date <= Contributions.due_date)
            .first()
        )

        fee_ids = (
            db.session.query(Contributions.contribution_id)
            .filter(query_date <= Contributions.due_date)
            .all()
        )

        res = {"infor": {"description": [], "detail": []}}

        if fee:
            res["infor"]["description"].append(fee[0])

        for fee_id in fee_ids:
            f_id = fee_id[0]
            contribution = (
                    db.session.query(
                        Contributions.contribution_amount,
                        Contributions.household_id,
                    )
                    .filter(Contributions.contribution_id == f_id)
                    .first()
                )
            if not contribution or not contribution[0]:
                continue
        
        amount, household_id = contribution
        
        info = {
            "contribution fee": f"{amount}",
            "room": f"{household_id}",
        }
        res["infor"]["detail"].append(info)

        self.logger.info(f"Retrieved contributions with {len(res['infor']['detail'])} details.")
        return res, 200