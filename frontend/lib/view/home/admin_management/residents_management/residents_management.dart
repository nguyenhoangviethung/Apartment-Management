import 'package:flutter/material.dart';
import 'package:frontend/View/Home/main_home.dart';

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

          body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
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
                ],
              ),
          ),
        ),
      ),
    );
  }
}