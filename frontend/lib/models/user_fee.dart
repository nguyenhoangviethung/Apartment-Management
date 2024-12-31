class UserFee{
  String? amount;
  String? due_date;
  String? status;
  String? name_fee;
  int? fee_id;

  UserFee(this.amount, this.due_date, this.status, this.name_fee, this.fee_id);
  UserFee.fromJson(Map<String,dynamic> json){
    amount=json['amount'];
    due_date=json['due_date'];
    status=json['status'];
    name_fee=json['name_fee'];
    fee_id=json['fee_id'];
  }
}
class UserContributionFee{
  String? amount;
  String? description;
  String? due_date;
  int? fee_id;

  UserContributionFee(this.amount, this.description, this.due_date, this.fee_id);
  UserContributionFee.fromJson(Map<String,dynamic> json){
    amount=json['amount'];
    description=json['description'];
    due_date=json['due_date'];
    fee_id=json['fee_id'];
  }
}