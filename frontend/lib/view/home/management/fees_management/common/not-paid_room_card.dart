import 'package:flutter/material.dart';
import 'package:frontend/models/fee_info.dart';
import 'package:frontend/models/not-paid_room_info.dart';

class NotPaidRoomCard extends StatefulWidget {
  final NotPaidRoomInfo item;
  final Function(int) onDelete;

  const NotPaidRoomCard({super.key, required this.item, required this.onDelete});

  @override
  State<NotPaidRoomCard> createState() => _NotPaidRoomCardState();
}

class _NotPaidRoomCardState extends State<NotPaidRoomCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
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
                      _buildInfoRow('Room id:', widget.item.room_id.toString()),
                      _buildInfoRow('Amount:', widget.item.amount.toString()),
                      _buildInfoRow('Due date:', widget.item.due_date!),
                      _buildInfoRow('Service fee:', widget.item.service_fee.toString()),
                      _buildInfoRow('Manage fee:', widget.item.manage_fee.toString()),
                      _buildInfoRow('Fee type:', widget.item.fee_type!),
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
            });
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
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.home_outlined, color: Colors.blue[500]!, size: 45),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.item.room_id.toString(),
                            style: const TextStyle(fontSize: 24, color: Colors.black87, fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      print("Icon Delete pressed");
                      widget.onDelete(widget.item.room_id!);
                    },
                    child: const Icon(
                      Icons.delete,
                      size: 30,
                      color: Color.fromRGBO(0, 0, 0, 0.6),
                    ),
                  )
                ],
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 11.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(Icons.monetization_on_outlined, color: Colors.grey[600]!, size: 25),
                          const SizedBox(width: 10),
                          Text(
                            widget.item.amount.toString(),
                            style: const TextStyle(fontSize: 17, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Row(
                        children: [
                          Icon(Icons.date_range_outlined, color: Colors.grey[600]!, size: 25),
                          const SizedBox(width: 10),
                          Text(
                            widget.item.due_date!,
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
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
