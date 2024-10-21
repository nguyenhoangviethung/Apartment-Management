import 'package:flutter/material.dart';
import 'package:frontend/View/Authentication/common/show_dialog.dart';
import 'package:frontend/models/resident_info.dart';

import '../common/resident_card.dart';
import '../residents_management.dart';
import 'add_footer.dart';
import 'package:http/http.dart' as http;

class AddResidents extends StatefulWidget {
  const AddResidents({super.key});

  @override
  State<AddResidents> createState() => _AddResidentsState();
}

class _AddResidentsState extends State<AddResidents> {
  final List<ResidentInfo> items = [];

  // full_name
  // string
  // Full name of the resident.
  //
  // date_of_birth
  // string($date)
  // Date of birth of the resident.
  //
  // id_number
  // string
  // Identification number of the resident.
  //
  // status
  // string
  // Current status of the resident (e.g., active, inactive).
  //
  // room
  // integer
  // Room number assigned to the resident.
  //
  // phone_number
  // string
  // Phone number of the resident.
  Future<void> addresident(String full_name, String date_of_birth, String id_number,String status,int room, String phone_number)async{
    String url='https://apartment-management-kjj9.onrender.com/admin/validate';
    try {
      final response= await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'full_name':full_name,
          'date_of_birth':date_of_birth,
          'id_number':id_number,
          'status': status,
          'room':room,
          'phone_number':phone_number,
        }

      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        return;
      } else if (response.statusCode == 400) {
        throw Exception('Resident with this name and ID number already exists');
      } else if (response.statusCode == 404) {
        throw Exception('Room doesn\'t exist');
      } else {
        throw Exception('An error occurred: ${response.statusCode}');
      }
    }catch(e){
      print('Error: $e');
    }
  }


  void handleAddNewResident(String name, String dob, String idNumber, int age,int room,String phoneNumber, String status) {
    final newItem = ResidentInfo(full_name: name, date_of_birth: dob, id_number: idNumber,
        age: age, room: room, phone_number: phoneNumber,status: status);
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

                // for (var resident in items) {
                //   try {
                //     // Tạo ra một bản sao của resident nhưng chỉ giữ lại các trường cần thiết
                //     var residentToSend = ResidentInfo(
                //       full_name: resident.full_name,
                //       date_of_birth: resident.date_of_birth,
                //       id_number: resident.id_number,
                //       room: resident.room,
                //       phone_number: resident.phone_number,
                //       status: resident.status,
                //       // Không bao gồm trường 'age'
                //     );
                //
                //     await addresident(residentToSend);
                //   } catch (e) {
                //     allSuccessful = false;  // Nếu có lỗi, đặt biến này về false
                //     showinform(context, 'Failed', 'An error occurred while adding a resident: $e');
                //     break;
                //   }
                // }


                // Kiểm tra kết quả thêm tất cả residents
                if (allSuccessful) {
                  showinform(context, 'Success', 'All residents were added successfully');
                } else {
                  showinform(context, 'Failed', 'Some residents could not be added');
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