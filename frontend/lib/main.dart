import 'package:flutter/material.dart';
import 'package:frontend/View/Authentication/forgot_password.dart';
import 'package:frontend/View/Authentication/login.dart';
import 'package:frontend/View/Authentication/register.dart';
import 'package:frontend/view/home/main_home.dart';

void main() {

  runApp(
      const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MainHome(),
      )
  );
}
