import 'package:flutter/material.dart';

import '../../../../../common/custom_date_picker.dart';

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
      height: 240,
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
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
              color: Colors.blue.shade800,
            ),
            alignment: Alignment.center,
            child: const Text(
              'Select Date Range',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                // Đảm bảo không có TextDecoration nào được áp dụng
                decoration: TextDecoration.none, // Thêm dòng này nếu cần
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomDatePicker(
                    initialDate: startDate,
                    onDateSelected: (date) => setState(() => startDate = date),
                    label: 'Start date',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomDatePicker(
                    initialDate: endDate,
                    onDateSelected: (date) => setState(() => endDate = date),
                    label: 'End date',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
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
}
