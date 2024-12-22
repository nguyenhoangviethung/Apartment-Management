import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_fee.dart';
Future<UserFee?> fetchUserFee (String endPoint)async{
  final url = 'https://apartment-management-kjj9.onrender.com/$endPoint';
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? tokenlogin = prefs.getString('tokenlogin');
  try{
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $tokenlogin',
        'Content-Type': 'application/json'
      }
    );
    print(response.body);
    if(response.statusCode==200){
      final responseJson = jsonDecode(response.body);
      return UserFee.fromJson(responseJson);
    }
  }catch(e){
    print('Error');
  }
  return null;
}

Future<List<UserContributionFee>?> fetchUserContributionFee ()async{
  const url = 'https://apartment-management-kjj9.onrender.com/user/contributions';
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? tokenlogin = prefs.getString('tokenlogin');
  try{
    final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $tokenlogin',
          'Content-Type': 'application/json'
        }
    );
    print(response.body);
    if(response.statusCode==200){
      List<dynamic> responseJson = jsonDecode(response.body);
      return responseJson.map((json)=>UserContributionFee.fromJson(json)).toList();
    }
  }catch(e){
    print('Error');
  }
  return [];
}
