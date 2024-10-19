import 'package:flutter/material.dart';

import '../common/resident_card.dart';
import '../common/resident_item.dart';
import '../common/resident_dialog.dart';
import '../residents_management.dart';
import 'add_footer.dart';

class AddResidents extends StatefulWidget {
  const AddResidents({super.key});

  @override
  State<AddResidents> createState() => _AddResidentsState();
}

class _AddResidentsState extends State<AddResidents> {
  final List<ResidentItem> items = [];

  void handleAddNewResident(String name, String dob, String idNumber, String age, String status, String room, String phoneNumber) {
    final newItem = ResidentItem(name: name, dob: dob, idNumber: idNumber,
        age: age, status: status, room: room, phoneNumber: phoneNumber);
    setState(() {
      items.add(newItem);
    });
  }

  void handleDeleteActivity(String id) {
    setState(() {
      items.removeWhere((item) => item.idNumber == id);
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
              onPressed: () {
                print('Save button pressed');
                showInform(context, 'Saved', 'Đã lưu thông tin thành công');
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