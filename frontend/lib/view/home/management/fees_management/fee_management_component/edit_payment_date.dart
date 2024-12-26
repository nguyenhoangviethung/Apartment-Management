import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../common/custom_date_picker.dart';


class EditPaymentDate extends StatefulWidget {
  const EditPaymentDate({super.key});

  @override
  State<EditPaymentDate> createState() => _EditPaymentDateState();
}

class _EditPaymentDateState extends State<EditPaymentDate> {

  DateTime selectedDate = DateTime.now();
  String _dob = '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
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
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              const Text('Update payment date'),
              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 10),
                  const Text(
                    'Date of paying: ',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomDatePicker(
                      initialDate: selectedDate,
                      onDateSelected: (date) {
                        setState(() {
                          selectedDate = date; // Cập nhật ngày đã chọn
                          _dob = DateFormat('yyyy-MM-dd').format(date); // Cập nhật biến _dob
                        });
                      },
                      label: '',
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
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
                child: const Text(
                  'Save',
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

  Widget _buildTextField(String label, TextEditingController controller, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: TextField(
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
      ),
    );
  }

}

