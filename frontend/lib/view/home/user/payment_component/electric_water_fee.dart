import 'package:flutter/material.dart';
import 'package:frontend/view/home/user/payment_component/water_bill.dart';

import 'electricity_bill.dart';

class ElectricWaterFee extends StatefulWidget {
  const ElectricWaterFee({super.key});

  @override
  State<ElectricWaterFee> createState() => _ElectricWaterFeeState();
}

class _ElectricWaterFeeState extends State<ElectricWaterFee> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Thanh toán hóa đơn tiền điện nước',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(
                text: 'Tiền điện',
                icon: Icon(Icons.electric_bolt),
              ),
              Tab(
                text: 'Tiền nước',
                icon: Icon(Icons.water_drop),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                ElectricityBillScreen(),
                WaterBillScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}