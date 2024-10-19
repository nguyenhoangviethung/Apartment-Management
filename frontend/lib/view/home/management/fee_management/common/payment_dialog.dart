import 'package:flutter/material.dart';

void showPaymentDialog(BuildContext context) {
  final TextEditingController controller = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Center(child: Text('Thanh Toán', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),)),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Nhập số tiền', // Sử dụng labelText
            border: OutlineInputBorder(), // Thêm border để tạo thành ô chữ nhật
          ),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Xử lý khi nhấn nút OK
              final inputValue = controller.text;
              print('Số tiền nhập: $inputValue');
              Navigator.of(context).pop(); // Đóng popup
            },
            child: const Text('OK', style: TextStyle(fontSize: 20),),
          ),
        ],
      );
    },
  );
}