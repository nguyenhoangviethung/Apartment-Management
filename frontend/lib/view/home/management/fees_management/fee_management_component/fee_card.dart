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
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.w500, color: Colors.blue),
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
                    Expanded(
                      child: Row(
                        children: [
                          Icon(Icons.description, color: Colors.grey[600]!, size: 25,), // Biểu tượng 2
                          const SizedBox(width: 10),
                          Text(
                            widget.feeResponse.description!.join(', '),
                            style: const TextStyle(fontSize: 17, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Row(
                        children: [
                          Icon(Icons.money, color: Colors.grey[600]!, size: 25,), // Biểu tượng 3
                          const SizedBox(width: 10),
                          Text(
                            widget.item.fee!,
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
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: label,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
            ),
            TextSpan(
              text: ' $value',
              style: const TextStyle(color: Colors.black, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}