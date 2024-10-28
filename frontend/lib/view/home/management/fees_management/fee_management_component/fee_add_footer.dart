import 'package:flutter/material.dart';

class AddFee extends StatelessWidget {
  AddFee({super.key, required this.addNewFee});

  final Function addNewFee;

  // Tạo các controller riêng cho mỗi trường nhập liệu
  final TextEditingController nameController = TextEditingController();
  final TextEditingController feeController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  void handleOnClick() {
    // Lấy giá trị từ tất cả các trường nhập liệu
    final name = nameController.text.trim();
    final fee = feeController.text.trim();
    var id = idController.text.trim();
    final startDate = startDateController.text.trim();
    final endDate = endDateController.text.trim();
    if(id == '') {
      id = DateTime.now().toString();
    }

    addNewFee(name, fee, id, startDate, endDate);

    // Xóa giá trị sau khi thêm
    nameController.clear();
    feeController.clear();
    idController.clear();
    startDateController.clear();
    endDateController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350, // Tăng chiều cao nếu cần
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
            _buildTextField('Enter name', nameController),
            const SizedBox(height: 16),
            _buildTextField('Enter fee', feeController),
            const SizedBox(height: 16),
            _buildTextField('Enter id number', idController),
            const SizedBox(height: 16),
            _buildTextField('Enter start date', startDateController),
            const SizedBox(height: 16),
            _buildTextField('Enter end date', endDateController),
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
