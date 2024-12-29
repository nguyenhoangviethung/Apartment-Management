import 'package:flutter/material.dart';
import 'package:frontend/view/home/user/user_component/user_component_card.dart';

import '../main_home.dart';

class Pay extends StatelessWidget {
  const Pay({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Thanh toán hóa đơn',
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
                    MaterialPageRoute(builder: (context) => const MainHome(currentIndex: 1,)),
                  );
                },
              );
            }
        ),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              UserComponentCard(
                imagelink: 'assets/images/fee.jpg',
                title: 'Phí căn hộ',
              ),
              SizedBox(
                height: 20,
              ),
              UserComponentCard(
                imagelink: 'assets/images/charity_activities.png',
                title: 'Phí đóng góp',
              ),
              SizedBox(
                height: 20,
              ),
              UserComponentCard(
                imagelink: 'assets/images/electric_water_bill.jpg',
                title: 'Hóa đơn điện và nước',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
