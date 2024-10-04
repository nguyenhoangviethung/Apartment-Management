import 'package:flutter/material.dart';

void main() {
  runApp(const Register());
}

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _showpass = false;
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmpass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          // decoration: const BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage('assets/images/background.jpg'),
          //     fit: BoxFit.cover,
          //   ),
          // ),
          child: Stack(
            children: [
              Image.network(
                'https://i.pinimg.com/564x/c3/4c/81/c34c81e2284e9bcaa20dbc20b91152c3.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(Icons.account_circle, size: 50, color: Colors.grey[700]),
                      SizedBox(height: 8),
                      const Text(
                        'Register',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 28),
                      // Username field
                      TextFormField(
                        controller: _username,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'USERNAME',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 28),
                      // Email field
                      TextFormField(
                        controller: _email,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'EMAIL',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 28),
                      // Password field with show/hide functionality
                      TextFormField(
                        controller: _password,
                        obscureText: !_showpass,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'PASSWORD',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
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
                      SizedBox(height: 28),
                      // Confirm Password field
                      TextFormField(
                        controller: _confirmpass,
                        obscureText: !_showpass,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'CONFIRM PASSWORD',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
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
                      SizedBox(height: 55),
                      // Sign up button
                      ElevatedButton(
                        child: Text('SIGN UP',
                          style: TextStyle(fontSize: 24,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),

                          textAlign: TextAlign.center,),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[500],
                          padding: EdgeInsets.symmetric(vertical: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          // Handle sign up logic
                        },
                      ),
                    ],
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


