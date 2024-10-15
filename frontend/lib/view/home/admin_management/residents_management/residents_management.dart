import 'package:flutter/material.dart';

class ResidentManagementScreen extends StatelessWidget {
  const ResidentManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resident Management'),
      ),
      body: const Center(
        child: Text('Resident Management Screen'),
      ),
    );
  }
}

class FeeScreen extends StatelessWidget {
  const FeeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fee'),
      ),
      body: const Center(
        child: Text('Fee Screen'),
      ),
    );
  }
}
