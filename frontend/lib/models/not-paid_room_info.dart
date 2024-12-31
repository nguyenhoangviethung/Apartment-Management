class NotPaidRoomInfo{
  String ?room;
  double ?amount;
  String ?due_date;
  double ?service_fee;
  double ?manage_fee;
  String ?fee_type;
  int ?fee_id;
  String ?household_name;

  NotPaidRoomInfo(
      {required this.room,
        required this.amount,
        required this.due_date,
        required this.service_fee,
        required this.manage_fee,
        required this.fee_type,
        required this.fee_id,
        required this.household_name}
      );
  NotPaidRoomInfo.fromJson(Map<String,dynamic> json){
    room=json['room'];
    amount=json['amount'];
    due_date=json['due_date'];
    service_fee=json['service_fee'];
    manage_fee=json['manage_fee'];
    fee_type=json['fee_type'];
    fee_id=json['fee_id'];
    household_name=json['household_name'];
  }

}