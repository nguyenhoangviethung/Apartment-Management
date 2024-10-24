import 'package:flutter/material.dart';
import 'package:frontend/view/home/management/fees_management/required_fee/all_rooms.dart';

class RequiredFees extends StatefulWidget {
  const RequiredFees({super.key});

  @override
  State<RequiredFees> createState() => _RequiredFeesState();
}

class _RequiredFeesState extends State<RequiredFees> {
  @override
  Widget build(BuildContext context) {

    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            FeesManagementCard(imagelink: 'assets/images/all_rooms.jpeg', title: 'All rooms',),
            SizedBox(height: 20,),
            FeesManagementCard(imagelink: 'assets/images/fee.jpg', title: 'Not-pay rooms',),
            SizedBox(height: 20,),
            FeesManagementCard(imagelink: 'assets/images/change_detail.webp', title: 'Change detail',),
          ],
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
                  padding: EdgeInsets.all(12.0),
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
        if(title=='All rooms'){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const AllRooms()));
        }
        if(title=='Not-pay rooms'){
          // Navigator.push(context, MaterialPageRoute(builder: (context)=>const FeesManagement()));
        }
        if(title=='Change detail'){
          // Navigator.push(context, MaterialPageRoute(builder: (context)=>const RoomsManagement()));
        }
      },
    );
  }
}


