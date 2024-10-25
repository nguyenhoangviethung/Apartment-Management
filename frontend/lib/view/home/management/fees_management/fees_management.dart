// import 'package:flutter/material.dart';
// import 'package:frontend/models/fee_info.dart';
// import '../../main_home.dart';
// import 'common/date_filter.dart';
// import 'common/fee_add_footer.dart';
// import 'charity_activities/charity_activities.dart';
// import 'required_fee/required_fee.dart';
//
// class FeesManagement extends StatefulWidget {
//   const FeesManagement({super.key});
//
//   @override
//   State<FeesManagement> createState() => _FeesManagementState();
// }
//
// class _FeesManagementState extends State<FeesManagement> with TickerProviderStateMixin {
//   final DateFilterPopup _dateFilterPopup = DateFilterPopup(
//       onDateRangeSelected: (start, end) { },
//   );
//
//   late TabController _tabController;
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//
//   }
//
//   final List<FeeInfo> items = [];
//   void handleAddNewFee(int room_id, String service_charge, String manage_charge, String fee) {
//     final newItem = FeeInfo(room_id: room_id, service_charge: service_charge, manage_charge: manage_charge,
//         fee: fee);
//     setState(() {
//       items.add(newItem);
//     });
//   }
//
//   final TextEditingController _searchController = TextEditingController();
//   bool _isSearching = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return  GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.blue,
//           title: _isSearching
//           ? TextField(
//             controller: _searchController,
//             decoration: const InputDecoration(
//               hintText: 'Tìm kiếm...',
//               border: InputBorder.none,
//               hintStyle: TextStyle(color: Colors.white54, fontSize: 20),
//             ),
//             style: const TextStyle(color: Colors.white, fontSize: 20),
//           )
//           : const Text(
//             'Fees Management',
//             style: TextStyle(
//               fontSize: 25,
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           leading: Builder(
//               builder: (context) {
//                 return IconButton(
//                   icon: const Icon(
//                     Icons.arrow_back,
//                     size: 30,
//                     color: Colors.white,
//                   ),
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => const MainHome(currentIndex: 2,)),
//                     );
//                   },
//                 );
//               }
//           ),
//
//           actions: [
//             IconButton(
//               icon: Icon(
//                 _isSearching ? Icons.close : Icons.search,
//                 size: 30,
//                 color: Colors.white,
//               ),
//               onPressed: () {
//                 setState(() {
//                   _isSearching = !_isSearching; // Chuyển đổi trạng thái tìm kiếm
//                   if (!_isSearching) {
//                     _searchController.clear(); // Xóa nội dung khi thoát tìm kiếm
//                   }
//                 });
//               },
//             ),
//             IconButton(
//               icon: const Icon(
//                 Icons.filter_alt_outlined,
//                 size: 30,
//                 color: Colors.white,
//               ),
//               onPressed: () {
//                 showDialog(
//                   context: context,
//                   builder: (context) => Center(
//                     child: _dateFilterPopup
//                   ),
//                 );
//               },
//             ),
//           ],
//
//           bottom: TabBar(
//             controller: _tabController,
//             labelColor: Colors.white, // Màu văn bản cho tab được chọn
//             unselectedLabelColor: Colors.white60,
//             tabs: const <Widget>[
//               Tab(
//                 child: Text('Required Fees', style: TextStyle(fontSize: 18 ),),
//               ),
//               Tab(
//                 child: Text('Charity Activities', style: TextStyle(fontSize: 18 ),),
//               ),
//
//             ],
//           ),
//         ),
//
//         body: TabBarView(
//           controller: _tabController,
//           children: const <Widget>[
//             RequiredFees(),
//             CharityActivities(),
//           ],
//         ),
//
//         bottomNavigationBar: BottomAppBar(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               FloatingActionButton(
//                 onPressed: () {
//                   // Hành động khi nhấn nút
//                   showModalBottomSheet(
//                       context: context,
//                       builder: (BuildContext context) {
//                         return AddFee(addNewFee: handleAddNewFee,);
//                       }
//                   );
//                 },
//                 backgroundColor: Colors.blue,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(90),
//                 ),
//                 child: const Icon(
//                   Icons.add,
//                   color: Colors.white,
//                   size: 40,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:frontend/view/home/management/fees_management/charity_activities/charity_activities.dart';
import 'package:frontend/view/home/management/fees_management/required_fees/required_fee.dart';

import '../../main_home.dart';
import 'common/date_filter.dart';

class FeesManagement extends StatefulWidget {
  const FeesManagement({super.key});

  @override
  State<FeesManagement> createState() => _FeesManagementState();
}

class _FeesManagementState extends State<FeesManagement> {
  final DateFilterPopup _dateFilterPopup = DateFilterPopup(
    onDateRangeSelected: (start, end) { },
  );
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: _isSearching
            ? TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Tìm kiếm...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white54, fontSize: 20),
          ),
          style: const TextStyle(color: Colors.white, fontSize: 20),
        )
            : const Text(
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

        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching; // Chuyển đổi trạng thái tìm kiếm
                if (!_isSearching) {
                  _searchController.clear(); // Xóa nội dung khi thoát tìm kiếm
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.filter_alt_outlined,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => Center(
                    child: _dateFilterPopup
                ),
              );
            },
          ),
        ],
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              FeesManagementCard(imagelink: 'assets/images/all_rooms.jpeg', title: 'Required Fees',),
              SizedBox(height: 20,),
              FeesManagementCard(imagelink: 'assets/images/fee.jpg', title: 'Charity Activities',),
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
        if(title=='Required Fees'){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const RequiredFees()));
        }
        if(title=='Charity Activities'){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const CharityActivities()));
        }
      },
    );
  }
}



