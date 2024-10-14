import 'package:flutter/material.dart';
import 'package:frontend/view/home/admin_management/residents_management/common/resident_info.dart';

class ResidentCard extends StatefulWidget {
  final String name;
  final String dob;
  final String idNumber;
  final String age;
  final String status;
  final String room;
  final String phoneNumber;

  const ResidentCard({
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
  State<ResidentCard> createState() => _ResidentCardState();
}

class _ResidentCardState extends State<ResidentCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return ResidentInfo(name: widget.name, dob: widget.dob, idNumber: widget.idNumber,
                  age: widget.age, status: widget.status, room: widget.room, phoneNumber: widget.phoneNumber);
            }
        );
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.person_pin_outlined, color: Colors.blue[500]!, size: 45,), // Biểu tượng 1
                  const SizedBox(width: 8), // Khoảng cách giữa icon và text
                  Text(
                    widget.name,
                    style: const TextStyle(fontSize: 24, color: Colors.black87, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    Expanded(
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

                    Expanded(
                      child: Row(
                        children: [
                          Icon(Icons.call_outlined, color: Colors.grey[600]!, size: 25,), // Biểu tượng 3
                          const SizedBox(width: 10),
                          Text(
                            widget.phoneNumber,
                            style: const TextStyle(fontSize: 17, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}