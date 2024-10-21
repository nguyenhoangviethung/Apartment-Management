import 'package:flutter/material.dart';

class EditFooter extends StatelessWidget {
  final int id;
  final Function editRoomInfo;

  EditFooter({super.key, required this.id, required this.editRoomInfo});

  // Tạo các controller riêng cho mỗi trường nhập liệu
  final TextEditingController numResidentsController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  void handleOnClick() {
    // Lấy giá trị từ tất cả các trường nhập liệu
    final newNumResidents = int.tryParse(numResidentsController.text.trim())??0;
    final newPhoneNumber = phoneController.text.trim();

    editRoomInfo(id, newNumResidents, newPhoneNumber);

    // Xóa giá trị sau khi thêm
    numResidentsController.clear();
    phoneController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
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
            Text('Edit room $id information', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),),
            const SizedBox(height: 16),
            _buildTextField('Enter new number of residents', numResidentsController),
            const SizedBox(height: 16),
            _buildTextField('Enter new phone number', phoneController),
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
    );
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
}
