class RoomInfo{
  int ?id;
  int ?area;
  String ?status;
  String ?owner;
  int ?num_residents;
  String ?phone_number;

  RoomInfo(
      { required this.id,
        required this.area,
        required this.status,
        required this.owner,
        required this.num_residents,
        required this.phone_number
        });

  RoomInfo.fromJson(Map<String,dynamic> json){
    area=json['full_name'];
    status=json['date_of_birth'];
    owner=json['id_number'];
    num_residents=json['age'];
    phone_number=json['room'];
  }
}
