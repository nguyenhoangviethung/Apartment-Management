import 'package:flutter/material.dart';
import 'package:frontend/view/home/management/component_management/management_card.dart';



class Management extends StatelessWidget {
  const Management({super.key});
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            ManagementCard(imagelink: 'assets/images/resident.jpg', title: 'Residents Management',),
            SizedBox(height: 20,),
            ManagementCard(imagelink: 'assets/images/fee.jpg', title: 'Fees Management',),
            SizedBox(height: 20,),
            ManagementCard(imagelink: 'assets/images/room.jpg', title: 'Rooms Management',),
            SizedBox(height: 20,),
            ManagementCard(imagelink: 'assets/images/update_role.jpg', title: 'Update Account Role',),
            SizedBox(height: 20,),
            ManagementCard(imagelink: 'assets/images/vehicle.jpg', title: 'Vehicles Management',),
          ],
        ),
      ),
    );

  }
}