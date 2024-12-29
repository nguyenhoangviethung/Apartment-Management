import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;
import '../models/fee_required_info.dart';

Future<FeeResponse?> fetchRequiredFees() async {
  const url = 'https://apartment-management-kjj9.onrender.com/admin/fees'; // Thay URL bằng URL thật của API
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tokenlogin = prefs.getString('tokenlogin');
    print(tokenlogin);
    Map<String, String> headers = {
      'Authorization': 'Bearer $tokenlogin',
      'Content-Type': 'application/json',
    };

    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      print('Success');
      print('Response body: ${response.body}'); // In ra dữ liệu JSON từ server

      // Giải mã JSON và trả về FeeResponse
      return FeeResponse.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 400) {
      print('Server error');
    }
  } catch (e) {
    print('Error: $e');
  }
  return null;
}
