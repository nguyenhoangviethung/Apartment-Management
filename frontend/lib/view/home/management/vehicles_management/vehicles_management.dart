import 'package:flutter/material.dart';
import '../management.dart';
import 'package:frontend/View/Home/main_home.dart';


class VehiclesManagement extends StatefulWidget {
  const VehiclesManagement({super.key});

  @override
  State<VehiclesManagement> createState() => _VehiclesManagementState();
}

class _VehiclesManagementState extends State<VehiclesManagement> {
  final List<Map<String, String>> vehicles = [
    {'name': 'Duong', 'room': '201', 'phone': '0123456789', 'type': 'car'},
    {'name': 'Minh', 'room': '102', 'phone': '0987654321', 'type': 'bike'},
    {'name': 'Chien', 'room': '303', 'phone': '0978546784', 'type': 'motorbike'},
  ];

  final TextEditingController searchController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController roomController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  String selectedVehicleType = 'car';
  List<Map<String, String>> filteredVehicles = [];

  @override
  void initState() {
    super.initState();
    filteredVehicles = List.from(vehicles);
  }

  void searchVehicle() {
    setState(() {
      filteredVehicles = vehicles
          .where((vehicle) => vehicle['phone']
          .toString()
          .contains(searchController.text))
          .toList();
    });
  }

  void addVehicle() {
    if (nameController.text.isNotEmpty &&
        roomController.text.isNotEmpty &&
        phoneController.text.isNotEmpty) {
      setState(() {
        vehicles.add({
          'name': nameController.text,
          'room': roomController.text,
          'phone': phoneController.text,
          'type': selectedVehicleType,
        });
        filteredVehicles = List.from(vehicles);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Update successfully')),
      );
      nameController.clear();
      roomController.clear();
      phoneController.clear();
      selectedVehicleType = 'car';
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed: Please fill all fields')),
      );
    }
  }

  void deleteVehicle(int index) {
    setState(() {
      vehicles.removeAt(index);
      filteredVehicles = List.from(vehicles);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Vehicles Management',
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 30, color: Colors.white),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=> const MainHome(currentIndex: 2,)));
          },
        ),
      ),
      body: Column(
        children: [
          // Search bar with icon search
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "Search by phone",
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: searchVehicle,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Add New Vehicle'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: nameController,
                                decoration: const InputDecoration(
                                  labelText: 'Name',
                                ),
                              ),
                              TextField(
                                controller: roomController,
                                decoration: const InputDecoration(
                                  labelText: 'Room',
                                ),
                              ),
                              TextField(
                                controller: phoneController,
                                keyboardType: TextInputType.phone,
                                decoration: const InputDecoration(
                                  labelText: 'Phone',
                                ),
                              ),
                              DropdownButton<String>(
                                value: selectedVehicleType,
                                items: const [
                                  DropdownMenuItem(
                                    value: 'car',
                                    child: Text('Car'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'bike',
                                    child: Text('Bike'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'motorbike',
                                    child: Text('Motorbike'),
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    selectedVehicleType = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                addVehicle();
                                Navigator.pop(context);
                              },
                              child: const Text('Add'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Vehicle list
          Expanded(
            child: ListView.builder(
              itemCount: filteredVehicles.length,
              itemBuilder: (context, index) {
                final vehicle = filteredVehicles[index];
                return VehicleCard(
                  name: vehicle['name']!,
                  room: vehicle['room']!,
                  phone: vehicle['phone']!,
                  type: vehicle['type']!,
                  onDelete: () => deleteVehicle(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class VehicleCard extends StatelessWidget {
  final String name;
  final String room;
  final String phone;
  final String type;
  final VoidCallback onDelete;

  const VehicleCard({
    super.key,
    required this.name,
    required this.room,
    required this.phone,
    required this.type,
    required this.onDelete,
  });

  IconData getVehicleIcon() {
    switch (type) {
      case 'bike':
        return Icons.pedal_bike;
      case 'motorbike':
        return Icons.motorcycle;
      default:
        return Icons.directions_car;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      child: ListTile(
        leading: Icon(getVehicleIcon(), color: Colors.blue, size: 40),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Row(
          children: [
            const Icon(Icons.home, size: 18),
            const SizedBox(width: 4),
            Text("Room: $room"),
            const SizedBox(width: 16),
            const Icon(Icons.phone, size: 18),
            const SizedBox(width: 4),
            Text(phone),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
