class ContributionFeeInfo {
  String? amount;
  int? room;

  ContributionFeeInfo({this.amount, this.room});

  factory ContributionFeeInfo.fromJson(Map<String, dynamic> json) {
    return ContributionFeeInfo(
      amount: json['amount'] as String?,
      room: json['room'] as int?,
    );
  }
}

class ContributionFeeResponse {
  String? description;
  List<ContributionFeeInfo>? detail;

  ContributionFeeResponse({this.description, this.detail});

  factory ContributionFeeResponse.fromJson(Map<String, dynamic> json) {
    return ContributionFeeResponse(
      description: json['description'] as String?,
      detail: json['detail'] != null
          ? (json['detail'] as List)
          .map((fee) => ContributionFeeInfo.fromJson(fee))
          .toList()
          : null,
    );
  }
}
