import 'package:flutter/material.dart';

class ResidentInfo extends StatefulWidget {
  final String name;
  final String dob;
  final String idNumber;
  final String age;
  final String status;
  final String room;
  final String phoneNumber;

  const ResidentInfo({
    super.key,
    required this.name,
    required this.dob,
    required this.idNumber,
    required this.age,
    required this.status,
    required this.room,
    required this.phoneNumber,
  });

  @override
  State<ResidentInfo> createState() => _ResidentInfoState();
}

class _ResidentInfoState extends State<ResidentInfo> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(
        child: Text(
          'Information',
          style: TextStyle(fontSize: 36, fontWeight: FontWeight.w500, color: Colors.blue),
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Name:', widget.name),
            _buildInfoRow('Date of Birth:', widget.dob),
            _buildInfoRow('ID Number:', widget.idNumber),
            _buildInfoRow('Age:', widget.age),
            _buildInfoRow('Status:', widget.status),
            _buildInfoRow('Room:', widget.room),
            _buildInfoRow('Phone:', widget.phoneNumber),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Center(
            child: Text("OK", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue)),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black54),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}
