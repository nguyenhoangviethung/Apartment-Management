class HouseholdResponse {
  Resident? owner;
  List<Resident>? residents;

  HouseholdResponse({this.owner, this.residents});

  factory HouseholdResponse.fromJson(Map<String, dynamic> json) {
    return HouseholdResponse(
      owner: json['owner'] != null ? Resident.fromJson(json['owner']) : null,
      residents: json['info'] != null
          ? (json['info'] as List)
          .map((resident) => Resident.fromJson(resident))
          .toList()
          : null,
    );
  }
}
class Resident {
  int? residentId;
  String? residentName;
  String? dateOfBirth;
  String? idNumber;
  String? phoneNumber;
  String? status;

  Resident(
      {this.residentId,
        this.residentName,
        this.dateOfBirth,
        this.idNumber,
        this.phoneNumber,
        this.status});

  factory Resident.fromJson(Map<String, dynamic> json) {
    return Resident(
      residentId: json['resident_id'],
      residentName: json['resident_name'],
      dateOfBirth: json['date_of_birth'],
      idNumber: json['id_number'],
      phoneNumber: json['phone_number'],
      status: json['status'],
    );
  }
}
