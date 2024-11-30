import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../common/custom_date_picker.dart';

class EditFooter extends StatefulWidget {
  final Function editResidentInfo;
  final int id;

  const EditFooter({super.key, required this.id, required this.editResidentInfo});

  @override
  State<EditFooter> createState() => _EditFooterState();
}

class _EditFooterState extends State<EditFooter> {
  String? _selectedStatus;
  String _dob = '';
  DateTime selectedDate = DateTime.now();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  void handleOnClick() async {
    final newName = nameController.text.trim();
    final newPhoneNumber = phoneController.text.trim();
    final newDob = _dob;
    final newStatus = _selectedStatus;
    widget.editResidentInfo(widget.id, newName, newDob, newStatus, newPhoneNumber);

    // Xóa giá trị sau khi thêm
    nameController.clear();
    phoneController.clear();
  }

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
              _buildTextField('Enter name', nameController),
              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 10),
                  const Text(
                    'Date of birth: ',
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

              const SizedBox(height: 8),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Status:', style: TextStyle(
                  fontFamily: 'Times New Roman',
                  fontSize: 18,
                )),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildRadioOption("Thường trú"),
                  _buildRadioOption("Tạm trú"),
                  _buildRadioOption("Tạm vắng"),
                ],
              ),
              _buildTextField('Enter phone number', phoneController),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
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
                child: const Text(
                  'Edit',
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

  Widget _buildRadioOption(String title) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<String>(
          value: title,
          groupValue: _selectedStatus,
          onChanged: (String? value) {
            setState(() {
              _selectedStatus = value; // Cập nhật lựa chọn
            });
          },
        ),
        Text(title, style: const TextStyle(fontSize: 17)),
      ],
    );
  }
}