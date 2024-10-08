import 'package:flutter/material.dart';
import 'package:frontend/View/Authentication/login.dart';
import 'package:http/http.dart' as http;
import 'emailVerification.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _email= TextEditingController();
  bool _isforgot =false;


  Future<void> _forgotpass(String email) async {
    const String url = 'https://your-api-url.com/forgot_password';  // Thay bằng URL thực tế

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

      if (response.statusCode == 200) {
        // Xử lý khi email khôi phục mật khẩu đã được gửi
        print('Password reset email sent');
        Navigator.push(context, MaterialPageRoute(builder: (context)=>EmailVerification()));
        // Ví dụ: Thông báo cho người dùng
      } else if (response.statusCode == 404) {
        // Xử lý khi không có tài khoản với email đã cung cấp
        print('No account registered with the provided email');
      } else {
        // Xử lý lỗi khác
        print('Unexpected error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFF6F6FA), // Màu nền của toàn bộ màn hình
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            'Forgot Password',
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
                'Mail Address Here',
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
                'Enter the email address associated with your account.',
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
                        _forgotpass(_email.text);
                      },
                      child: _isforgot? const CircularProgressIndicator(color: Colors.white): const Text(
                          'Recover Password',
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
    );
  }
}