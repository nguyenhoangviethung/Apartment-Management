import 'dart:convert';

import 'package:frontend/models/not-paid_room_info.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
Future<List<NotPaidRoomInfo>> fetchNotPaid()async{
  const String url='https://apartment-management-kjj9.onrender.com/admin/not-pay';
  try{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? tokenlogin= prefs.getString('tokenlogin');
    Map<String,String> header={
      'Authorization':'Bearer $tokenlogin',
      'Content-Type':'application/json'
    };
    final response =await http.get(
        Uri.parse(url),
      headers: header,
    );
    print(response.statusCode);
    if (response.statusCode==200) {
      print(response.body);
      List<dynamic> notpaidrooms=jsonDecode(response.body)['infor'];
      return notpaidrooms.map((json)=>NotPaidRoomInfo.fromJson(json)).toList();
    }
  }catch(e){
    print('Error: $e');
  }
  return [];
}