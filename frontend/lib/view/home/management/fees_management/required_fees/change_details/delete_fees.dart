import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../Authentication/common/show_dialog.dart';
class Delete extends StatefulWidget {
  const Delete({super.key});

  @override
  State<Delete> createState() => _DeleteState();
}

class _DeleteState extends State<Delete> {
  final TextEditingController descriptionController = TextEditingController();
  bool _isload=false;

  void handleOnClick() async {
    final description = descriptionController.text.trim();
    const url = 'https://apartment-management-kjj9.onrender.com/admin/delete-fee';
    setState(() {
      _isload=true;
    });
    try {
      SharedPreferences prefs= await SharedPreferences.getInstance();
      String? tokenlogin = prefs.getString('tokenlogin');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $tokenlogin',
        },
        body: {
          'description': description,
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        showinform(context, 'Success', 'Delete Successful');
      } else {
        if(response.statusCode==400){
          showinform(context, 'Failed', 'Description not provided');
        }else{
          showinform(context, 'Failed', 'No fees found with the given description');
        }
      }
    } catch (e) {
      print('Error: $e');
      showinform(context, 'Error', 'An error occurred. Please try again.');
    } finally {
      setState(() {
        _isload = false;
      });
      descriptionController.clear();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: 320, // Tăng chiều cao nếu cần
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
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
                            const SizedBox(height: 15),
                            _buildTextField('Enter description',
                                descriptionController),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                handleOnClick();
                                FocusScope.of(context).unfocus();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child:_isload?CircularProgressIndicator(color: Colors.white): const Text(
                                'Update',
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
              );
            },
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(90),
            ),
            child: const Icon(
                Icons.delete_outline,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
      ],
    );
  }
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
