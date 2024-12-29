import 'package:flutter/material.dart';
import 'package:frontend/view/home/user/pay.dart';
import 'package:frontend/view/home/user/payment_component/apartment_fee.dart';
import 'package:frontend/view/home/user/payment_component/contribution_fee.dart';
import 'package:frontend/view/home/user/update.dart';

import '../payment_component/electric_water_fee.dart';

class UserComponentCard extends StatelessWidget {
  final String imagelink;
  final String title;
  const UserComponentCard({super.key, required this.imagelink, required this.title});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: double.infinity,
        height: 180,
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
                child: Container(
                  color: Colors.white,
                  child: Image.asset(
                    imagelink,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
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
        if(title=='Thanh toán hóa đơn')
        {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const Pay()));
        }
        if(title=='Cập nhật thông tin')
        {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const Update()));
        }
        if(title=='Phí căn hộ')
        {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const ApartmentFee()));
        }
        if(title=='Phí đóng góp')
        {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const ContributionFee()));
        }
        if(title=='Hóa đơn điện và nước')
        {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const ElectricWaterFee()));
        }
      },
    );
  }
}
