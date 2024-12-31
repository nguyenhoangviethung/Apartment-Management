class RoomInfo {
  String? apartment_number;
  String? apartment_name;
  int? area;
  String? status;
  String? owner;
  int? num_residents;
  String? phone_number;

  RoomInfo({
    required this.apartment_number,
    required this.apartment_name,
    required this.area,
    required this.status,
    required this.owner,
    required this.num_residents,
    required this.phone_number,
  });

  RoomInfo.fromJson(Map<String, dynamic> json) {
    apartment_number=json['apartment_number'];
    apartment_name=json['apartment_name'];
    area = json['area']!=null? double.parse(json['area']).toInt() : null;
    status = json['status'];
    owner = json['owner'];
    num_residents = json['num_residents'];
    phone_number = json['phone_number'];
  }

  Map<String, dynamic> toJson() {
    return {
      'area': area,
      'status': status,
      'owner': owner,
      'num_residents': num_residents,
      'phone_number': phone_number,
    };
  }
}
