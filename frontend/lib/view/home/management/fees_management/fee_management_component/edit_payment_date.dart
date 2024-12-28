import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../../../common/custom_date_picker.dart';


class EditPaymentDate extends StatefulWidget {
  final dynamic it;
  final String typeFee;
  const EditPaymentDate({super.key, required this.it, required this.typeFee});

  @override
  State<EditPaymentDate> createState() => _EditPaymentDateState();
}

class _EditPaymentDateState extends State<EditPaymentDate> {

  DateTime selectedDate = DateTime.now();
  String _dob = '';
  bool isloading=false;
  Future<void> editPayDate ()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tokelogin = prefs.getString('tokenlogin');
    print(_dob);
    setState(() {
      isloading=true;
    });
    final String url = widget.typeFee=='required'?
    'https://apartment-management-kjj9.onrender.com/admin/101/${widget.it.fee_id}/update-status-fee':
    'https://apartment-management-kjj9.onrender.com/admin/${widget.it.fee_id}/$_dob/update-status-park-fee';
    print(url);
    try{
      final reponse = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization' : 'Bearer $tokelogin'
        }
      );
      print(reponse.body);
      print(reponse.statusCode);

    }catch(e){
      print('Error: $e');
    }finally{
      setState(() {
        isloading=false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
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
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              const Text('Update payment date'),
              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 10),
                  const Text(
                    'Date of paying: ',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomDatePicker(
                      initialDate: selectedDate,
                      onDateSelected: (date) {
                        setState(() {
                          selectedDate = date; // Cập nhật ngày đã chọn
                          _dob = DateFormat('yyyy-MM-dd').format(date); // Cập nhật biến _dob
                        });
                      },
                      label: '',
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  editPayDate();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: isloading? const CircularProgressIndicator(color: Colors.white,):
                const Text(
                  'Save',
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
      ),
    );
  }


}

