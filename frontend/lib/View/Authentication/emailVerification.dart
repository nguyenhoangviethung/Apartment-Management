import 'package:flutter/material.dart';
import 'resetPassword.dart';
import 'package:http/http.dart' as http;
import 'forgotPassword.dart';

class EmailVerification extends StatefulWidget {
  const EmailVerification({super.key});

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {

  Future<void> confirmEmail(String token) async {
    const String urlBase = 'https://your-api-url.com/confirm_email';

    try {
      final response = await http.get(
        Uri.parse('$urlBase/$token'), // Thêm token vào đường dẫn API
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Email xác nhận thành công
        print('Email confirmation successful');
        // Bạn có thể điều hướng người dùng hoặc hiển thị thông báo thành công
      } else if (response.statusCode == 400) {
        // Token không hợp lệ hoặc đã hết hạn
        print('Invalid or expired token');
        // Hiển thị thông báo lỗi cho người dùng
      }
    } catch (e) {
      print('Error occurred: $e');
      // Xử lý lỗi mạng hoặc các vấn đề khác
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
              // Mã code 4 số
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) {
                  return SizedBox(
                    width: 70,
                    child: TextFormField(
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
              TextButton(
                onPressed: () {
                  // Hành động khi nhấn nút "Resend"
                },
                child: Row(
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ResetPassword()),
                    );
                  },
                  child: const Text(
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
