import 'package:flutter/material.dart';
import 'package:frontend/common/custom_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:frontend/View/Home/main_home.dart';


class Update extends StatefulWidget {
  const Update({super.key});

  @override
  State<Update> createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  DateTime selectedDate = DateTime.now();
  String _dob = '';

  void _showSuccessMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Center(
          child: Text(
            'Update successful!',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        leading: IconButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const MainHome(currentIndex: 1,)));
            },
            icon: const Icon(Icons.arrow_back,color: Colors.white,)
        ),
        backgroundColor: Colors.blueAccent,
        title: const Text('Update',style: TextStyle(color: Colors.white,fontSize: 25),),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Các trường thông tin
            _buildInfoField(label: 'Name', icon: Icons.person),
            _buildInfoField(label: 'SDT', icon: Icons.phone),
            _buildInfoField(label: 'Role', icon: Icons.work),
            // _buildInfoField(label: 'Date of birth', icon: Icons.calendar_today),
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
                        _dob = DateFormat('yyyy-MM-dd').format(date);
                      });
                    },
                    label: '',
                  ),
                ),
              ],
            ),
            _buildInfoField(label: 'Age', icon: Icons.person_outline),
            _buildInfoField(label: 'Avatar', icon: Icons.picture_in_picture),
            _buildInfoField(label: 'ID Number', icon: Icons.credit_card),
            _buildInfoField(label: 'Room', icon: Icons.room),

            const SizedBox(height: 20),

            // Nút cập nhật
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  _showSuccessMessage(context);

                  // Đợi SnackBar hiển thị xong rồi mới quay lại màn hình User
                  await Future.delayed(const Duration(seconds: 2));
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  backgroundColor: Colors.lightBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Update',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoField({
    required String label,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
