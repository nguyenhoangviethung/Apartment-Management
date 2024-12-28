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

  FeeInfo({this.room, this.fee, this.fee_id});

  factory FeeInfo.fromJson(Map<String, dynamic> json) {
    return FeeInfo(
      room: json['room'] as String?,
      fee: json['fee'] as String?,
      fee_id: json['fee_id']
    );
  }
}
