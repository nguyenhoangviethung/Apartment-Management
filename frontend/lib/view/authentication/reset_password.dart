import 'package:flutter/material.dart';
import 'package:frontend/View/Authentication/login.dart';
import 'package:http/http.dart'as http;
import '../../common/show_dialog.dart';
import 'email_verification.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool _showpass = false;
  bool _showConfirmPass = false;
  bool _isload=false;
  final _pass =TextEditingController();
  final _confirmpass=TextEditingController();

  Future<void> resetpassword(String new_password, String confirmpass) async {
    setState(() {
      _isload = true;
    });

    if (new_password != confirmpass) {
      setState(() {
        _isload = false;
      });
      showinform(context, 'Error', 'Passwords do not match!');
      return;
    }

    if (new_password.isEmpty || confirmpass.isEmpty) {
      setState(() {
        _isload = false;
      });
      showinform(context, 'Error', 'Please fill in all the fields!');
      return;
    }

    String url = 'https://apartment-management-kjj9.onrender.com/auth/reset-password';

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $token',
        },
        body: {
          'new_password': new_password,
        },
      );

      setState(() {
        _isload = false;
      });
      print(response.statusCode);
      print('$token');
      if (response.statusCode == 200) {

        showinform(context, 'Successful', 'Password has been reset');
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));
      } else if (response.statusCode == 404) {
        showinform(context, 'Error', 'No email stored in session.');
      } else if(response.statusCode==401) {
        showinform(context, 'Error', 'Invalid or expired token');
      }else{
        showinform(context, 'Error', 'An error occurred: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isload = false;
      });

      print('Error : $e');
      showinform(context, 'Error', 'An unexpected error occurred. Please try again.');
    }
  }


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
                        controller: _pass,
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
                          controller: _confirmpass,
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
                            resetpassword(_pass.text.trim(), _confirmpass.text.trim());
                          },
                          child: _isload? CircularProgressIndicator(color: Colors.white,): const Text(
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
      _showConfirmPass=!_showConfirmPass;
    });
  }
}


