import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../../common/show_dialog.dart';
class Update extends StatefulWidget {
  Update({super.key});

  @override
  State<Update> createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  // Tạo các controller riêng cho mỗi trường nhập liệu
  final TextEditingController descriptionController = TextEditingController();

  final TextEditingController manageRateController = TextEditingController();

  final TextEditingController serviceRateController = TextEditingController();
  bool _isload=false;

  void handleOnClick() async {
    final description = descriptionController.text.trim();
    final manageRate = double.tryParse(manageRateController.text.trim());
    final serviceRate = double.tryParse(serviceRateController.text.trim());
    const url = 'https://apartment-management-kjj9.onrender.com/admin/update-fee';
    setState(() {
      _isload=true;
    });
    try {
      SharedPreferences prefs= await SharedPreferences.getInstance();
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
      print(response.statusCode);
      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        showinform(context, 'Success', 'Fees updated successfully');
      } else {
        if(response.statusCode==400){
          showinform(context, 'Failed', 'Invalid or missing data');
        }else{
          showinform(context, 'Failed', 'Fees not found with the given description');
        }
      }
    } catch (e) {
      print('Error: $e');
      showinform(context, 'Error', 'An error occurred. Please try again.');
    } finally {
      setState(() {
        _isload = false;
      });
      descriptionController.clear();
      manageRateController.clear();
      serviceRateController.clear();
    }
  }

    @override
    Widget build(BuildContext context) {
      return Stack(
        children: [
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 320, // Tăng chiều cao nếu cần
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const SizedBox(height: 15),
                              _buildTextField('Enter new description',
                                  descriptionController),
                              const SizedBox(height: 16),
                              _buildTextField('Enter new manage rate',
                                  manageRateController),
                              const SizedBox(height: 16),
                              _buildTextField('Enter new service rate',
                                  serviceRateController),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  handleOnClick();
                                  FocusScope.of(context).unfocus();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child:_isload?CircularProgressIndicator(color: Colors.white): const Text(
                                  'Update',
                                  style: TextStyle(
                                    fontFamily: 'Times New Roman',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                );
              },
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(90),
              ),
              child: const Icon(
                Icons.edit_calendar_outlined,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
        ],
      );
    }
}

Widget _buildTextField(String label, TextEditingController controller) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blue, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    style: const TextStyle(
      fontFamily: 'Times New Roman',
      fontWeight: FontWeight.bold,
      fontSize: 18,
    ),
  );
}