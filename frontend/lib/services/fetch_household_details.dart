import 'dart:convert';

import 'package:frontend/models/detailed_inroom_residents.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<HouseholdResponse?> fetchHouseholdDetail(int household) async {
  final String url = 'https://apartment-management-kjj9.onrender.com/admin/$household/residents';
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tokenlogin = prefs.getString('tokenlogin');
    Map<String,String> header = {
      'Authorization': 'Bearer $tokenlogin',
      'Content-Type': 'application/json',
    };
    final response = await http.get(
        Uri.parse(url),
        headers: header
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return HouseholdResponse.fromJson(jsonResponse);
    } else{
      throw Exception(response.statusCode);
    }
  } catch (e) {
    print('Error: $e');
    return null;
  }
}