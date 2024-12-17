class FeeResponse {
  List<String>? description;
  List<ParkingFeeInfo>? fees;

  FeeResponse({this.description, this.fees});

  factory FeeResponse.fromJson(Map<String, dynamic> json) {
    return FeeResponse(
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
