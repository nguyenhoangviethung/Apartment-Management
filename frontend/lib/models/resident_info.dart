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

  ResidentInfo.forApi({
    required this.full_name,
    required this.date_of_birth,
    required this.id_number,
    required this.room,
    required this.phone_number,
    required this.status,
  }) : age = null; // Không khởi tạo age

  ResidentInfo.fromJson(Map<String,dynamic> json){
    full_name=json['full_name'];
    date_of_birth=json['date_of_birth'];
    id_number=json['id_number'];
    age=json['age'];
    room=json['room'];
    phone_number=json['phone_number'];
    status=json['status'];
  }
  Map<String,dynamic> toJson(){
    return{
      'full_name':full_name,
      'date_of_birth':date_of_birth,
      'id_number':id_number,
      'room':room,
      'phone_number':phone_number,
      'status':status
    };
  }
}
