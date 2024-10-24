import 'dart:convert';
import 'package:frontend/models/room_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<List<RoomInfo>> fetchRooms() async{
  const url= 'https://apartment-management-kjj9.onrender.com/admin/house';
  try{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? tokenlogin=prefs.getString('tokenlogin');
    Map<String, String> headers = {
      'Authorization': 'Bearer $tokenlogin',
      'Content-Type': 'application/json',
    };
    final response= await http.get(Uri.parse(url), headers: headers);
    if(response.statusCode==200){
      print('Success');
      print('Response body: ${response.body}'); // In ra dữ liệu JSON từ server
      List<dynamic> roomsjson=json.decode(response.body)['info'];
      return roomsjson.map((json) => RoomInfo.fromJson(json)).toList();
    }else if(response.statusCode==500){
      print('Server error');
    }
  }catch(e){
    print('Error: $e');
  }
  return [];
}

