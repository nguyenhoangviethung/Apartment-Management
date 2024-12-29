import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../../../../common/custom_date_picker.dart';
import '../../../../../../common/show_dialog.dart';

class Add extends StatefulWidget {
  const Add({super.key});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedDueDate = DateTime.now();
  String _startDate = '';
  String _dueDate = '';

  final TextEditingController serviceRateController = TextEditingController();
  final TextEditingController manageRateController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  bool _isLoad = false;

  void handleOnClick() async {
    setState(() {
      _isLoad = true;
    });

    final startdate = _startDate.isNotEmpty ? _startDate : DateFormat('yyyy-MM-dd').format(selectedStartDate);
    final duedate = _dueDate.isNotEmpty ? _dueDate : DateFormat('yyyy-MM-dd').format(selectedDueDate);
    final servicerate = double.tryParse(serviceRateController.text.trim());
    final managerate = double.tryParse(manageRateController.text.trim());
    final description = descriptionController.text.trim();
    const url = 'https://apartment-management-kjj9.onrender.com/admin/add-fee';

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? tokenlogin = prefs.getString('tokenlogin');
      print(tokenlogin);
      Map<String,dynamic> body={
        'start_date': startdate,
        'due_date': duedate,
        'service_rate': servicerate.toString(),
        'manage_rate': managerate.toString(),
        'description': description
      };
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $tokenlogin',
        },
        body: {
          'start_date': startdate,
          'due_date': duedate,
          'service_rate': servicerate.toString(),
          'manage_rate': managerate.toString(),
          'description': description
        },
      );
      print(response.statusCode);
      print(response.body);
      print(body);
      if (response.statusCode == 200) {
        showinform(context, 'Success', 'Fees added successfully');
      } else {
        showinform(context, 'Failed', 'Cannot add fee');
      }
    } catch (e) {
      showinform(context, 'Error', 'An error occurred. Please try again.');
    } finally {
      setState(() {
        _isLoad = false;
      });
      serviceRateController.clear();
      manageRateController.clear();
      descriptionController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'Add New Fee Information',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text('Start date:', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomDatePicker(
                      initialDate: selectedStartDate,
                      onDateSelected: (date) {
                        setState(() {
                          selectedStartDate = date;
                          _startDate = DateFormat('yyyy-MM-dd').format(date);
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text('Due date:  ', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomDatePicker(
                      initialDate: selectedDueDate,
                      onDateSelected: (date) {
                        setState(() {
                          selectedDueDate = date;
                          _dueDate = DateFormat('yyyy-MM-dd').format(date);
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildLabeledTextField('Service Rate', 'Enter service rate', serviceRateController),
              const SizedBox(height: 20),
              _buildLabeledTextField('Manage Rate', 'Enter manage rate', manageRateController),
              const SizedBox(height: 20),
              _buildLabeledTextField(
                'Description',
                'Enter description',
                descriptionController,
                maxLines: 2,
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _isLoad ? null : handleOnClick,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isLoad
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    'Add Fee',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildLabeledTextField(String label, String placeholder, TextEditingController controller,
    {int maxLines = 1}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      const SizedBox(height: 5),
      TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    ],
  );
}
