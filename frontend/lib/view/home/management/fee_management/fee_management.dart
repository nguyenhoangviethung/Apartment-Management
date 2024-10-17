import 'package:flutter/material.dart';

class FeeManagement extends StatelessWidget {
  const FeeManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fee Management',
          style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.lightBlue,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),

      ),
      body: const Center(
        child: Text('Fee Management Screen'),
      ),
    );
  }
}