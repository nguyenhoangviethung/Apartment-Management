import 'package:flutter/material.dart';
import 'package:frontend/models/fee_required_info.dart';

class FeeCard extends StatefulWidget {
  final FeeResponse feeResponse;
  final FeeInfo item;

  const FeeCard({super.key, required this.item, required this.feeResponse});

  @override
  State<FeeCard> createState() => _FeeCardState();
}

class _FeeCardState extends State<FeeCard> {
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
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow('Description:',widget.feeResponse.description?.join(', ') ?? 'N/A'),
                      _buildInfoRow('Room id:', widget.item.room ?? 'N/A'),
                      _buildInfoRow('Fee:', widget.item.fee ?? 'N/A'),
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
                            widget.item.room ?? 'Unknown room',
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.black),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          Icon(Icons.description, color: Colors.grey[600]!, size: 25),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              widget.feeResponse.description!.join(', '),
                              style: const TextStyle(fontSize: 17, color: Colors.black87),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Row(
                        children: [
                          Icon(Icons.money, color: Colors.grey[600]!, size: 25),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              widget.item.fee!,
                              style: const TextStyle(fontSize: 17, color: Colors.black87),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
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
      padding: const EdgeInsets.symmetric(vertical: 8.0), // Tăng khoảng cách giữa các hàng
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2, // Tăng kích thước cho nhãn
            child: Text(
              label,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ),
          Expanded(
            flex: 3, // Tăng kích thước cho giá trị
            child: Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.normal, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}
