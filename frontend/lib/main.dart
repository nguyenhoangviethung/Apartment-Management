import 'package:flutter/material.dart';
import 'package:frontend/View/Authentication/login.dart';
import 'package:frontend/View/Home/management/management.dart';
import 'package:frontend/view/home/account/account.dart';
import 'package:frontend/view/home/main_home.dart';
import 'package:frontend/view/home/user/user.dart';
import 'package:frontend/view/home/management/management.dart';

void main() {

  // runApp(
  //     const MaterialApp(
  //       debugShowCheckedModeBanner: false,
  //       home: Login(),
  //
  //     ));
    runApp( MainHome(currentIndex: 0,));

}


