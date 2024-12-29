import 'package:flutter/material.dart';

import '../View/Authentication/login.dart';


void showinform(BuildContext context,String title, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),),
        content: Text(message, style: const TextStyle(fontSize: 18),),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        actions: [
          TextButton(
            child: const Center(
                child: Text("OK", style: TextStyle(fontSize: 18),),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              if (title == "Registration Successful") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              }
            },
          ),
        ],
      );
    },
  );
}


