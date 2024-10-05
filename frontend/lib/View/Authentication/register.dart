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
          child: Stack(
            children: [
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
                          labelText: 'USERNAME', // Label text hiển thị trên viền
                          prefixIcon: Icon(Icons.person), // Icon cho trường username
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 28),
                      // Email field
                      TextFormField(
                        controller: _email,
                        decoration: InputDecoration(
                          labelText: 'EMAIL', // Label text hiển thị trên viền
                          prefixIcon: Icon(Icons.email), // Icon cho trường email
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 28),
                      // Password field with show/hide functionality
                      TextFormField(
                        controller: _password,
                        obscureText: !_showpass,
                        decoration: InputDecoration(
                          labelText: 'PASSWORD', // Label text hiển thị trên viền
                          prefixIcon: Icon(Icons.lock), // Icon cho trường password
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
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
                          labelText: 'CONFIRM PASSWORD', // Label text hiển thị trên viền
                          prefixIcon: Icon(Icons.lock), // Icon cho trường confirm password
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
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
                        child: Text(
                          'SIGN UP',
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[500],
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
