import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/contribution_fee_info.dart';

Future<List<ContributionFeeResponse>?> fetchContributionFees() async {
  const url = 'https://apartment-management-kjj9.onrender.com/admin/contributions';
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tokenlogin = prefs.getString('tokenlogin');
    Map<String, String> headers = {
      'Authorization': 'Bearer $tokenlogin',
      'Content-Type': 'application/json',
    };

    final response = await http.get(Uri.parse(url), headers: headers);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print('Success');
      print('Response body: ${response.body}'); // In ra dữ liệu JSON từ server
      List<dynamic> jsonResponse =jsonDecode(response.body);
      // Giải mã JSON và trả về ContributionFeeResponse
      return jsonResponse.map((info)=>ContributionFeeResponse.fromJson(info)).toList();
    } else if (response.statusCode == 400) {
      print('Server error');
    }
  } catch (e) {
    print('Error: $e');
  }
  return [];
}