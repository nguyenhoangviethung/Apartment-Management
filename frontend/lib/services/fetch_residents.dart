import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/models/resident_info.dart';
import 'package:http/http.dart' as http;

Future<List<ResidentInfo>> fetchResidents() async{
  const url= 'https://apartment-management-kjj9.onrender.com/admin/residents';
  try{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? tokenlogin=prefs.getString('tokenlogin');
    Map<String, String> headers = {
      'Authorization': 'Bearer $tokenlogin',
      'Content-Type': 'application/json',
    };
    final response= await http.get(Uri.parse(url), headers: headers);
    if(response.statusCode==200){
      List<dynamic> residentsjson=json.decode(response.body)['resident_info'];
      return residentsjson.map((json) => ResidentInfo.fromJson(json)).toList();
    }else if(response.statusCode==500){
      print('Server error');
    }
  }catch(e){
    print('Error: $e');
  }
  return [];
}

