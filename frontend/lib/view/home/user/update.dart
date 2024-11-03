import 'package:flutter/material.dart';

class Update extends StatelessWidget {
  const Update({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update'),
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
            _buildInfoField(label: 'Date of birth', icon: Icons.calendar_today),
            _buildInfoField(label: 'Age', icon: Icons.person_outline),
            _buildInfoField(label: 'Avatar', icon: Icons.picture_in_picture),
            _buildInfoField(label: 'ID Number', icon: Icons.credit_card),
            _buildInfoField(label: 'Room', icon: Icons.room),

            const SizedBox(height: 20),

            // Nút cập nhật
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text('Cập nhật'),
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