class NotPaidRoomInfo{
  int ?room_id;
  int ?amount;
  String ?due_date;
  int ?service_fee;
  int ?manage_fee;
  String ?fee_type;

  NotPaidRoomInfo(
      {required this.room_id,
        required this.amount,
        required this.due_date,
        required this.service_fee,
        required this.manage_fee,
        required this.fee_type});
}
