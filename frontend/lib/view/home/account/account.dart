import 'package:flutter/material.dart';
import 'package:frontend/View/Authentication/login.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool isLoading = true;
  Map<String, dynamic> userData = {};
  final String apiUrl =
      "https://apartment-management-kjj9.onrender.com/user/info";
  dynamic _selectedImage; // Thay đổi kiểu để hỗ trợ đa nền tảng

  @override
  void initState() {
    super.initState();
    fetchUserData();
    _loadSavedImage();
  }

  Future<void> fetchUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('tokenlogin') ?? '';

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          Map<String, dynamic> jsonResponse = json.decode(response.body);
          Map<String, dynamic> userInfo = jsonResponse['info'];

          setState(() {
            userData = {
              'full_name': userInfo['username'] ?? 'Not provided',
              'phone_number': userInfo['phone_number'] ?? 'Not provided',
              'role': userInfo['user_role'] ?? 'Not provided',
              'date_of_birth': userInfo['date_of_birth'] ?? 'Not provided',
              'age': userInfo['age'] ?? 'Not provided',
              'id_number': userInfo['id_number'] ?? 'Not provided',
              'room': userInfo['room'] ?? 'Not provided',
              'email': userInfo['user_email'] ?? 'Not provided',
            };
            isLoading = false;
          });
        } else {
          throw Exception('Empty response from API');
        }
      } else {
        throw Exception('Failed to load user data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error detail: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  // Phương thức tải ảnh đã lưu
  Future<void> _loadSavedImage() async {
    final prefs = await SharedPreferences.getInstance();

    if (kIsWeb) {
      // Xử lý cho web - lấy base64
      final savedImageBase64 = prefs.getString('profile_image_base64');
      if (savedImageBase64 != null) {
        setState(() {
          _selectedImage = savedImageBase64;
        });
      }
    } else {
      // Xử lý cho mobile
      final savedImagePath = prefs.getString('saved_profile_image_path');
      if (savedImagePath != null && File(savedImagePath).existsSync()) {
        setState(() {
          _selectedImage = File(savedImagePath);
        });
      }
    }
  }

  // Phương thức chọn và lưu ảnh
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Chọn ảnh đại diện'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Chọn từ thư viện'),
                  onTap: () async {
                    Navigator.of(context).pop();
                    final XFile? image = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                      maxWidth: 1800,
                      maxHeight: 1800,
                      imageQuality: 85,
                    );

                    if (image != null) {
                      final prefs = await SharedPreferences.getInstance();

                      if (kIsWeb) {
                        // Xử lý cho web - lưu base64
                        final bytes = await image.readAsBytes();
                        final base64Image = base64Encode(bytes);

                        await prefs.setString('profile_image_base64', base64Image);

                        setState(() {
                          _selectedImage = base64Image;
                        });
                      } else {
                        // Xử lý cho mobile
                        final appDir = await getApplicationDocumentsDirectory();
                        final fileName = path.basename(image.path);
                        final savedImage = await File(image.path).copy('${appDir.path}/$fileName');

                        await prefs.setString('saved_profile_image_path', savedImage.path);

                        setState(() {
                          _selectedImage = savedImage;
                        });
                      }
                    }
                  },
                ),
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text('Chụp ảnh mới'),
                  onTap: () async {
                    Navigator.of(context).pop();

                    // Chỉ cho phép chụp ảnh trên mobile
                    if (!kIsWeb) {
                      final XFile? image = await picker.pickImage(
                        source: ImageSource.camera,
                        maxWidth: 1800,
                        maxHeight: 1800,
                        imageQuality: 85,
                      );

                      if (image != null) {
                        final appDir = await getApplicationDocumentsDirectory();
                        final fileName = path.basename(image.path);
                        final savedImage = await File(image.path).copy('${appDir.path}/$fileName');

                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setString('saved_profile_image_path', savedImage.path);

                        setState(() {
                          _selectedImage = savedImage;
                        });
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Chức năng chụp ảnh không khả dụng trên web')),
                      );
                    }
                  },
                ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      print('Lỗi chọn ảnh: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể chọn ảnh: $e')),
      );
    }
  }

  Future<void> handleLogout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('tokenlogin') ?? '';

      final response = await http.get(
        Uri.parse('https://apartment-management-kjj9.onrender.com/auth/logout'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showMaterialBanner(
            MaterialBanner(
              content: const Center(
                child: Text(
                  'Logout successful',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              backgroundColor: Colors.green,
              actions: [
                Container(),
              ],
            ),
          );

          Future.delayed(Duration(seconds: 1), () {
            ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Login()),
            );
          });
        }
      } else {
        throw Exception(
            'Logout failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error details: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showMaterialBanner(
          MaterialBanner(
            content: Text('Error logout: ${e.toString()}'),
            backgroundColor: Colors.red,
            actions: [
              TextButton(
                child: Text('Close'),
                onPressed: () =>
                    ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              decoration: BoxDecoration(
                color: Colors.pink[100],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        backgroundImage: _buildImageProvider(),
                        child: _selectedImage == null
                            ? Text(
                          (userData['full_name'] ?? 'U')[0]
                              .toUpperCase(),
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: _pickImage,
                            padding: EdgeInsets.all(4),
                            constraints: BoxConstraints(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userData['full_name'] ?? 'Username',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    userData['phone_number'] ?? 'Phone not provided',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildInfoItem(
                    Icons.email,
                    'Email',
                    userData['email'] ?? 'Not provided',
                  ),
                  _buildInfoItem(
                    Icons.phone,
                    'Phone',
                    userData['phone_number'] ?? 'Not provided',
                  ),
                  _buildInfoItem(
                    Icons.person,
                    'Role',
                    userData['role'] ?? 'Not provided',
                  ),
                  _buildInfoItem(
                    Icons.cake,
                    'Date of Birth',
                    userData['date_of_birth'] ?? 'Not provided',
                  ),
                  _buildInfoItem(
                    Icons.calendar_today,
                    'Age',
                    userData['age']?.toString() ?? 'Not provided',
                  ),
                  _buildInfoItem(
                    Icons.badge,
                    'ID Number',
                    userData['id_number'] ?? 'Not provided',
                  ),
                  _buildInfoItem(
                    Icons.meeting_room,
                    'Room',
                    userData['room'] ?? 'Not provided',
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: handleLogout,
                      icon: const Icon(Icons.logout),
                      label: const Text(
                        'Logout',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  ImageProvider? _buildImageProvider() {
    if (_selectedImage == null) return null;

    if (kIsWeb) {
      // Cho web - sử dụng base64
      return _selectedImage is String
          ? MemoryImage(base64Decode(_selectedImage))
          : null;
    } else {
      // Cho mobile
      return _selectedImage is File
          ? FileImage(_selectedImage)
          : null;
    }
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 24),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 5),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}