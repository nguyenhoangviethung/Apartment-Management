import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatelessWidget {
  final DateTime initialDate;
  final Function(DateTime) onDateSelected;
  final String label; // Thêm biến label để truyền vào

  const CustomDatePicker({
    super.key,
    required this.initialDate,
    required this.onDateSelected,
    this.label = '', // Giá trị mặc định là chuỗi rỗng
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2050),
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: ThemeData.light().copyWith(
                colorScheme: ColorScheme.light(primary: Colors.blue.shade700),
                buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          onDateSelected(picked);
        }
      },
      child: Material(
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Kiểm tra xem label có phải là chuỗi rỗng không
                    if (label.isNotEmpty) ...[
                      Text(
                        label,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                    ],
                    // Hiển thị ngày đã chọn
                    Text(
                      DateFormat('yyyy-MM-dd').format(initialDate), // Đổi định dạng ở đây
                      style: TextStyle(fontSize: 18, color: Colors.blue.shade800, fontFamily: "Times New Roman"),
                    ),
                  ],
                ),
                Icon(Icons.calendar_month_outlined, size: 45, color: Colors.blue.shade700),
              ],
            ),
          ),
        ),
      ),
    );
  }
}