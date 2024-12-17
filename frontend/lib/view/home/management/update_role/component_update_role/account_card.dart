import 'package:flutter/material.dart';
import 'package:frontend/models/account_info.dart';
import 'package:frontend/services/fetch_accounts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../../../common/show_dialog.dart';
class AccountCard extends StatefulWidget {
  final AccountInfo item;


  const AccountCard({super.key, required this.item,});
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
        showinform(context, 'Success', 'Updated this resident to admin');
        setState(() {
          widget.item.user_role = 'admin'; // Cập nhật trạng thái của user
        });
      }
    }catch(e){
      print('Error');
      showinform(context, 'Failed', 'Cannot update this resident to admin');
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
                    'Update Account to',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.w500, color: Colors.blue),
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow('Name:', widget.item.username?? 'No name provided'),
                      _buildInfoRow('Email:', widget.item.user_email?? 'No name provided'),
                      _buildInfoRow('UserId:', widget.item.user_id.toString()?? 'No date provided'),
                      _buildInfoRow('Phone number:', widget.item.phone_number ?? 'No ID provided'),
                      _buildInfoRow('Role:', widget.item.user_role ?? 'No status provided'),
                    ],
                  ),
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        child: const Center(
                          child: Text("Resident", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue)),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
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
                              widget.item.phone_number ?? 'No phone number',
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

  void showdeleteform(BuildContext context,String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),),
          content: Text(message, style: const TextStyle(fontSize: 18),),
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  child: const Center(
                    child: Text("OK", style: TextStyle(fontSize: 18),),
                  ),
                  onPressed: () {
                    // Navigator.of(context).pop(); // Đóng hộp thoại
                    // if (widget.item.res_id != null) {
                    //   widget.onDelete( widget.item.res_id!);
                    // } else {
                    //   Navigator.of(context).pop();
                    //   showinform(context, 'Error', 'Resident ID is missing.');
                    // }
                  },
                ),
                TextButton(
                  child: const Center(
                    child: Text("Cancel", style: TextStyle(fontSize: 18,color: Colors.red),),
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
