import 'package:flutter/material.dart';
import 'package:frontend/view/home/admin_management/residents_management/common/resident_info.dart';
import 'package:frontend/view/home/admin_management/residents_management/common/resident_items.dart';
class ResidentCard extends StatefulWidget {
  final ResidentItems item;
  final Function(String) onDelete; // Thêm tham số callback

  const ResidentCard({super.key, required this.item, required this.onDelete});

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
              return ResidentInfo(name: widget.item.name, dob: widget.item.dob, idNumber: widget.item.idNumber,
                  age: widget.item.age, status: widget.item.status, room: widget.item.room, phoneNumber: widget.item.phoneNumber);
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.person_pin_outlined, color: Colors.blue[500]!, size: 45,),
                      const SizedBox(width: 8),
                      Text(
                        widget.item.name,
                        style: const TextStyle(fontSize: 24, color: Colors.black87, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),

                  GestureDetector(
                    onTap: () {
                      print("Icon Delete pressed");
                      widget.onDelete(widget.item.idNumber);
                    },
                    child: const Icon (
                      Icons.delete,
                      size: 30,
                      color: Color.fromRGBO(0, 0, 0, 0.6),
                    ),
                  )
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
                            widget.item.room,
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
                            widget.item.phoneNumber,
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