import 'package:flutter/material.dart';
import 'package:frontend/View/Home/main_home.dart';
import 'package:frontend/common/show_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:convert';

class Update extends StatefulWidget {
  const Update({super.key});

  @override
  State<Update> createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  DateTime selectedDate = DateTime.now();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  bool _isloading = false;
  dynamic _selectedImage;
  String? _imageUrl;
  final String apiUrl =
      "https://apartment-management-kjj9.onrender.com/user/upload-image";
  String? _userId;

  @override
  void initState() {
    super.initState();
    fetchUserIdAndLoadImage();
  }

  Future<void> fetchUserIdAndLoadImage() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString('user_id') ?? '';
    await loadSavedImageUrl();
  }

  Future<void> loadSavedImageUrl() async {
    if (_userId == null) return;
    final prefs = await SharedPreferences.getInstance();
    final savedImageUrl = prefs.getString('user_image_${_userId}');
    if (savedImageUrl != null) {
      setState(() {
        _imageUrl = savedImageUrl;
      });
    }
    print('ccece $_imageUrl');
  }

  Future<void> userUpdate(
      String newName, String newEmail, String newNumber) async {
    setState(() {
      _isloading = true;
    });
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? tokenlogin = prefs.getString('tokenlogin');
      const String url =
          'https://apartment-management-kjj9.onrender.com/user/update';
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $tokenlogin',
        },
        body: {
          'new_name': newName,
          'new_email': newEmail,
          'new_number': newNumber
        },
      );
      print(tokenlogin);
      print(response.statusCode);
      if (response.statusCode == 200) {
        showinform(context, 'Success', 'User info updated successfully');
      } else {
        print('Error: ${response.statusCode}');
        showinform(context, 'Failed', 'Try again');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        _isloading = false;
      });
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
        await saveImageUrlForUser(imageUrl); // Lưu URL ảnh theo user ID

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MainHome(
                        currentIndex: 1,
                      )));
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        backgroundColor: Colors.blueAccent,
        title: const Text(
          'Cập nhật thông tin',
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
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
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    backgroundImage: _buildImageProvider(),
                    child: _imageUrl == null && _selectedImage == null
                        ? const Icon(Icons.person, size: 50, color: Colors.blue)
                        : null, // No text avatar when image is present
                  ),
                  if (_imageUrl != null || _selectedImage != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: _selectedImage != null
                          ? Image.memory(_selectedImage,
                          width: 100, height: 100, fit: BoxFit.cover)
                          : Image.network(_imageUrl!,
                          width: 100, height: 100, fit: BoxFit.cover),
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
                      child: IconButton(
                        icon: const Icon(
                          Icons.camera_alt,
                          size: 20,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.gallery);
                          if (image != null) {
                            await uploadImage(image);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Các trường thông tin
            _buildInfoField(label: 'Name', icon: Icons.person, controller: name),
            _buildInfoField(label: 'Email', icon: Icons.email, controller: email),
            _buildInfoField(
                label: 'Phone number', icon: Icons.phone, controller: phoneNumber),

            const SizedBox(height: 20),

            // Nút cập nhật
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  userUpdate(
                      name.text.trim(), email.text.trim(), phoneNumber.text.trim());
                },
                style: ElevatedButton.styleFrom(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  backgroundColor: Colors.lightBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isloading
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : const Text(
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
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}