import 'package:flutter/material.dart';
import 'package:frontend/View/Authentication/login.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool isLoading = true;
  Map<String, dynamic> userData = {};
  final String apiUrl = "https://apartment-management-kjj9.onrender.com/admin/residents";

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('tokenlogin') ?? '';

      print('Token: $token'); // In token để debug

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          Map<String, dynamic> jsonResponse = json.decode(response.body);
          List<dynamic> residentInfo = jsonResponse['resident_info'];

          if (residentInfo.isNotEmpty) {
            setState(() {
              userData = residentInfo[0];
              isLoading = false;
            });
          } else {
            throw Exception('No data found');
          }
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

  Future<void> handleLogout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('tokenlogin');

      if (mounted) {
        ScaffoldMessenger.of(context).showMaterialBanner(
          MaterialBanner(
            content: Center(
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
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showMaterialBanner(
          MaterialBanner(
            content: Text('Error logout: ${e.toString()}'),
            backgroundColor: Colors.red,
            actions: [
              TextButton(
                child: Text('Close'),
                onPressed: () => ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
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
      appBar: AppBar(
        // title: const Text(
        //   'Account',
        //   style: TextStyle(color: Colors.white),
        // ),
         backgroundColor: Colors.lightBlue,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                 color: Colors.lightBlue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Text(
                      (userData['full_name'] ?? 'U')[0].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
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
                    Icons.cake,
                    'Age',
                    userData['age']?.toString() ?? 'Not provided',
                  ),
                  _buildInfoItem(
                    Icons.calendar_today,
                    'Date of Birth',
                    userData['date_of_birth'] ?? 'Not provided',
                  ),
                  _buildInfoItem(
                    Icons.account_box,
                    'ID Number',
                    userData['id_number'] ?? 'Not provided',
                  ),
                  _buildInfoItem(
                    Icons.room,
                    'Room',
                    userData['room']?.toString() ?? 'Not provided',
                  ),
                  _buildInfoItem(
                    Icons.check_circle,
                    'Status',
                    userData['status'] ?? 'Not provided',
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