import 'package:flutter/material.dart';

class ResidentCard extends StatefulWidget {
  final String text;
  final double width;
  final double height;

  const ResidentCard({
    super.key,
    required this.text,
    this.width = double.infinity, // Mặc định chiều rộng là vô tận
    this.height = 30, // Chiều cao mặc định
  });

  @override
  State<ResidentCard> createState() => _ResidentCardState();
}

class _ResidentCardState extends State<ResidentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Center(
          child: Text(
            widget.text,
            style: const TextStyle(fontSize: 20, color: Colors.blue),
          ),
        ),
      ),
    );
  }
}