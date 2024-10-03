import 'package:flutter/material.dart';


class ForgetPasword extends StatefulWidget {
  const ForgetPasword({super.key});

  @override
  State<ForgetPasword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPasword> {
  bool _showpass = false;
  var _username= TextEditingController();
  var _email= TextEditingController();
  var _password= TextEditingController();
  var _confirmpass= TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          resizeToAvoidBottomInset: false,
          body: GestureDetector(
              onTap: () {
              FocusScope.of(context).unfocus(); // Ẩn bàn phím khi nhấn ra ngoài
          },
          child:Stack(
            children: [
              Image.asset(
                'assets/images/background.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 220), // Khoảng cách phía trên

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row (
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/images/reset-password.png',
                            color: const Color.fromRGBO(240, 245, 255, 1),
                            colorBlendMode: BlendMode.modulate,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          const Text(
                            'Forgot Password?',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 40),
                          ),
                        ]
                      ),
                    ),

                    const SizedBox(height: 30),

                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: TextFormField(
                        controller: _email,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        // obscureText: !_showpass,
                        decoration: const InputDecoration(
                          labelText: 'Email', // Dòng chữ chỉ dẫn nổi lên
                          floatingLabelBehavior: FloatingLabelBehavior.auto, // Hiệu ứng nổi
                          border: OutlineInputBorder(), // Viền cho ô
                        ),
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
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
                            decoration: const InputDecoration(
                              labelText: 'New password', // Dòng chữ chỉ dẫn nổi lên
                              labelStyle: TextStyle(color: Colors.black54, fontSize: 15),
                              border: OutlineInputBorder(), // Viền cho ô
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20.0), // Di chuyển icon sang trái
                            child: GestureDetector(
                              onTap: showornot,
                              child: Icon(
                                _showpass ? Icons.visibility : Icons.visibility_off,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          TextFormField(
                            controller: _confirmpass,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            obscureText: !_showpass,
                            decoration: const InputDecoration(
                              labelText: 'Confirm password', // Dòng chữ chỉ dẫn nổi lên
                              labelStyle: TextStyle(color: Colors.black54, fontSize: 15),
                              border: OutlineInputBorder(), // Viền cho ô
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20.0), // Di chuyển icon sang trái
                            child: GestureDetector(
                              onTap: showornot,
                              child: Icon(
                                _showpass ? Icons.visibility : Icons.visibility_off,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Builder(builder: (context) {
                      return Container(
                        margin: const EdgeInsets.only(top: 30),
                        // width: 200,
                        child: TextButton(
                            onPressed: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => Login()));
                              register(_username.text, _email.text, _password.text, _confirmpass.text);
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.grey,
                              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                            ),
                            child: const Text(
                              'Reset Password',
                              style: TextStyle(color: Colors.black, fontSize: 30),
                            )),
                      );
                    })
                  ],
                ),
              ),
            ],
          )),
      ),
    );
  }
  void register(user,email, password, confirmpass){



  }

  void showornot() {
    setState(() {
      _showpass = !_showpass;
    });
  }
}
