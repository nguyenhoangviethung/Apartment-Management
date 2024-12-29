import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/View/Authentication/login.dart';
import 'package:http/http.dart' as http;
import '../../common/show_dialog.dart';
import 'email_verification.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _email= TextEditingController();
  bool _isforgot =false;




  Future<void> _forgotpass(String email) async {
    setState(() {
      _isforgot = true;
    });

    if (email.isEmpty) {
      setState(() {
        _isforgot = false;
      });
      showinform(context, 'Email không hợp lệ', "Vui lòng điền đầy đủ tất cả các trường!");
      return;
    }

    const String url = 'https://apartment-management-kjj9.onrender.com/auth/forgot-password';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'email': email,
        },
      );

      setState(() {
        _isforgot = false;
      });

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        if (responseData.containsKey('token')) {
          final token = responseData['token'];
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          Navigator.push(context, MaterialPageRoute(builder: (context) => const EmailVerification()));
        } else {
          showinform(context, 'Lỗi', 'Không tìm thấy token trong phản hồi');
        }
      } else if (response.statusCode == 404) {
        showinform(context, 'Email không hợp lệ', 'Không có tài khoản nào được đăng ký với email đã cung cấp');
      } else {
        showinform(context, 'Lỗi', 'Đã xảy ra lỗi không mong muốn');
      }
    } catch (e) {
      setState(() {
        _isforgot = false;
      });
      showinform(context, 'Lỗi', 'Đã xảy ra lỗi: $e');
      print('Error occurred: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF6F6FA), // Màu nền của toàn bộ màn hình
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: const Text(
              'Quên Mật Khẩu',
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: Builder(
                builder: (context) {
                  return IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 30,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Login()),
                      );
                    },
                  );
                }
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Nhập Địa Chỉ Email Tại Đây',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Nhập địa chỉ email liên kết với tài khoản của bạn.',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: _email,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Builder(
                    builder: (context) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          _forgotpass(_email.text.trim());
                        },
                        child: _isforgot? const CircularProgressIndicator(color: Colors.white): const Text(
                            'Khôi phục Mật Khẩu',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                        ),
                      );
                    }
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}