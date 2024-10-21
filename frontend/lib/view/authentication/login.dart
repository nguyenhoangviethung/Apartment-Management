import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/View/Authentication/common/show_dialog.dart';
import 'package:frontend/View/Authentication/forgot_password.dart';
import 'package:frontend/View/Authentication/register.dart';
import 'package:frontend/View/Home/main_home.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _showpass=false;
  bool _islogin=false;
  final _username = TextEditingController();
  final _password = TextEditingController();

  Future<void> _login(String username, String password, bool remember) async {
    setState(() {
      _islogin = true;
    });
    if (username.isEmpty  || password.isEmpty) {
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
        var responseData=jsonDecode(response.body);
        final tokenlogin= responseData['token'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('tokenlogin', tokenlogin);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MainHome()),
        );
        showinform(context, 'Login Successful', '');
      } else if(response.statusCode==403){
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
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50),

                    Container(
                        margin: const EdgeInsets.fromLTRB(20, 50, 20, 0),
                        alignment: Alignment.center,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.asset(
                            'assets/images/login_image.jpg',
                            fit: BoxFit.cover,
                            color: const Color.fromRGBO(220, 245, 255, 1),
                            colorBlendMode: BlendMode.modulate,
                          ),
                        )
                    ),

                    // Hello, Welcome Back
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                      child: Center(
                        child: Text(
                          'Hello',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            // color: Colors.blue[700],
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 0,0, 2),
                      child: Center(
                        child: Text(
                          'Welcome Back!',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            // color: Colors.blue[700],
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
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Username',
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),

                    // Password box
                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          TextFormField(
                            controller: _password,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            obscureText: !_showpass,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: const TextStyle(color: Colors.black54, fontSize: 15),
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

                        ],
                      ),

                    ),

                    // Sign in button
                    // Sign in button
                    Container(
                      margin: const EdgeInsets.fromLTRB(50, 30, 50, 0),
                      child: Builder(
                          builder: (context) {
                            return TextButton(
                                onPressed: () {
                                  _login(_username.text, _password.text, false);
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
                                ));
                          }),
                    ),


                    // (Sign up, forgot password) row
                    Container(
                      margin: const EdgeInsets.fromLTRB(30, 40, 30, 0),
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
                                      ),
                                    ),
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) =>const Register() ));
                                    }
                                );
                              }
                          ),
                          Builder(
                              builder: (context) {
                                return GestureDetector(
                                  child: const Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  onTap: (){
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const ForgotPassword()));
                                  },
                                );
                              }
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          )
      ),
    );
  }

  void showornot(){
    setState(() {
      _showpass=!_showpass;
    });
  }
}