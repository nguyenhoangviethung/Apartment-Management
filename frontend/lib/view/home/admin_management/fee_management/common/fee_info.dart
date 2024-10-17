import 'package:flutter/material.dart';

class FeeInfo extends StatefulWidget {
  final String name;
  final String fee;
  final String id;
  final String startDate;
  final String endDate;

  const FeeInfo({
    super.key,
    required this.name,
    required this.fee,
    required this.id,
    required this.startDate,
    required this.endDate,
  });

  @override
  State<FeeInfo> createState() => _FeeInfoState();
}

class _FeeInfoState extends State<FeeInfo> {
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
            _buildInfoRow('Date of Birth:', widget.fee),
            _buildInfoRow('ID Number:', widget.id),
            _buildInfoRow('Age:', widget.startDate),
            _buildInfoRow('Status:', widget.endDate),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Center(
            child: Text("Merci bucu", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue)),
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
