import 'package:flutter/material.dart';
import 'package:frontend/View/Authentication/forgot_password.dart';
import 'package:frontend/View/Authentication/login.dart';
import 'package:frontend/View/Authentication/register.dart';

void main() {
   //runApp(const Register());
  runApp(
      const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Login(),
      )
  );
  //  runApp(const ForgotPassword());
}
