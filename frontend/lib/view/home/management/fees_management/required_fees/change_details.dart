import 'package:flutter/material.dart';

class ChangeDetails extends StatefulWidget {
  const ChangeDetails({super.key});

  @override
  State<ChangeDetails> createState() => _ChangeDetailsState();
}

class _ChangeDetailsState extends State<ChangeDetails> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Column(
          children: [
            Container(
              color: Colors.blue,
              child: const TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white60,
                tabs: [
                  Tab(child: Text('Add', style: TextStyle(fontSize: 15), textAlign:TextAlign.center)),
                  Tab(child: Text('Update', style: TextStyle(fontSize: 15), textAlign:TextAlign.center)),
                  Tab(child: Text('Delete', style: TextStyle(fontSize: 15), textAlign:TextAlign.center)),
                ],
              ),
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  Center(child: Text('Content for Add')),
                  Center(child: Text('Content for Update')),
                  Center(child: Text('Content for Delete')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

