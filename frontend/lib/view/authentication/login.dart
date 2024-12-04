import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/View/Authentication/forgot_password.dart';
import 'package:frontend/View/Authentication/register.dart';
import 'package:frontend/View/Home/main_home.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/show_dialog.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _showpass = false;
  bool _islogin = false;
  final _username = TextEditingController();
  final _password = TextEditingController();

  Future<void> _login(String username, String password, bool remember) async {
    setState(() {
      _islogin = true;
    });
    if (username.isEmpty || password.isEmpty) {
      showinform(context, "Registration Failed", "Please fill in all the fields!");
      setState(() {
        _islogin = false;
      });
      return;
    }
    try {
      final url = Uri.parse('https://apartment-management-kjj9.onrender.com/auth/login');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'username': username,
          'password': password,
          'remember': remember.toString(),
        },
      );

      setState(() {
        _islogin = false;
      });

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        final tokenlogin = responseData['token'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('tokenlogin', tokenlogin);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MainHome()),
        );
        showinform(context, 'Login Successful', '');
      } else if (response.statusCode == 403) {
        showinform(context, 'Login Failed', 'Incorrect Details');
      }
    } catch (error) {
      print('Error occurred: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // Ẩn bàn phím khi nhấn ra ngoài
        },
        child: Stack(
          children: [
            // Hình nền
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/login_backgound.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Nội dung của giao diện đăng nhập
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.65),  // Thêm độ mờ
              ),
            ),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 250),
                  // Hello, Welcome Back
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                    child: Center(
                      child: Text(
                        'Hello',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 20),
                    child: Center(
                      child: Text(
                        'Welcome Back!',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: Colors.white, // Đổi màu chữ
                        ),
                      ),
                    ),
                  ),
                  // Username box
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: TextFormField(
                      controller: _username,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Username', // Sử dụng hint text
                        hintStyle: const TextStyle(color: Colors.black54, fontSize: 18), // Màu cho hint text
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(Icons.person, color: Colors.black54),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  // Password box
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        TextFormField(
                          controller: _password,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                          obscureText: !_showpass,
                          decoration: InputDecoration(
                            hintText: 'Password', // Sử dụng hint text
                            hintStyle: const TextStyle(color: Colors.black54, fontSize: 18), // Màu cho hint text
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.white, // Màu nền ô nhập
                            prefixIcon: const Icon(Icons.lock, color: Colors.black54), // Thêm biểu tượng khóa
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: GestureDetector(
                            onTap: showornot,
                            child: Icon(
                              _showpass ? Icons.visibility : Icons.visibility_off,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Sign in button
                  Container(
                    margin: const EdgeInsets.fromLTRB(50, 30, 50, 0),
                    child: Builder(
                      builder: (context) {
                        return TextButton(
                          onPressed: () {
                            _login(_username.text.trim(), _password.text.trim(), false);
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          child: Center(
                            child: _islogin
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text(
                              'Login',
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // (Sign up, forgot password) row
                  Container(
                    margin: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Builder(
                          builder: (context) {
                            return GestureDetector(
                              child: const Text(
                                'Sign up?',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white, // Đổi màu chữ
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const Register()),
                                );
                              },
                            );
                          },
                        ),
                        Builder(
                          builder: (context) {
                            return GestureDetector(
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white, // Đổi màu chữ
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => const ForgotPassword()),
                                );
                              },
                            );
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showornot() {
    setState(() {
      _showpass = !_showpass;
    });
  }
}