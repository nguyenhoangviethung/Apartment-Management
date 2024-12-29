import 'package:flutter/material.dart';
import 'package:frontend/View/Authentication/login.dart';
import 'package:http/http.dart' as http;

import '../../common/show_dialog.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _showpass = false;
  bool _showconfirmpass = false;
  bool isSingup = false;

  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmpass = TextEditingController();

  Future<void> _registerUser(String username, String email, String password, String confirmPassword) async {
    setState(() {
      isSingup = true;
    });

    if (username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      showinform(context,"Đăng ký thất bại", "Vui lòng điền đầy đủ tất cả các trường!");
      setState(() {
        isSingup = false;
      });
      return;
    }

    if (password != confirmPassword) {
      showinform(context,"Đăng ký thất bại", "Mật khẩu không khớp!");
      setState(() {
        isSingup = false;
      });
      return;
    }

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

    setState(() {
      isSingup = false;
    });

    if (response.statusCode == 200) {
      showinform(context,"Đăng ký thành công", "Kiểm tra email để xác thực tài khoản của bạn");
    } else if (response.statusCode == 400) {
      showinform(context,"Đăng ký thất bại", "Người dùng đã tồn tại.");
    } else {
      showinform(context,"Đăng ký thất bại", "Lỗi: ${response.statusCode}");
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
            'Đăng ký',
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: Builder(builder: (context) {
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
          }),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Icon(Icons.account_circle, size: 50, color: Colors.grey[700]),
                    const SizedBox(height: 8),
                    const Text(
                      'Tạo tài khoản mới',
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
                        prefixIcon: const Icon(Icons.person),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.black, width: 2),
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
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        _registerUser(
                          _username.text.trim(),
                          _email.text.trim(),
                          _password.text.trim(),
                          _confirmpass.text.trim(),
                        );
                      },
                      child: isSingup
                          ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                          : const Text(
                        'ĐĂNG KÝ',
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
