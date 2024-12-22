class UnpaidParkingFeeInfo{
  String ?room;
  double ?amount;
  String ?fee_type;

  UnpaidParkingFeeInfo(
      {required this.room,
        required this.amount,
        required this.fee_type}
      );
  UnpaidParkingFeeInfo.fromJson(Map<String,dynamic> json){
    room=json['room'];
    amount=json['amount'];
    fee_type=json['fee_type'];
  }
}