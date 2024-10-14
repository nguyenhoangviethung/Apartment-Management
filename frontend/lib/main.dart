import 'package:flutter/material.dart';
import 'package:frontend/View/Authentication/forgot_password.dart';
import 'package:frontend/View/Authentication/login.dart';
import 'package:frontend/View/Authentication/register.dart';
import 'package:frontend/view/home/admin_management/residents_management/add_residents/add_residents.dart';
import 'package:frontend/view/home/admin_management/residents_management/residents_management.dart';

void main() {
   //runApp(const Register());
  // runApp(
  //     const MaterialApp(
  //       debugShowCheckedModeBanner: false,
  //       home: Login(),
  //     )
  // );
  //  runApp(const ForgotPassword());
  //  runApp(const ResidentsManagement());
   runApp(
       const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: ResidentsManagement(),
       )
   );
  //  runApp(const AddResidents());
}
