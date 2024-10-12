import 'package:flutter/material.dart';
import 'package:frontend/View/Authentication/common/show_dialog.dart';
import 'reset_password.dart';
import 'package:http/http.dart' as http;
import 'forgot_password.dart';

class EmailVerification extends StatefulWidget {
  const EmailVerification({super.key});

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  bool  _isload = false;
  List<TextEditingController> controllers= List.generate(4, (index)=>TextEditingController());

  Future<void> validationcode(String code) async{
    setState(() {
      _isload=true;
    });
    if(code.isEmpty){
      setState(() {
        _isload=false;
      });
      showinform(context, 'Error', 'Please fill the code');
      return;
    }
    String url='https://apartment-management-kjj9.onrender.com/auth/validation-code';
    try{
      final response= await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'code':code
        }
      );
      setState(() {
        _isload=false;
      });
      print(response.statusCode);
      if(response.statusCode==200){
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ResetPassword()));
      }else if(response.statusCode==400){
        showinform(context, 'Error', 'Invalid code');
      }
    }catch(e){
      print('Error occurred:  $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFF6F6FA), // Màu nền của toàn bộ màn hình
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            'Email Verification',
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
                    MaterialPageRoute(builder: (context) => const ForgotPassword()),
                  );
                },
              );
            }
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Text(
                'Get Your Code',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[600],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Please enter the 4 digit code that was sent to your email address.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) {
                  return SizedBox(
                    width: 70,
                    child: TextFormField(
                      controller: controllers[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        counterText: '', // Loại bỏ bộ đếm ký tự
                        border: const OutlineInputBorder(),
                        fillColor: Colors.blue[50],
                        filled: true,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'If you don\'t recieve code: ',
                    style: TextStyle(fontSize: 18, color: Colors.black45),
                  ),
                  Builder(
                      builder: (context) {
                        return GestureDetector(
                          child: const Text(
                            "Resend",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.blue,
                            ),
                          ),
                          onTap: (){

                          },
                        );
                      }
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // Nút "Verify and Proceed"
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    String _code='';
                    for(var controller in controllers){
                      _code+= controller.text;
                    }
                    print('Code: $_code');
                    validationcode(_code);
                  },
                  child: _isload? const CircularProgressIndicator(color: Colors.white,): const Text(
                    'Verify and Proceed',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
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
