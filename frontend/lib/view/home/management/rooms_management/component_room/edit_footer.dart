import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../common/show_dialog.dart';
class EditFooter extends StatefulWidget {
  final int id;
  final Function editRoomInfo;

  EditFooter({super.key, required this.id, required this.editRoomInfo});

  @override
  State<EditFooter> createState() => _EditFooterState();
}

class _EditFooterState extends State<EditFooter> {
  bool _isload=false;
  // Tạo các controller riêng cho mỗi trường nhập liệu
  final TextEditingController numResidentsController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  @override
  void dispose() {
    numResidentsController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void handleOnClick() async {
    setState(() {
      _isload = true;
    });

    final newNumResidents = int.tryParse(numResidentsController.text.trim()) ?? 0;
    final newPhoneNumber = phoneController.text.trim();
    widget.editRoomInfo(widget.id, newNumResidents, newPhoneNumber);

    final url = 'https://apartment-management-kjj9.onrender.com/admin/update${widget.id}';
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? tokenlogin = prefs.getString('tokenlogin');
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $tokenlogin',
        },
        body: {
          'num_residents': newNumResidents.toString(),
          'phone_number': newPhoneNumber,
        },
      );

      setState(() {
        _isload = false;
      });
      if (response.statusCode == 200) {
        widget.editRoomInfo(widget.id, newNumResidents, newPhoneNumber);
        Navigator.of(context).pop();
        showinform(context, 'Success', 'Update Successful');
      } else {
        showinform(context, 'Failed', 'Try again');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _isload = false;
      });
    }

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
            Text('Edit room ${widget.id} information', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),),
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
              child: _isload?const CircularProgressIndicator(color: Colors.white):const Text(
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
