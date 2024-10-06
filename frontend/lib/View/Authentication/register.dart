import 'package:flutter/material.dart';
import 'package:frontend/View/Authentication/login.dart';



class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _showpass = false;
  bool _showconfirmpass =false;

  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmpass = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus(); // Ẩn bàn phím khi nhấn ra ngoài
          },
          child: Stack(
            children: [
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(Icons.account_circle, size: 50, color: Colors.grey[700]),
                      const SizedBox(height: 8),
                      const Text(
                        'Register',
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
                        onPressed: () {},
                        child: const Text(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
