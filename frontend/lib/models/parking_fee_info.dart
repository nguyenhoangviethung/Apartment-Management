class ParkingFeeResponse {
  List<String>? description;
  List<ParkingFeeInfo>? fees;

  ParkingFeeResponse({this.description, this.fees});

  factory ParkingFeeResponse.fromJson(Map<String, dynamic> json) {
    return ParkingFeeResponse(
      description: json['infor']['description'] != null
          ? List<String>.from(json['infor']['description'])
          : null,
      fees: json['infor']['detail'] != null
          ? (json['infor']['detail'] as List)
          .map((fee) => ParkingFeeInfo.fromJson(fee))
          .toList()
          : null,
    );
  }
}

class ParkingFeeInfo {
  String? room;
  String? fee;

  ParkingFeeInfo({this.room, this.fee});

  factory ParkingFeeInfo.fromJson(Map<String, dynamic> json) {
    return ParkingFeeInfo(
      room: json['room'] as String?,
      fee: json['fee'] as String?,
    );
  }
}
