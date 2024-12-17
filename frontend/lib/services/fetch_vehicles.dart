import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:frontend/models/vehicle.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<Vehicle>?> fetchVehicles()async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? tokenlogin = prefs.getString('tokenlogin');
  const url='https://apartment-management-kjj9.onrender.com/admin/all_vehicles';
  try{
    final response =await http.get(Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${tokenlogin}',
        'Content-TyApe': 'application/json'
      }
    );
    print(response.body);
    if(response.statusCode==200){
      List<dynamic> vehiclejson = jsonDecode(response.body);
      return vehiclejson.map((json)=>Vehicle.fromJson(json)).toList();
    }
  }catch(e){
    print('Error');
  }
}