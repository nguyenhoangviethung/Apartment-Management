import 'package:flutter/material.dart';
import 'package:frontend/View/Authentication/login.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool isLoading = true;
  Map<String, dynamic> userData = {};
  final String apiUrl = "https://apartment-management-kjj9.onrender.com/user/upload-image";
  dynamic _selectedImage;
  String? _imageUrl;
  String? _userId;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('tokenlogin') ?? '';

      final response = await http.get(
        Uri.parse("https://apartment-management-kjj9.onrender.com/user/info"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        Map<String, dynamic> userInfo = jsonResponse['info'];

        setState(() {
          _userId = userInfo['user_id']?.toString();
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
        await loadSavedImageUrl();
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

  Future<void> saveImageUrlForUser(String imageUrl) async {
    if (_userId == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_image_${_userId}', imageUrl);
  }

  ImageProvider? _buildImageProvider() {
    if (_selectedImage != null) {
      return MemoryImage(_selectedImage);
    } else if (_imageUrl != null) {
      return NetworkImage(_imageUrl!);
    }
    return null;
  }
  
  Future<void> loadSavedImageUrl() async {
    if (_userId == null) return;
    final prefs = await SharedPreferences.getInstance();
    final savedImageUrl = prefs.getString('user_image_${_userId}');
    if (savedImageUrl != null) {
      setState(() {
        _imageUrl = savedImageUrl;
        // _selectedImage = Image.network(_imageUrl!);
      });
    }
    print('ccece $_imageUrl');
  }
  Future<void> uploadImage(XFile image) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('tokenlogin') ?? '';

      // Read image bytes
      final bytes = await image.readAsBytes();

      // Create multipart request
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Add authorization header
      request.headers['Authorization'] = 'Bearer $token';

      // Add file to request
      var multipartFile = http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: image.name,
        contentType: MediaType('image', 'jpeg'), // Adjust content type if needed
      );
      request.files.add(multipartFile);

      // Send request
      var response = await request.send();
      print('csdjcec ${response.statusCode}');
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);

      if (response.statusCode == 200) {
        final imageUrl = jsonResponse['img_url'];
        await saveImageUrlForUser(imageUrl);  // Lưu URL ảnh theo user ID

        setState(() {
          _imageUrl = imageUrl;
          _selectedImage = bytes;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile image updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception('Failed to upload image');
      }
    } catch (e) {
      print('Error uploading image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error uploading image: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
        await prefs.remove('tokenlogin');
        await prefs.remove('role');
        await prefs.remove('user_id');
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
                              child: _imageUrl == null
                                  ? Text(
                                      (userData['full_name'] ?? 'U')[0]
                                          .toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    )
                                  : ClipRRect(
                                  child: Image.network(_imageUrl!),
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  onPressed: () async {
                                    final ImagePicker picker = ImagePicker();
                                    final XFile? image = await picker.pickImage(
                                        source: ImageSource.gallery);
                                    if (image != null) {
                                      await uploadImage(image);
                                    }
                                  },
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