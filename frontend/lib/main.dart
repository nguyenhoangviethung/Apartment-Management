import 'package:flutter/material.dart';
import 'package:frontend/View/Authentication/login.dart';
import 'package:frontend/view/home/main_home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<bool> checkAutoLog() async {
  const String url = 'https://apartment-management-kjj9.onrender.com/auth/check-autolog';
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? tokenlogin = prefs.getString('tokenlogin');
  if (tokenlogin == null || tokenlogin.isEmpty) {
    return false;
  }
  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $tokenlogin',
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}

void main() async {
  runApp(const MaterialApp(
      home: MyApp(), debugShowCheckedModeBanner: false));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkAutoLog(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasError || snapshot.data == false) {
          return const Login();
        } else {
          return const MainHome(currentIndex: 0);
        }
      },
    );
  }
}
