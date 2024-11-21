// import 'package:flutter/material.dart';
// import 'package:frontend/models/fee_required_info.dart';
// import 'package:frontend/view/home/management/fees_management/required_fees/all_rooms.dart';
// import 'package:frontend/view/home/management/fees_management/required_fees/change_details.dart';
// import 'package:frontend/view/home/management/fees_management/required_fees/not-paid_rooms.dart';
//
// import '../../../main_home.dart';
// import '../common/date_filter.dart';
//
// class CharityActivities extends StatefulWidget {
//   const CharityActivities({super.key});
//
//   @override
//   State<CharityActivities> createState() => _CharityActivitiesState();
// }
//
// class _CharityActivitiesState extends State<CharityActivities> with TickerProviderStateMixin {
//   final DateFilterPopup _dateFilterPopup = DateFilterPopup(
//     onDateRangeSelected: (start, end) { },
//   );
//
//   late TabController _tabController;
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
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
//               ? TextField(
//             controller: _searchController,
//             decoration: const InputDecoration(
//               hintText: 'Tìm kiếm...',
//               border: InputBorder.none,
//               hintStyle: TextStyle(color: Colors.white54, fontSize: 20),
//             ),
//             style: const TextStyle(color: Colors.white, fontSize: 20),
//           )
//               : const Text(
//             'Charity Activities',
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
//                       child: _dateFilterPopup
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
//                 child: Text('All Rooms', style: TextStyle(fontSize: 18 ),),
//               ),
//               Tab(
//                 child: Text('Not-pay Rooms', style: TextStyle(fontSize: 18 ),),
//               ),
//               Tab(
//                 child: Text('Change Details', style: TextStyle(fontSize: 18 ),),
//               ),
//
//             ],
//           ),
//         ),
//
//         body: TabBarView(
//           controller: _tabController,
//           children: const <Widget>[
//             AllRooms(),
//             NotPaidRooms(),
//             ChangeDetails(),
//           ],
//         ),
//       ),
//     );
//   }
// }