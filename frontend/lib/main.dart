import 'package:flutter/material.dart';
import 'package:frontend/View/Authentication/login.dart';
import 'package:frontend/view/home/main_home.dart';

void main() {

  runApp(
      // const MaterialApp(
      //   debugShowCheckedModeBanner: false,
      //   home: Login(),
      // )
    const MainHome(currentIndex: 2,)
  );
}
