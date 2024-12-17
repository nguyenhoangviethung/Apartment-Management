class AccountInfo{
  String ?phone_number;
  String ?user_email;
  int ?user_id;
  String ?user_role;
  String ?username;

  AccountInfo(this.phone_number, this.user_email, this.user_id, this.user_role,
      this.username);

  AccountInfo.fromJson(Map<String,dynamic> json){
    phone_number=json['phone_number'];
    user_email=json['user_email'];
    user_id=json['user_id'];
    user_role=json['user_role'];
    username=json['username'];
  }
}
