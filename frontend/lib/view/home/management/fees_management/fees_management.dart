import 'package:flutter/material.dart';
import 'package:frontend/view/home/management/fees_management/charity_activities/charity_activities.dart';
import 'package:frontend/view/home/management/fees_management/required_fees/required_fee.dart';
import 'package:intl/intl.dart';

import '../../main_home.dart';
import 'fee_management_component/date_filter.dart';

class FeesManagement extends StatefulWidget {
  const FeesManagement({super.key});

  @override
  State<FeesManagement> createState() => _FeesManagementState();
}

class _FeesManagementState extends State<FeesManagement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Fees Management',
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
                    MaterialPageRoute(builder: (context) => const MainHome(currentIndex: 2,)),
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
              FeesManagementCard(imagelink: 'assets/images/fee.jpg', title: 'Required Fees',),
              SizedBox(height: 20,),
              FeesManagementCard(imagelink: 'assets/images/charity_activities.png', title: 'Charity Activities',),
            ],
          ),
        ),
      ),
    );
  }
}


class FeesManagementCard extends StatelessWidget {
  final String imagelink;
  final String title;
  const FeesManagementCard({super.key, required this.imagelink, required this.title});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: double.infinity,
        height: 160,
        decoration: BoxDecoration(
          color: Colors.lightBlue[100],
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Image.asset(
                  imagelink,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: (){
        if(title=='Required Fees'){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const RequiredFees()));
        }
        if(title=='Charity Activities'){
          // Navigator.push(context, MaterialPageRoute(builder: (context)=>const CharityActivities()));
        }
      },
    );
  }
}



