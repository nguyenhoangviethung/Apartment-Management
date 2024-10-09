import 'package:flutter/material.dart';
import 'package:frontend/View/Home/home_page.dart';

import '../login.dart';

void showinform(BuildContext context,String title, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
              if (title == "Registration Successful") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              }
              if (title == "Login Successful") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              }
            },
          ),
        ],
      );
    },
  );
}