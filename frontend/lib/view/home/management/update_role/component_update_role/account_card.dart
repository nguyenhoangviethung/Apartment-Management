import 'package:flutter/material.dart';
import 'package:frontend/models/account_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../../../common/show_dialog.dart';
class AccountCard extends StatefulWidget {
  final AccountInfo item;
  final int numOfRes;

  const AccountCard({super.key, required this.item, required this.numOfRes,});
  @override
  State<AccountCard> createState() => _AccountCardState();
}

class _AccountCardState extends State<AccountCard> {
  bool _isloading = false;
  Future<void> updateResidentToAdmin() async{
    setState(() {
      _isloading=true;
    });
    final url = 'https://apartment-management-kjj9.onrender.com/admin/give-admin-authority/${widget.item.user_id}';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ?tokenlogin = prefs.getString('tokenlogin');
    try{
      final response = await http.post(
          Uri.parse(url),
          headers: {
            'Authorization':'Bearer ${tokenlogin}'
          }
      );
      print(response.body);
      if(response.statusCode==200){
        showinform(context, 'Thành công', 'Đã cập nhật người dùng này thành quản trị viên');
        setState(() {
          widget.item.user_role = 'admin'; // Cập nhật trạng thái của user
        });
      }
    }catch(e){
      print('Error');
      showinform(context, 'Thất bại', 'Không thể cập nhật cư dân này thành quản trị viên');
    }finally{
      _isloading=false;
    }
  }
  Future<void> updateUserToResident(int resId) async{
    setState(() {
      _isloading=true;
    });
    final url = 'https://apartment-management-kjj9.onrender.com/admin/user-to-res/$resId';
    print('${url}');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ?tokenlogin = prefs.getString('tokenlogin');
    print(widget.item.user_id.toString());
    try{
      final response = await http.post(
          Uri.parse(url),
          headers: {
            'Authorization':'Bearer ${tokenlogin}'
          },
          body: {
            'user_id' : widget.item.user_id.toString()
          }
      );
      print(response.body);
      if(response.statusCode==200){
        showinform(context, 'Thành công', 'Đã cập nhật người dùng này thành cư dân');
      }else{
        showinform(context, 'Thất bại', 'Cư dân này đã là người dùng');
      }
    }catch(e){
      print('Error: $e');
      showinform(context, 'Thất bại', 'Không thể cập nhật người dùng này thành cư dân');
    }finally{
      _isloading=false;
    }
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context){
              return AlertDialog(
                title: const Center(
                  child: Text(
                    'Cập nhật tài khoản thành',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.w500, color: Colors.blue),
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow('Tên:', widget.item.username?? 'Không được cung cấp'),
                      _buildInfoRow('Email:', widget.item.user_email?? 'Không được cung cấp'),
                      _buildInfoRow('UserId:', widget.item.user_id?.toString()?? 'Không được cung cấp'),
                      _buildInfoRow('Số điện thoại:', widget.item.phone_number ?? 'Không được cung cấp'),
                      _buildInfoRow('Vai trò:', widget.item.user_role ?? 'Không được cung cấp'),
                    ],
                  ),
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        child: const Center(
                          child: Text("Cư dân", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue)),
                        ),
                        onPressed: () async{
                          Navigator.of(context).pop();
                          showInputForm();
                        },
                      ),
                      TextButton(
                        child: _isloading? const CircularProgressIndicator(color: Colors.white,) :
                        const Center(
                          child: Text("Admin", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                        ),
                        onPressed: () async{
                          Navigator.of(context).pop();
                          await updateResidentToAdmin();
                        },
                      ),
                    ],
                  ),
                ],
              );
            }
        );
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.person_pin_outlined, color: Colors.blue[500]!, size: 45,),
                      const SizedBox(width: 8),
                      Text(
                        widget.item.username!,
                        style: const TextStyle(fontSize: 24, color: Colors.black87, fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(Icons.verified_user, color: Colors.grey[600]!, size: 25,), // Biểu tượng 2
                          const SizedBox(width: 10),
                          Text(
                            widget.item.user_role.toString(),
                            style: const TextStyle(fontSize: 17, color: Colors.black87),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Row(
                        children: [
                          Icon(Icons.call_outlined, color: Colors.grey[600]!, size: 25),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              widget.item.phone_number ?? 'Không được cung cấp',
                              style: const TextStyle(fontSize: 17, color: Colors.black87),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black54),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }

  void showInputForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController residentIdController = TextEditingController();
        return AlertDialog(
          title: const Text(
            'Nhập ID cư dân',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          content: TextField(
            controller: residentIdController,
            decoration: const InputDecoration(
              labelText: 'ID cư dân',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  child: const Text(
                    "OK",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    String residentId = residentIdController.text.trim();
                    if (residentId.isEmpty) {
                      showinform(
                          context, 'Lỗi', 'ID cư dân không được để trống.');
                      return;
                    }else{
                      await updateUserToResident(int.parse(residentId));
                    }
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text(
                    "Hủy bỏ",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}