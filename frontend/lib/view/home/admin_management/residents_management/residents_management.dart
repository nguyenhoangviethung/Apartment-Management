import 'package:flutter/material.dart';
import 'package:frontend/View/Home/main_home.dart';
import 'package:frontend/view/home/admin_management/residents_management/common/resident_card.dart';

class ResidentsManagement extends StatefulWidget {
  const ResidentsManagement({super.key});

  @override
  State<ResidentsManagement> createState() => _ResidentsManagementState();
}

class _ResidentsManagementState extends State<ResidentsManagement> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: const Text(
              'Residents Management',
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
                        MaterialPageRoute(builder: (context) => const HomePage()),
                      );
                    },
                  );
                }
            ),
          ),

          body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.black),
                            decoration: InputDecoration(
                              hintText: 'Search',
                              hintStyle: const TextStyle(color: Colors.black54,fontSize: 20),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.search, color: Colors.blue, size: 35),
                                onPressed: () {
                                  print('Button Search pressed!');
                                },
                              ),

                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0), // Góc bo tròn
                                borderSide: const BorderSide(
                                  color: Colors.blue,
                                  width: 2.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: Colors.blue[200]!, // Màu của đường viền khi được chọn
                                  width: 2.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  color: Colors.grey, // Màu của đường viền khi không được chọn
                                  width: 2.0,
                                ),
                              ),
                            ),

                          ),
                        ),
                        const SizedBox(
                            width: 10,
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle, // Đặt hình dạng là hình tròn
                            color: Colors.blue, // Màu nền của hình tròn
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.add, color: Colors.white, size: 35),
                            onPressed: () {
                              print('Button Add pressed!');
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20), // Khoảng cách giữa hàng tìm kiếm và lưới
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1, // Số cột trong lưới
                          childAspectRatio: 3.5, // Tỷ lệ chiều rộng/chiều cao của mỗi card
                          mainAxisSpacing: 20.0, // Khoảng cách giữa các hàng
                        ),
                        itemCount: 10, // Số lượng card
                        itemBuilder: (context, index) {
                          return const ResidentCard(name: 'Do Xuan Chien', room: 'vip-909', phoneNumber: '0999999999',
                            dob: '10/04/2004', age: '20', status: 'Single', idNumber: '102',);
                        },
                        physics: const NeverScrollableScrollPhysics(), // Ngăn không cho GridView cuộn
                        shrinkWrap: true, // Giúp GridView tự động điều chỉnh kích thước
                      ),
                    ),
                  ],
                ),
            ),
          ),
        ),
      ),
    );
  }
}