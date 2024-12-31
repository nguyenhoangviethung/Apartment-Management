import 'package:flutter/material.dart';
import 'package:frontend/view/home/management/fees_management/parking_fee/change_details/add_parking_fee.dart';
import 'package:frontend/view/home/management/fees_management/parking_fee/change_details/delete_parking_fee.dart';

class ChangeDetails extends StatefulWidget {
  const ChangeDetails({super.key});

  @override
  State<ChangeDetails> createState() => _ChangeDetailsState();
}

class _ChangeDetailsState extends State<ChangeDetails> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
          children: [
            Container(
              color: Colors.blue,
              child: const TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white60,
                tabs: [
                  Tab(child: Text('Thêm', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), textAlign:TextAlign.center)),
                  Tab(child: Text('Xóa', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), textAlign:TextAlign.center)),
                ],
              ),
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  AddParkingFee(),
                  DeleteParkingFee(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

