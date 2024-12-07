import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../../common/show_dialog.dart';

class Update extends StatefulWidget {
  const Update({super.key});

  @override
  State<Update> createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController manageRateController = TextEditingController();
  final TextEditingController serviceRateController = TextEditingController();
  bool _isLoad = false;

  void handleOnClick() async {
    final description = descriptionController.text.trim();
    final manageRate = double.tryParse(manageRateController.text.trim());
    final serviceRate = double.tryParse(serviceRateController.text.trim());
    const url = 'https://apartment-management-kjj9.onrender.com/admin/update-fee';

    setState(() {
      _isLoad = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? tokenlogin = prefs.getString('tokenlogin');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $tokenlogin',
        },
        body: {
          'description': description,
          'service_rate': serviceRate.toString(),
          'manage_rate': manageRate.toString(),
        },
      );

      if (response.statusCode == 200) {
        showinform(context, 'Success', 'Fees updated successfully');
      } else {
        if (response.statusCode == 400) {
          showinform(context, 'Failed', 'Invalid or missing data');
        } else {
          showinform(context, 'Failed', 'Fees not found with the given description');
        }
      }
    } catch (e) {
      showinform(context, 'Error', 'An error occurred. Please try again.');
    } finally {
      setState(() {
        _isLoad = false;
      });
      descriptionController.clear();
      manageRateController.clear();
      serviceRateController.clear();
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
                  'Update Fee Information',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              _buildLabeledTextField(
                'Description',
                'Enter description',
                descriptionController,
                maxLines: 2,
              ),
              const SizedBox(height: 20),
              _buildLabeledTextField('Manage Rate', 'Enter new manage rate', manageRateController),
              const SizedBox(height: 20),
              _buildLabeledTextField('Service Rate', 'Enter new service rate', serviceRateController),
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
                    'Update Fee',
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
