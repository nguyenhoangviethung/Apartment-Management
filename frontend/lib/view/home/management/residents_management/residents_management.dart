import 'package:flutter/material.dart';

class ResidentManagement extends StatelessWidget {
  const ResidentManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resident Management',
          style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.lightBlue,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: const Center(
        child: Text('Resident Management Screen'),
      ),
    );
  }
}