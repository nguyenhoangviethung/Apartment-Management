import 'package:flutter/material.dart';

class ResidentCard extends StatefulWidget {
  final String name;
  final String room;
  final String phone;

  const ResidentCard({
    super.key,
    required this.name,
    required this.room,
    required this.phone,
  });

  @override
  State<ResidentCard> createState() => _ResidentCardState();
}

class _ResidentCardState extends State<ResidentCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.person_pin_outlined, color: Colors.blue, size: 45,), // Biểu tượng 1
                const SizedBox(width: 8), // Khoảng cách giữa icon và text
                Text(
                  widget.name,
                  style: const TextStyle(fontSize: 24, color: Colors.black87),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  Icon(Icons.home_outlined, color: Colors.grey[600]!, size: 25,), // Biểu tượng 2
                  const SizedBox(width: 10),
                  Text(
                    widget.room,
                    style: const TextStyle(fontSize: 17, color: Colors.black87),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  Icon(Icons.call_outlined, color: Colors.grey[600]!, size: 25,), // Biểu tượng 3
                  const SizedBox(width: 10),
                  Text(
                    widget.phone,
                    style: const TextStyle(fontSize: 17, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}