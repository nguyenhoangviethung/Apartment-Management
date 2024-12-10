class ContributionFeeInfo {
  String? contributionFee;
  String? room;

  ContributionFeeInfo({this.contributionFee, this.room});

  factory ContributionFeeInfo.fromJson(Map<String, dynamic> json) {
    return ContributionFeeInfo(
      contributionFee: json['contribution fee'] as String?,
      room: json['room'] as String?,
    );
  }
}

class ContributionFeeResponse {
  List<String>? description;
  List<ContributionFeeInfo>? fees;

  ContributionFeeResponse({this.description, this.fees});

  factory ContributionFeeResponse.fromJson(Map<String, dynamic> json) {
    return ContributionFeeResponse(
      description: json['infor']['description'] != null
          ? List<String>.from(json['infor']['description'])
          : null,
      fees: json['infor']['detail'] != null
          ? (json['infor']['detail'] as List)
          .map((fee) => ContributionFeeInfo.fromJson(fee))
          .toList()
          : null,
    );
  }
}