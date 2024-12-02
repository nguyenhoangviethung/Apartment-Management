class NotPaidRoomInfo{
  String ?room;
  double ?amount;
  String ?due_date;
  double ?service_fee;
  double ?manage_fee;
  String ?fee_type;

  NotPaidRoomInfo(
      {required this.room,
        required this.amount,
        required this.due_date,
        required this.service_fee,
        required this.manage_fee,
        required this.fee_type}
      );
  NotPaidRoomInfo.fromJson(Map<String,dynamic> json){
    room=json['room'];
    amount=json['amount'];
    due_date=json['due_date'];
    service_fee=json['service_fee'];
    manage_fee=json['manage_fee'];
    fee_type=json['fee_type'];
  }

}