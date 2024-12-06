import 'package:flutter/material.dart';
import 'package:frontend/View/Home/main_home.dart';
import 'package:frontend/common/show_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class Update extends StatefulWidget {
  const Update({super.key});

  @override
  State<Update> createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  DateTime selectedDate = DateTime.now();
  String _dob = '';
  TextEditingController name= TextEditingController();
  TextEditingController email= TextEditingController();
  TextEditingController phoneNumber= TextEditingController();
  bool _isloading =false;
  

  Future<void> userUpdate(String newName,String newEmail, String newNumber)async{
    setState(() {
      _isloading=true;
    });
    try{
      SharedPreferences prefs= await SharedPreferences.getInstance();
      String ?tokenlogin = prefs.getString('tokenlogin');
      const String url='https://apartment-management-kjj9.onrender.com/user/update';
      final response= await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type':'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $tokenlogin',
        },
        body: {
          'new_name':newName,
          'new_email':newEmail,
          'new_number':newNumber
        }
      );
      print(tokenlogin);
      print(response.statusCode);
      if(response.statusCode==200){
        showinform(context, 'Success', 'User info updated successfully');
      }else{
        print('Error: ${response.statusCode}');
        showinform(context, 'Failed', 'Try again');
      }
    }catch(e){
      print('Error: $e');
    }finally{
      setState(() {
        _isloading=false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        leading: IconButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const MainHome(currentIndex: 1,)));
            },
            icon: const Icon(Icons.arrow_back,color: Colors.white,)
        ),
        backgroundColor: Colors.blueAccent,
        title: const Text('Update',style: TextStyle(color: Colors.white,fontSize: 25),),
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
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
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
                      child: const Icon(
                        Icons.camera_alt,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Các trường thông tin
            _buildInfoField(label: 'Name', icon: Icons.person,controller: name),
            _buildInfoField(label: 'Email', icon: Icons.email,controller: email),
            _buildInfoField(label: 'Phone number', icon: Icons.phone,controller: phoneNumber),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     const SizedBox(width: 10),
            //     const Text(
            //       'Date of birth: ',
            //       style: TextStyle(fontSize: 18),
            //     ),
            //     const SizedBox(width: 10),
            //     Expanded(
            //       child: CustomDatePicker(
            //         initialDate: selectedDate,
            //         onDateSelected: (date) {
            //           setState(() {
            //             selectedDate = date; // Cập nhật ngày đã chọn
            //             _dob = DateFormat('yyyy-MM-dd').format(date);
            //           });
            //         },
            //         label: '',
            //       ),
            //     ),
            //   ],
            // ),
            // _buildInfoField(label: 'Age', icon: Icons.person_outline),
            // _buildInfoField(label: 'Avatar', icon: Icons.picture_in_picture),
            // _buildInfoField(label: 'ID Number', icon: Icons.credit_card),
            // _buildInfoField(label: 'Room', icon: Icons.room),

            const SizedBox(height: 20),

            // Nút cập nhật
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  userUpdate(name.text.trim(), email.text.trim(), phoneNumber.text.trim());
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  backgroundColor: Colors.lightBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isloading? const CircularProgressIndicator(color: Colors.white,):
                const Text(
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
