import 'package:flutter/material.dart';
import 'package:frontend/models/resident_info.dart';
import 'package:frontend/view/home/management/residents_management/component_resident/resident_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../common/show_dialog.dart';
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
    String url='https://apartment-management-kjj9.onrender.com/admin/add-resident';
    try {
      final response= await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $tokenlogin',
        },
        body: {
          'resident_name': resident.full_name,
          'date_of_birth': resident.date_of_birth,
          'resident_id': resident.id_number,
          'household_id': resident.room.toString(),
          'phone_number': resident.phone_number,
          'status': resident.status,
        },


      );
      print(response.statusCode);
      if (response.statusCode == 201) {
        return true;
      } else if (response.statusCode == 400) {
        throw Exception('Thiếu trường bắt buộc');
      } else if (response.statusCode == 500) {
        throw Exception('Lỗi không mong muốn');
      } else {
        throw Exception('Đã xảy ra lỗi: ${response.statusCode}');
      }
    }catch(e){
      return false;
    }
  }


  void handleAddNewResident(ResidentInfo resident) {
    final newItem = resident;
    setState(() {
      items.add(newItem);
    });
  }

  void handleDeleteActivity(int resId) {
    setState(() {
      items.removeWhere((item) => item.res_id! == resId);
      Navigator.of(context).pop();
    });
  }

  void handleEditResident(int id, String newName, String newDob, String newStatus, String newPhoneNumber,String newHousehold) {
    setState(() {
      for (var item in items) {
        if (item.id_number == id.toString()) {
          item.full_name = newName;
          item.date_of_birth = newDob;
          item.status = newStatus;
          item.phone_number = newPhoneNumber;
          item.room = int.parse(newHousehold);
          break;
        }
      }
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
            'Thêm cư dân',
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
                bool allSuccessful = true;
                for (var resident in items) {
                  try {
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
                      allSuccessful = false;
                      showinform(context, 'Thất bại', 'Thêm cư dân ${resident.full_name} không thành công');
                      break;
                    }
                  } catch (e) {
                    allSuccessful = false;
                    break;
                  }
                }
                if (allSuccessful) {
                  showinform(context, 'Thành công', 'Tất cả cư dân đã được thêm thành công');
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
                onDelete: handleDeleteActivity,
                onEdit: handleEditResident,// Truyền callback
              );
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