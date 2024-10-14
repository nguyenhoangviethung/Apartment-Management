import 'package:flutter/material.dart';
import 'package:frontend/view/home/admin_management/residents_management/common/add_footer.dart';
import 'package:frontend/view/home/admin_management/residents_management/common/resident_card.dart';
import 'package:frontend/view/home/admin_management/residents_management/common/resident_items.dart';
import 'package:frontend/view/home/admin_management/residents_management/residents_management.dart';

class AddResidents extends StatefulWidget {
  const AddResidents({super.key});

  @override
  State<AddResidents> createState() => _AddResidentsState();
}

class _AddResidentsState extends State<AddResidents> {
  final List<ResidentItems> items = [];

  void handleAddActivity(String name) {
    final newItem = ResidentItems(name: name, dob: '', idNumber: '',
        age: '', status: '', room: '', phoneNumber: '');
    setState(() {
      items.add(newItem);
    });
  }

  void handleDeleteActivity(String id) {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            'Add Residents',
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 30,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ResidentsManagement()),
                    );
                  },
                );
              }
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.save,
                size: 35,
                color: Colors.white,
              ),
              onPressed: () {
                print('Save button pressed');
              },
            ),
          ],
        ),

        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            vertical: 25,
            horizontal: 30,
          ),
          child: Column(
            children: items.map((item) => const ResidentCard(name: 'name', dob: 'dob', idNumber: 'idNumber',
                age: 'age', status: 'status', room: 'room', phoneNumber: 'phoneNumber')).toList(),
          ),


        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
                context: context, builder: (
                BuildContext context) {
              return AddFooter(addActivity: handleAddActivity,);
            }
            );
          },
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(90),
          ),
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 40,
          ),
        ),
      ),
    );
  }
}