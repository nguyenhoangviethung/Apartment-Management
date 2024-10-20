import 'package:flutter/material.dart';

class AddFooter extends StatelessWidget {
  AddFooter({super.key, required this.addNewResident});

  final Function addNewResident;

  // Tạo các controller riêng cho mỗi trường nhập liệu
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController roomController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  void handleOnClick() {
    // Lấy giá trị từ tất cả các trường nhập liệu
    final name = nameController.text.trim();
    final dob = dobController.text.trim();
    var id = idController.text.trim();
    final age = int.tryParse(ageController.text.trim())??0;
    final status = statusController.text.trim();
    final room = int.tryParse(roomController.text.trim())??0;
    final phone = phoneController.text.trim();

    if(id == '') {
      id = DateTime.now().toString();
    }

    addNewResident(name, dob, id, age, room, phone,status);

    // Xóa giá trị sau khi thêm
    nameController.clear();
    dobController.clear();
    idController.clear();
    ageController.clear();
    statusController.clear();
    roomController.clear();
    phoneController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350, // Tăng chiều cao nếu cần
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
            _buildTextField('Enter name', nameController),
            const SizedBox(height: 16),
            _buildTextField('Enter date of birth', dobController),
            const SizedBox(height: 16),
            _buildTextField('Enter id number', idController),
            const SizedBox(height: 16),
            _buildTextField('Enter age', ageController),
            const SizedBox(height: 16),
            _buildTextField('Enter status', statusController),
            const SizedBox(height: 16),
            _buildTextField('Enter room', roomController),
            const SizedBox(height: 16),
            _buildTextField('Enter phone number', phoneController),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                handleOnClick();
                FocusScope.of(context).unfocus();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Add',
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
}
//
// import 'package:flutter/material.dart';
//
// class AddFooter extends StatelessWidget {
//   AddFooter({super.key, required this.handleAddNewResident});
//
//   final Function handleAddNewResident;
//
//   // Tạo các controller riêng cho mỗi trường nhập liệu
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController dobController = TextEditingController();
//   final TextEditingController idController = TextEditingController();
//   final TextEditingController ageController = TextEditingController();
//   final TextEditingController statusController = TextEditingController();
//   final TextEditingController roomController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//
//   void handleOnClick() {
//     // Lấy giá trị từ tất cả các trường nhập liệu
//     final name = nameController.text.trim();
//     final dob = dobController.text.trim();
//     var idNumber = idController.text.trim();
//
//     // Chuyển đổi age và room từ chuỗi sang int
//     final age = int.tryParse(ageController.text.trim()) ?? 0;
//     final room = int.tryParse(roomController.text.trim()) ?? 0;
//
//     final phoneNumber = phoneController.text.trim();
//     final status = statusController.text.trim();
//
//     if (idNumber == '') {
//       idNumber = DateTime.now().toString();  // Tạo ID mới nếu không có
//     }
//
//     // Gọi hàm handleAddNewResident với các tham số phù hợp
//     handleAddNewResident(name, dob, idNumber, age, room, phoneNumber, status);
//
//     // Xóa giá trị sau khi thêm
//     nameController.clear();
//     dobController.clear();
//     idController.clear();
//     ageController.clear();
//     statusController.clear();
//     roomController.clear();
//     phoneController.clear();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 350, // Tăng chiều cao nếu cần
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(15),
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.3),
//             blurRadius: 10,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             _buildTextField('Enter name', nameController),
//             const SizedBox(height: 16),
//             _buildTextField('Enter date of birth', dobController),
//             const SizedBox(height: 16),
//             _buildTextField('Enter id number', idController),
//             const SizedBox(height: 16),
//             _buildTextField('Enter age', ageController, isNumeric: true),
//             const SizedBox(height: 16),
//             _buildTextField('Enter status', statusController),
//             const SizedBox(height: 16),
//             _buildTextField('Enter room', roomController, isNumeric: true),
//             const SizedBox(height: 16),
//             _buildTextField('Enter phone number', phoneController, isPhone: true),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 handleOnClick();
//                 FocusScope.of(context).unfocus();
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue,
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//               ),
//               child: const Text(
//                 'Add',
//                 style: TextStyle(
//                   fontFamily: 'Times New Roman',
//                   fontWeight: FontWeight.bold,
//                   fontSize: 20,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField(String label, TextEditingController controller, {bool isNumeric = false, bool isPhone = false}) {
//     return TextField(
//       controller: controller,
//       // Sử dụng keyboardType phù hợp với từng trường hợp
//       keyboardType: isPhone
//           ? TextInputType.phone
//           : (isNumeric ? TextInputType.number : TextInputType.text),
//       decoration: InputDecoration(
//         labelText: label,
//         border: const OutlineInputBorder(),
//         focusedBorder: OutlineInputBorder(
//           borderSide: const BorderSide(color: Colors.blue, width: 2),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderSide: const BorderSide(color: Colors.grey, width: 1),
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//       style: const TextStyle(
//         fontFamily: 'Times New Roman',
//         fontWeight: FontWeight.bold,
//         fontSize: 18,
//       ),
//     );
//   }
// }

