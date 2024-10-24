import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/View/Authentication/common/show_dialog.dart';
import 'package:frontend/models/resident_info.dart';
import 'package:frontend/view/home/management/residents_management/component_resident/resident_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../residents_management.dart';
import '../component_resident/add_footer.dart';
import 'package:http/http.dart' as http;

class AddResidents extends StatefulWidget {
  const AddResidents({super.key});

  @override
  State<AddResidents> createState() => _AddResidentsState();
}

class _AddResidentsState extends State<AddResidents> {
  final List<ResidentInfo> items = [];

  Future<bool> addresident(ResidentInfo resident)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tokenlogin= prefs.getString('tokenlogin');
    String url='https://apartment-management-kjj9.onrender.com/admin/validate';
    try {
      final response= await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $tokenlogin',
        },
        body: {
          'full_name': resident.full_name,
          'date_of_birth': resident.date_of_birth,
          'id_number': resident.id_number,
          'room': resident.room.toString(),
          'phone_number': resident.phone_number,
          'status': resident.status,
        },


      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('success');
        return true;
      } else if (response.statusCode == 400) {
        throw Exception('Resident with this name and ID number already exists');
      } else if (response.statusCode == 404) {
        throw Exception('Room doesn\'t exist');
      } else {
        throw Exception('An error occurred: ${response.statusCode}');
      }
    }catch(e){
      print('Error: $e');
      print('123');
      return false;
    }
  }


  void handleAddNewResident(ResidentInfo resident) {
    final newItem = resident;
    setState(() {
      items.add(newItem);
    });
  }

  void handleDeleteActivity(String id) {
    setState(() {
      items.removeWhere((item) => item.id_number == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            'Add Residents',
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 30,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ResidentsManagement()),
                    );
                  },
                );
              }
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.save,
                size: 35,
                color: Colors.white,
              ),
              onPressed: () async{
                bool allSuccessful = true;  // Biến kiểm tra nếu tất cả thêm thành công
                for (var resident in items) {
                  try {
                    // Tạo đối tượng chỉ chứa các trường cần thiết cho API
                    var residentToSend = ResidentInfo.forApi(
                      full_name: resident.full_name,
                      date_of_birth: resident.date_of_birth,
                      id_number: resident.id_number,
                      room: resident.room,
                      phone_number: resident.phone_number,
                      status: resident.status,
                    );

                    bool success = await addresident(residentToSend);
                    if (!success) {
                      allSuccessful = false;  // Cập nhật trạng thái khi có lỗi
                      showinform(context, 'Failed', 'Failed to add resident: ${resident.full_name}');
                      break; // Ngừng thêm nếu có lỗi
                    }
                  } catch (e) {
                    allSuccessful = false;  // Nếu có lỗi, đặt biến này về false
                    break;
                  }
                }
                // Kiểm tra kết quả thêm tất cả residents
                if (allSuccessful) {
                  showinform(context, 'Success', 'All residents were added successfully');
                } else {
                }
              },
            ),
          ],
        ),

        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            vertical: 25,
            horizontal: 30,
          ),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1, // Số cột trong lưới
              childAspectRatio: 3.5, // Tỷ lệ chiều rộng/chiều cao của mỗi card
              mainAxisSpacing: 20.0, // Khoảng cách giữa các hàng
            ),
            itemCount: items.length, // Sử dụng số lượng phần tử thực tế
            itemBuilder: (context, index) {
              return ResidentCard(
                item: items[index],
                onDelete: handleDeleteActivity, // Truyền callback
              ); // Sử dụng items[index] để lấy từng phần tử
            },
            physics: const NeverScrollableScrollPhysics(), // Ngăn không cho GridView cuộn
            shrinkWrap: true, // Giúp GridView tự động điều chỉnh kích thước
          ),

        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return AddFooter(addNewResident: handleAddNewResident,);
              }
            );
          },
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(90),
          ),
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 40,
          ),
        ),
      ),
    );
  }
}