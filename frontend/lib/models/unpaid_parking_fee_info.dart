class UnpaidParkingFeeInfo{
  String ?room;
  double ?amount;
  String ?fee_type;
  int ?fee_id;

  UnpaidParkingFeeInfo(
      {required this.room,
        required this.amount,
        required this.fee_type,
        required this.fee_id}
      );
  UnpaidParkingFeeInfo.fromJson(Map<String,dynamic> json){
    room=json['room'];
    amount=json['amount'];
    fee_type=json['fee_type'];
    fee_id=json['fee_id'];
  }
}