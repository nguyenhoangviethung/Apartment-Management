import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../../../../common/custom_date_picker.dart';
import '../../../../../../common/show_dialog.dart';

class Add extends StatefulWidget {
  Add({super.key});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedDueDate = DateTime.now();
  String _startDate = '';
  String _dueDate = '';

  // Tạo các controller riêng cho mỗi trường nhập liệu
  final TextEditingController startDateController = TextEditingController();

  final TextEditingController dueDateController = TextEditingController();

  final TextEditingController serviceRateController = TextEditingController();

  final TextEditingController manageRateController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();

  bool _isload=false;

  void handleOnClick() async {
    setState(() {
      _isload = true;
    });

    final startdate = _startDate;
    final duedate = _dueDate;
    final servicerate = double.tryParse(serviceRateController.text.trim());
    final managerate = double.tryParse(manageRateController.text.trim());
    final description = descriptionController.text.trim();
    const url = 'https://apartment-management-kjj9.onrender.com/admin/add-fee';

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? tokenlogin = prefs.getString('tokenlogin');
      print(tokenlogin);
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
      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        showinform(context, 'Success', 'Fees added successfully');
      } else {
        showinform(context, 'Failed', 'Cannot add fee');
      }
    } catch (e) {
      print('Error: $e');
      showinform(context, 'Error', 'An error occurred. Please try again.');
    } finally {
      // Đảm bảo nút trở lại trạng thái 'Add' dù là thành công hay thất bại
      setState(() {
        _isload = false;
      });
      // Xóa giá trị sau khi thêm
      startDateController.clear();
      dueDateController.clear();
      serviceRateController.clear();
      manageRateController.clear();
      descriptionController.clear();
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
                    return GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                      },
                      child: Container(
                        height: 465, // Tăng chiều cao nếu cần
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(width: 10),
                                  const Text(
                                    'Start date: ',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: CustomDatePicker(
                                      initialDate: selectedStartDate,
                                      onDateSelected: (date) {
                                        setState(() {
                                          selectedStartDate = date;
                                          _startDate = DateFormat('yyyy-MM-dd').format(date); // Cập nhật biến _dob
                                        });
                                      },
                                      label: '',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(width: 10),
                                  const Text(
                                    'Due date: ',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  const SizedBox(width: 18),
                                  Expanded(
                                    child: CustomDatePicker(
                                      initialDate: selectedDueDate,
                                      onDateSelected: (date) {
                                        setState(() {
                                          selectedDueDate = date; // Cập nhật ngày đã chọn
                                          _dueDate = DateFormat('yyyy-MM-dd').format(date); // Cập nhật biến _dob
                                        });
                                      },
                                      label: '',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildTextField('Enter service rate', serviceRateController),
                              const SizedBox(height: 16),
                              _buildTextField('Enter manage rate', manageRateController),
                              const SizedBox(height: 16),
                              _buildTextField('Enter description', descriptionController),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: (){
                                  handleOnClick();
                                  FocusScope.of(context).unfocus();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: _isload?CircularProgressIndicator(color: Colors.white): const Text(
                                  'Add',
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
              Icons.add,
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