import 'package:flutter/material.dart';
import 'package:frontend/view/home/management/residents_management/residents_management.dart';
import 'package:frontend/view/home/management/update_role/update_role.dart';
import '../fees_management/fees_management.dart';
import '../rooms_management/rooms_management.dart';
import '../vehicles_management/vehicles_management.dart';


class ManagementCard extends StatelessWidget {
  final String imagelink;
  final String title;
  const ManagementCard({super.key, required this.imagelink, required this.title});
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
        if(title=='Quản lý cư dân'){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const ResidentsManagement()));
        }
        if(title=='Quản lý phí'){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const FeesManagement()));
        }
        if(title=='Quản lý phòng'){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const RoomsManagement()));
        }
        if(title=='Cập nhật vai trò tài khoản'){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const UpdateRole()));
        }
        if(title=='Quản lý phương tiện'){
           Navigator.push(context, MaterialPageRoute(builder: (context)=>const VehiclesManagement()));
        }
      },
    );
  }
}
