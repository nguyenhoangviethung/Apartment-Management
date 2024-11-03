import 'package:flutter/material.dart';
import 'package:frontend/view/home/management/residents_management/residents_management.dart';
import 'package:frontend/view/home/user/pay.dart';
import 'package:frontend/view/home/user/update.dart';

import '../fees_management/fees_management.dart';

class ManagementCard extends StatelessWidget {
  final String imagelink;
  final String title;
  const ManagementCard({super.key, required this.imagelink, required this.title});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: double.infinity,
        height: 200,
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
        if(title=='Residents Management'){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const ResidentsManagement()));
        }
        if(title=='Fees Management'){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const FeesManagement()));
        }
        if(title=='Payment')
          {Navigator.push(context, MaterialPageRoute(builder: (context)=>const Pay()));

          }
        if(title=='Update')
        {Navigator.push(context, MaterialPageRoute(builder: (context)=>const Update()));

        }
        // if(title=='Rooms Management'){
        //   Navigator.push(context, MaterialPageRoute(builder: (context)=>const RoomsManagement()));
        // }
      },
    );
  }
}
