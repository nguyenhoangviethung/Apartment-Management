class ResidentInfo{
  String ?full_name;
  String ?date_of_birth;
  String ?id_number;
  int ?age;
  int ?room;
  String ?phone_number;
  String ?status;

  ResidentInfo(
      {required this.full_name,
      required this.date_of_birth,
      required this.id_number,
      required this.age,
      required this.room,
      required this.phone_number,
      required this.status});

  ResidentInfo.fromJson(Map<String,dynamic> json){
    full_name=json['full_name'];
    date_of_birth=json['date_of_birth'];
    id_number=json['id_number'];
    age=json['age'];
    room=json['room'];
    phone_number=json['phone_number'];
    status=json['status'];
  }
}
