import 'package:flutter/material.dart';
import 'package:frontend/View/Home/main_home.dart';
import 'package:frontend/common/show_dialog.dart';
import 'package:frontend/models/vehicle.dart';
import 'package:frontend/services/fetch_vehicles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class VehiclesManagement extends StatefulWidget {
  const VehiclesManagement({super.key});

  @override
  State<VehiclesManagement> createState() => _VehiclesManagementState();
}

class _VehiclesManagementState extends State<VehiclesManagement> {

  final TextEditingController IdController = TextEditingController();
  final TextEditingController roomController = TextEditingController();
  final TextEditingController licenseController = TextEditingController();

  String selectedVehicleType = 'car';
  List<Vehicle> allVehicles =[];
  List<Vehicle> filteredVehicles = [];
  @override
  void initState() {
    super.initState();
    fetchVehicles().then((value) {
      setState(() {
        allVehicles=value??[];
        filteredVehicles=value??[];
      });
    });
  }

  Future<void> addVehicle() async{
    if (IdController.text.isNotEmpty &&
        roomController.text.isNotEmpty &&
        licenseController.text.isNotEmpty) {
      const String url = 'https://apartment-management-kjj9.onrender.com/admin/add_vehicle';
      SharedPreferences prefs=await SharedPreferences.getInstance();
      String ? tokenlogin= prefs.getString('tokenlogin');
      try{
        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Authorization': 'Bearer ${tokenlogin}',
            'Content-Type': 'application/x-www-form-urlencoded'
          },
          body: {
            'vehicles_id':IdController.text,
            'household_id': roomController.text,
            'license_plate': licenseController.text,
            'vehicle_type': selectedVehicleType
          }
        );
        if(response.statusCode==201){
          showinform(context, 'Success', 'Added new vehicles');
          setState(() {
            Vehicle newVehicle = Vehicle(
              int.parse(roomController.text),
              licenseController.text,
              selectedVehicleType,
              int.parse(IdController.text),
            );
            allVehicles.add(newVehicle);
            filteredVehicles.add(newVehicle);
          });
        }
      }catch(e){
        print('Error');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed: Please fill all fields')),
      );
    }
  }

  Future<void> deleteVehicle (int vehicleId) async{
    final String url = 'https://apartment-management-kjj9.onrender.com/admin/remove_vehicle/${vehicleId}';
    SharedPreferences prefs=await SharedPreferences.getInstance();
    String ? tokenlogin= prefs.getString('tokenlogin');
    try{
      final response = await http.post(Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${tokenlogin}',
        }
      );

      if(response.statusCode==201){
        setState(() {
          allVehicles.removeWhere((vehicle) => vehicle.vehicles_id == vehicleId);
          filteredVehicles.removeWhere((vehicle) => vehicle.vehicles_id == vehicleId);
        });
        showinform(context, 'Success', 'Completely Deleted vehicle');
      }else{
        showinform(context, 'Failed', 'Try again');
      }
    }catch(e){
      print('Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Quản lý phương tiện',
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 30, color: Colors.white),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=> const MainHome(currentIndex: 1,)));
          },
        ),
      ),
      body: Column(
        children: [
          // Search bar with icon search
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search by phone",
                      suffixIcon: const Icon(
                        Icons.search
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    onChanged: (text){
                      setState(() {
                        text=text.toLowerCase();
                        filteredVehicles=allVehicles.where((vehicle){
                          var room = vehicle.household_id?.toString()??'';
                          var type = vehicle.vehicle_type??'';
                          var license = vehicle.license_plate??'';
                          return room.contains(text)|| type.contains(text)|| license.contains(text);
                        }).toList();
                      });
                    },
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
                        builder: (context) => StatefulBuilder( // Thêm StatefulBuilder
                          builder: (context, setState) { // Thêm setState riêng trong dialog
                            return AlertDialog(
                              title: const Text('Add New Vehicle'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: IdController,
                                    decoration: const InputDecoration(
                                      labelText: 'Vehicle Id',
                                    ),
                                  ),
                                  TextField(
                                    controller: roomController,
                                    decoration: const InputDecoration(
                                      labelText: 'Room',
                                    ),
                                  ),
                                  TextField(
                                    controller: licenseController,
                                    decoration: const InputDecoration(
                                      labelText: 'License Plate',
                                    ),
                                  ),
                                  DropdownButton<String>(
                                    value: selectedVehicleType,
                                    items: const [
                                      DropdownMenuItem(
                                        value: 'car',
                                        child: Text('car'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'bicycle',
                                        child: Text('bicycle'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'motor',
                                        child: Text('motor'),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      setState(() { // Gọi setState của StatefulBuilder
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
                            );
                          },
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
                  id: vehicle.vehicles_id?.toString()??"unidentified",
                  room: vehicle.household_id?.toString()?? "unidentified",
                  license: vehicle.license_plate??"unidentified",
                  type: vehicle.vehicle_type??"unidentified",
                  onDelete: () => deleteVehicle(vehicle.vehicles_id!),
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
  final String id;
  final String room;
  final String license;
  final String type;
  final VoidCallback onDelete;

  const VehicleCard({
    super.key,
    required this.id,
    required this.room,
    required this.license,
    required this.type,
    required this.onDelete,
  });

  IconData getVehicleIcon() {
    switch (type) {
      case 'bicycle':
        return Icons.pedal_bike;
      case 'motor':
        return Icons.motorcycle;
      default:
        return Icons.directions_car;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
      child: ListTile(
        leading: Icon(getVehicleIcon(), color: Colors.blue, size: 40),
        title: Text(id, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Row(
          children: [
            const Icon(Icons.home, size: 18),
            const SizedBox(width: 4),
            Text("Room: $room"),
            const SizedBox(width: 16),
            const Icon(Icons.home_repair_service_outlined, size: 18),
            const SizedBox(width: 4),
            Text(license),
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
