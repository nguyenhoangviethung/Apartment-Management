import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../common/custom_date_picker.dart';
import '../../../../../models/resident_info.dart';

class AddFooter extends StatefulWidget {
  const AddFooter({super.key, required this.addNewResident});

  final Function addNewResident;

  @override
  State<AddFooter> createState() => _AddFooterState();
}

class _AddFooterState extends State<AddFooter> {
  String? _selectedStatus;
  String _dob = '';
  DateTime selectedDate = DateTime.now();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController roomController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  void handleOnClick() {
    final name = nameController.text.trim();
    final dob = _dob;
    var id = idController.text.trim();
    final age = int.tryParse(ageController.text.trim()) ?? 0;
    final status = _selectedStatus;
    final room = int.tryParse(roomController.text.trim()) ?? 0;
    final phone = phoneController.text.trim();

    if (id.isEmpty) {
      id = DateTime.now().toString();
    }

    final resident = ResidentInfo(
      full_name: name,
      date_of_birth: dob,
      id_number: id,
      age: age,
      room: room,
      phone_number: phone,
      status: status, res_id: 1,user_id: 1
    );

    widget.addNewResident(resident);

    // Xóa dữ liệu sau khi thêm
    nameController.clear();
    idController.clear();
    ageController.clear();
    roomController.clear();
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
              _buildTextField('Enter id number', idController),
              const SizedBox(height: 16),
              _buildTextField('Enter age', ageController),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Status:', style: TextStyle(
                  fontFamily: 'Times New Roman',
                  fontSize: 18,
                )),
              ),
              Wrap(
                alignment: WrapAlignment.spaceBetween, // Căn chỉnh các phần tử
                children: [
                  _buildRadioOption("Thường trú"),
                  _buildRadioOption("Tạm trú"),
                  _buildRadioOption("Tạm vắng"),
                ],
              ),
              _buildTextField('Enter room', roomController),
              const SizedBox(height: 16),
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
        Text(title, style: const TextStyle(fontSize: 15)),
      ],
    );
  }
}
