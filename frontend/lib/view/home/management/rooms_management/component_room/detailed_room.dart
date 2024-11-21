import 'package:flutter/material.dart';
import 'package:frontend/models/detailed_inroom_residents.dart';
import 'package:frontend/models/room_info.dart';
import 'package:frontend/services/fetch_household_details.dart';
import 'package:frontend/view/home/management/rooms_management/rooms_management.dart';

class DetailedRoom extends StatefulWidget {
  const DetailedRoom({super.key, required this.detailedroom});

  final RoomInfo detailedroom;

  @override
  State<DetailedRoom> createState() => _DetailedRoomState();
}

class _DetailedRoomState extends State<DetailedRoom> {
  HouseholdResponse? householdDetail;
  bool isLoading = true;
  String? errorMessage;

  Future<void> handleHouseholdDetail() async {
    try {
      final householdId = widget.detailedroom.apartment_number;
      final res = await fetchHouseholdDetail(int.parse(householdId!));
      setState(() {
        householdDetail = res;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    handleHouseholdDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RoomsManagement(),
              ),
            );
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
        ),
        title: const Text(
          'Detailed Member Information',
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(fontSize: 20, color: Colors.red),
                  ),
                ) // Hiển thị lỗi
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        _buildInfoRow(
                            'Room:', widget.detailedroom.apartment_number!),
                        _buildInfoRow(
                            'Area:', widget.detailedroom.area.toString()),
                        _buildInfoRow('Status:', widget.detailedroom.status!),
                        _buildInfoRow(
                            'Owner:', widget.detailedroom.owner ?? 'null'),
                        _buildInfoRow('Number of residents:',
                            widget.detailedroom.num_residents.toString()),
                        _buildInfoRow('Phone number:',
                            widget.detailedroom.phone_number ?? 'null'),
                        const SizedBox(height: 20),
                        ..._buildResidentsList(),
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
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54),
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

  List<Widget> _buildResidentsList() {
    if (householdDetail == null) {
      return [
        const Text(
          "Household information not found.",
          style: TextStyle(fontSize: 20, color: Colors.black54),
        ),
      ];
    }
    const OwnerTitle = Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        "Owner:",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
    final ownerWidget = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Name: ${householdDetail!.owner?.residentName ?? 'Unknown'}",
            style: const TextStyle(fontSize: 20),
          ),
          Text(
            "Date of birth: ${householdDetail!.owner?.dateOfBirth ?? 'Unknown'}",
            style: const TextStyle(fontSize: 20),
          ),
          Text(
            "ID Number: ${householdDetail!.owner?.idNumber ?? 'Unknown'}",
            style: const TextStyle(fontSize: 20),
          ),
          Text(
            "Phone: ${householdDetail!.owner?.phoneNumber ?? 'Unknown'}",
            style: const TextStyle(fontSize: 20),
          ),
          Text(
            "Status: ${householdDetail!.owner?.status ?? 'Unknown'}",
            style: const TextStyle(fontSize: 20),
          ),
          const Divider(),
        ],
      ),
    );

    const otherResidentsTitle = Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        "Other Residents:",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );

    final residentsWidgets = (householdDetail!.residents == null ||
            householdDetail!.residents!.isEmpty)
        ? [
            const Text(
              "No residents found.",
              style: TextStyle(fontSize: 20, color: Colors.black54),
            ),
          ]
        : householdDetail!.residents!.map((resident) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Name: ${resident.residentName ?? 'Unknown'}",
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    "Date of Birth: ${resident.dateOfBirth ?? 'Unknown'}",
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    "ID Number: ${resident.idNumber ?? 'Unknown'}",
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    "Phone: ${resident.phoneNumber ?? 'Unknown'}",
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    "Status: ${resident.status ?? 'Unknown'}",
                    style: const TextStyle(fontSize: 20),
                  ),
                  const Divider(),
                ],
              ),
            );
          }).toList();

    // Kết hợp owner và residents vào một danh sách
    return [OwnerTitle,ownerWidget, otherResidentsTitle, ...residentsWidgets];
  }
}
