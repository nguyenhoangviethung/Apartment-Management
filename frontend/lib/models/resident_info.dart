class ResidentInfo{
  String ?full_name;
  String ?date_of_birth;
  String ?id_number;
  int ?age;
  int ?room;
  String ?phone_number;
  String ?status;
  int ? res_id;

  ResidentInfo(
      {required this.full_name,
      required this.date_of_birth,
      required this.id_number,
      required this.age,
      required this.room,
      required this.phone_number,
      required this.status,
      required this.res_id});

  ResidentInfo.forApi({
    required this.full_name,
    required this.date_of_birth,
    required this.id_number,
    required this.room,
    required this.phone_number,
    required this.status,
  }) : age = null;

  ResidentInfo.fromJson(Map<String,dynamic> json){
    full_name=json['full_name'];
    date_of_birth=json['date_of_birth'];
    id_number=json['id_number'];
    age=json['age'];
    room=json['room'];
    phone_number=json['phone_number'];
    status=json['status'];
    res_id=json['res_id'];
  }
  Map<String,dynamic> toJson(){
    return{
      'full_name':full_name,
      'date_of_birth':date_of_birth,
      'id_number':id_number,
      'room':room,
      'phone_number':phone_number,
      'status':status,
    };
  }
}
