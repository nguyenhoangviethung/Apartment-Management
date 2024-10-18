import 'package:flutter/material.dart';
import 'package:frontend/view/home/admin_management/fee_management/common/fee_info.dart';
import 'package:frontend/view/home/admin_management/fee_management/common/fee_item.dart';

class FeeCard extends StatefulWidget {
  final FeeItem item;
  final Function(String) onDelete;

  const FeeCard({super.key, required this.item, required this.onDelete});

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
              return FeeInfo(
                name: widget.item.name,
                fee: widget.item.fee,
                id: widget.item.id,
                startDate: widget.item.startDate,
                endDate: widget.item.endDate,
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
                        Icon(Icons.monitor_heart_outlined, color: Colors.blue[500]!, size: 45),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.item.name,
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
                      widget.onDelete(widget.item.id);
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
                            widget.item.fee,
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
                            widget.item.endDate,
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
