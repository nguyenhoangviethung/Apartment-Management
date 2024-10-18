import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'fee_item.dart';

class DateFilterPopup extends StatefulWidget {
  final Function(DateTime, DateTime)? onDateRangeSelected;

  const DateFilterPopup({Key? key, this.onDateRangeSelected}) : super(key: key);

  @override
  _DateFilterPopupState createState() => _DateFilterPopupState();
}

class _DateFilterPopupState extends State<DateFilterPopup> {
  DateTime startDate = DateTime(2018, 5, 1);
  DateTime endDate = DateTime(2019, 10, 14);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Tiêu đề
          Container(
            width: double.infinity, // Chiếm toàn bộ chiều rộng
            padding: const EdgeInsets.symmetric(vertical: 14), // Thêm padding
            color: Colors.blue.shade700,
            alignment: Alignment.center,
            child: const Text(
              'Select Date Range',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            )
          ),

          const SizedBox(height: 8,),

          // Chọn ngày
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _buildDateField(
                    'From date',
                    startDate,
                        (date) => setState(() => startDate = date),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDateField(
                    'To date',
                    endDate,
                        (date) => setState(() => endDate = date),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12,),

          // Nút Ok
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: ElevatedButton(
              onPressed: () {
                if (widget.onDateRangeSelected != null) {
                  widget.onDateRangeSelected!(startDate, endDate);
                }
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: const Text('Ok', style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(
      String label,
      DateTime selectedDate,
      Function(DateTime) onDateSelected,
      ) {
    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2025),
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: ThemeData.light().copyWith(
                colorScheme: ColorScheme.light(primary: Colors.blue.shade700), // Màu sắc chính
                buttonTheme: const ButtonThemeData( textTheme: ButtonTextTheme.primary), // Màu văn bản nút
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          onDateSelected(picked);
        }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.calendar_month_outlined, size: 45, color: Colors.blue.shade700),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade400),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  DateFormat('dd MMM yyyy').format(selectedDate),
                  style: TextStyle(fontSize: 15, color: Colors.blue.shade700, fontFamily: "Times New Roman"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Cách sử dụng:
void showDateFilterPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: DateFilterPopup(
        onDateRangeSelected: (startDate, endDate) {
          print('Selected date range: $startDate - $endDate');
          // Xử lý khi người dùng chọn khoảng thời gian
        },
      ),
    ),
  );
}