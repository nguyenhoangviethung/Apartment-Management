class FeeResponse {
  List<String>? description;
  List<FeeInfo>? fees;

  FeeResponse({this.description, this.fees});

  factory FeeResponse.fromJson(Map<String, dynamic> json) {
    return FeeResponse(
      description: json['infor']['description'] != null
          ? List<String>.from(json['infor']['description'])
          : null,
      fees: json['infor']['detail'] != null
          ? (json['infor']['detail'] as List)
          .map((fee) => FeeInfo.fromJson(fee))
          .toList()
          : null,
    );
  }
}

class FeeInfo {
  String? room;
  String? fee;
  int? fee_id;
  String? household_name;

  FeeInfo({this.room, this.fee, this.fee_id, this.household_name});

  factory FeeInfo.fromJson(Map<String, dynamic> json) {
    return FeeInfo(
      room: json['room'] as String?,
      fee: json['fee'] as String?,
      fee_id: json['fee_id'],
        household_name: json['household_name']
    );
  }
}
