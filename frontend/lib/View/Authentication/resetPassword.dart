import 'package:flutter/material.dart';
import 'package:frontend/View/Authentication/login.dart';

import 'emailVerification.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool _showpass = false;
  bool _showConfirmPass = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFF6F6FA),
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            'Reset Password',
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
                      MaterialPageRoute(builder: (context) => const EmailVerification()),
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
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Enter New Password',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Your new password must be different from the previously used password.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 40),
                // Trường nhập mật khẩu
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      TextFormField(
                        style: const TextStyle(fontSize: 18),
                        obscureText: !_showpass,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: const TextStyle(fontSize: 16, color: Colors.black54),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: GestureDetector(
                            onTap: showornot,
                            child: Icon(
                                _showpass? Icons.visibility:Icons.visibility_off
                            )
                        ),
                      )
                    ]
                  ),
                ),
                // Trường nhập xác nhận mật khẩu
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        TextFormField(
                          style: const TextStyle(fontSize: 18),
                          obscureText: !_showConfirmPass,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            labelStyle: const TextStyle(fontSize: 16, color: Colors.black54),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: GestureDetector(
                              onTap: showornot_confirmPass,
                              child: Icon(
                                  _showConfirmPass? Icons.visibility:Icons.visibility_off
                              )
                          ),
                        )
                      ]
                  ),
                ),
                const SizedBox(height: 40),
                // Nút Continue
                SizedBox(
                  width: double.infinity,
                  height: 50,
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const Login()),
                            );
                          },
                          child: const Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        );
                      }
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void showornot(){
    setState(() {
      _showpass=!_showpass;
    });
  }
  void showornot_confirmPass(){
    setState(() {
      _showpass=!_showpass;
    });
  }
}


