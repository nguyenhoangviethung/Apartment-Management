class FeeInfo{
  int ?room_id;
  String ?service_charge;
  String ?manage_charge;
  String ?fee;

  FeeInfo(
      {required this.room_id,
        required this.service_charge,
        required this.manage_charge,
        required this.fee});
}
