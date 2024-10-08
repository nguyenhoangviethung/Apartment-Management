import 'package:flutter/material.dart';
import 'package:frontend/View/Authentication/login.dart';
import 'package:frontend/View/Home/home_page.dart';
import 'package:http/http.dart' as http;

import 'emailVerification.dart';


class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _showpass = false;
  bool _showconfirmpass =false;
  bool isSingup =false;

  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmpass = TextEditingController();




  Future<void> _registerUser(String username, String email, String password, String confirmPassword) async {
    setState(() {
      isSingup = true;
    });

    if (password != confirmPassword) {
      print("Passwords do not match!");
      setState(() {
        isSingup = false;
      });
      return;
    }

    print('cwdwdhqijqi');

    final url = Uri.parse('https://apartment-management-kjj9.onrender.com/auth/register');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'username': username,
        'email': email,
        'password': password,
      },
    );

    print('ndiqdoqijsqq');

    setState(() {
      isSingup = false;
    });

    if (response.statusCode == 200) {
      print('success');
      // Chuyển hướng đến trang Login
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => Login()),
      // );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const EmailVerification(previousScreen: 'Register')),
      );
    } else if (response.statusCode == 400) {
      // Xử lý lỗi người dùng đã tồn tại nếu cần
      print('User already exists.');
    } else {
      // Xử lý lỗi chung
      print('Error: ${response.statusCode}');
    }
  }




  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            'Register',
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
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus(); // Ẩn bàn phím khi nhấn ra ngoài
          },
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Icon(Icons.account_circle, size: 50, color: Colors.grey[700]),
                    const SizedBox(height: 8),
                    const Text(
                      'Create a new account',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),
                    // Username field
                    TextFormField(
                      controller: _username,
                      decoration: InputDecoration(
                        labelText: 'USERNAME',
                        prefixIcon: Icon(Icons.person),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    // Email field
                    TextFormField(
                      controller: _email,
                      decoration: InputDecoration(
                        labelText: 'EMAIL',
                        prefixIcon: const Icon(Icons.email),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.black, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    // Password field
                    TextFormField(
                      controller: _password,
                      obscureText: !_showpass,
                      decoration: InputDecoration(
                        labelText: 'PASSWORD',
                        prefixIcon: const Icon(Icons.lock),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.black, width: 2),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showpass ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _showpass = !_showpass;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    // Confirm Password field
                    TextFormField(
                      controller: _confirmpass,
                      obscureText: !_showconfirmpass,
                      decoration: InputDecoration(
                        labelText: 'CONFIRM PASSWORD',
                        prefixIcon: const Icon(Icons.lock),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.black, width: 2),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showconfirmpass ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _showconfirmpass = !_showconfirmpass;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 55),
                    // Sign up button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        _registerUser(_username.text, _email.text, _password.text,_confirmpass.text);
                      },
                      child: isSingup? const CircularProgressIndicator(color: Colors.white,): const Text(
                        'SIGN UP',
                        style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
