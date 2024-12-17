class ParkingFeeResponse {
  int? amount;
  String? room;
  String? numCar;
  String? numMotors;

  ParkingFeeResponse({
    this.amount,
    this.room,
    this.numCar,
    this.numMotors,
  });

  factory ParkingFeeResponse.fromJson(Map<String, dynamic> json) {
    return ParkingFeeResponse(
      amount: json['amount'] as int?,
      room: json['room'] as String?,
      numCar: json['num_car'] as String?,
      numMotors: json['num_motors'] as String?,
    );
  }
}

class ParkingFeeInfo {
  String? room;
  int? amount;
  String? numCar;
  String? numMotors;

  ParkingFeeInfo({
    this.room,
    this.amount,
    this.numCar,
    this.numMotors,
  });

  factory ParkingFeeInfo.fromJson(Map<String, dynamic> json) {
    return ParkingFeeInfo(
      room: json['room'] as String?,
      amount: json['amount'] as int?,
      numCar: json['num_car'] as String?,
      numMotors: json['num_motors'] as String?,
    );
  }
}
