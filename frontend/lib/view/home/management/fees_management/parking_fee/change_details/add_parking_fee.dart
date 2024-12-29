import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../../../../common/custom_date_picker.dart';
import '../../../../../../common/show_dialog.dart';

class AddParkingFee extends StatefulWidget {
  const AddParkingFee({super.key});

  @override
  State<AddParkingFee> createState() => _AddParkingFeeState();
}

class _AddParkingFeeState extends State<AddParkingFee> {
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedDueDate = DateTime.now();
  String _startDate = '';
  String _dueDate = '';

  final TextEditingController descriptionController = TextEditingController();

  bool _isLoad = false;

  void handleOnClick() async {
    setState(() {
      _isLoad = true;
    });

    final startdate = _startDate.isNotEmpty ? _startDate : DateFormat('yyyy-MM-dd').format(selectedStartDate);
    final duedate = _dueDate.isNotEmpty ? _dueDate : DateFormat('yyyy-MM-dd').format(selectedDueDate);
    final description = descriptionController.text.trim();
    const url = 'https://apartment-management-kjj9.onrender.com/admin/add-park-fee';

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? tokenlogin = prefs.getString('tokenlogin');
      Map<String,dynamic> body={
        'start_date': startdate,
        'due_date': duedate,
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
          'description': description
        },
      );
      print(response.statusCode);
      print(response.body);
      print(body);
      if (response.statusCode == 200) {
        showinform(context, 'Thành công', 'Đã thêm phí thành công');
      } else {
        showinform(context, 'Thất bại', 'Không thể thêm phí');
      }
    } catch (e) {
      showinform(context, 'Lỗi', 'Đã xảy ra lỗi. Vui lòng thử lại.');
    } finally {
      setState(() {
        _isLoad = false;
      });
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
                  'Thêm Phí Đỗ Xe Mới',
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
                  const Text('Ngày bắt đầu:', style: TextStyle(fontSize: 16)),
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
                  const Text('Ngày đáo hạn:  ', style: TextStyle(fontSize: 16)),
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
              _buildLabeledTextField(
                'Mô tả',
                'Nhập mô tả',
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
                    'Thêm Phí',
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
