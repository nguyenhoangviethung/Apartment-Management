import 'dart:convert';
import 'package:frontend/models/account_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<List<AccountInfo>> fetchAccounts() async{
  const url= 'https://apartment-management-kjj9.onrender.com/admin/all-users';
  try{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? tokenlogin=prefs.getString('tokenlogin');
    Map<String, String> headers = {
      'Authorization': 'Bearer $tokenlogin',
      'Content-Type': 'application/json',
    };
    final response= await http.get(Uri.parse(url), headers: headers);
    if(response.statusCode==200){
      List<dynamic> accountsjson=json.decode(response.body)['resident_info'];
      return accountsjson.map((json) => AccountInfo.fromJson(json)).toList();
    }else if(response.statusCode==500){
      print('Server error');
    }
  }catch(e){
    print('Error: $e');
  }
  return [];
}

