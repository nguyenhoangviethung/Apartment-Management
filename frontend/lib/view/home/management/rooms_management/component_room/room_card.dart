
import 'package:flutter/material.dart';
import 'package:frontend/models/room_info.dart';
import 'edit_footer.dart';
class RoomCard extends StatefulWidget {
  final RoomInfo item;
  final Function(int, int, String) onEdit;

  const RoomCard({super.key, required this.item, required this.onEdit,});

  @override
  State<RoomCard> createState() => _RoomCardState();
}

class _RoomCardState extends State<RoomCard> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context){
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
                      _buildInfoRow('Room:', widget.item.apartment_number!),
                      _buildInfoRow('Area:', widget.item.area.toString()),
                      _buildInfoRow('Status:', widget.item.status!),
                      _buildInfoRow('Owner:', widget.item.owner!),
                      _buildInfoRow('Number of residents:', widget.item.num_residents.toString()),
                      _buildInfoRow('Phone number:', widget.item.phone_number!),
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
                      Icon(Icons.home_outlined, color: Colors.blue[500]!, size: 45,),
                      const SizedBox(width: 8),
                      Text(
                        widget.item.apartment_number!,
                        style: const TextStyle(fontSize: 24, color: Colors.black87, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),

                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return EditFooter(
                              id: int.parse(widget.item.apartment_number!),
                              editRoomInfo: (id, newNumResidents, newPhoneNumber) {
                                widget.onEdit(id, newNumResidents, newPhoneNumber);
                              },
                            );
                          }
                      );
                    },
                    child: const Icon (
                      Icons.edit_calendar_outlined,
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
                          Icon(Icons.info_outline, color: Colors.grey[600]!, size: 25,), // Biểu tượng 2
                          const SizedBox(width: 10),
                          Text(
                            widget.item.status!,
                            style: const TextStyle(fontSize: 17, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Row(
                        children: [
                          Icon(Icons.area_chart_outlined, color: Colors.grey[600]!, size: 25,), // Biểu tượng 3
                          const SizedBox(width: 10),
                          Text(
                            widget.item.area.toString(),
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
