// import 'package:flutter/material.dart';
// import 'package:frontend/models/fee_info.dart';
// import '../common/fee_card.dart';
//
// class CharityActivities extends StatefulWidget {
//   const CharityActivities({super.key});
//
//   @override
//   State<CharityActivities> createState() => _CharityActivitiesState();
// }
//
// class _CharityActivitiesState extends State<CharityActivities> {
//   final FeeInfo item = FeeInfo(
//     room_id: 101,
//     service_charge: '1B USD',
//     manage_charge: '10B USD',
//     fee: 'Ung ho anh Bay mua World cup',
//   );
//
//   final List<FeeInfo> items = [];
//   final PageController _pageController = PageController();
//   final ScrollController _scrollController = ScrollController();
//
//   int _currentPage = 0;
//   final int itemsPerPage = 5; // Số lượng items trên mỗi trang
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Thêm 100 lần giá trị của item vào items
//     for (int i = 0; i < 10; i++) {
//       items.add(FeeInfo(
//         room_id: item.room_id! + i, // tao so phong khac nhau
//         service_charge: item.service_charge,
//         manage_charge: item.manage_charge,
//         fee: item.fee,
//       ));
//     }
//
//     _pageController.addListener(() {
//       setState(() {
//         _currentPage = _pageController.page?.round() ?? 0;
//       });
//
//       // Tính toán vị trí của scroll view để đảm bảo dot màu xanh luôn nằm trong tầm nhìn
//       double offset = 0;
//       if (_currentPage >= 4) offset = (_currentPage * 20.0 - 60.0); // Điều chỉnh giá trị này dựa vào khoảng cách giữa các dot
//       _scrollController.animateTo(
//         offset,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     });
//   }
//
//   void handleDeleteActivity(int id) {
//     setState(() {
//       items.removeWhere((item) => item.room_id == id);
//     });
//   }
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final int pageCount = (items.length / itemsPerPage).ceil(); // Tính tổng số trang
//
//     return Scaffold(
//
//       body: Column(
//         children: [
//           const SizedBox(height: 15),
//           // Nội dung PageView
//           Expanded(
//             child: PageView.builder(
//               controller: _pageController,
//               itemCount: pageCount,
//               itemBuilder: (context, pageIndex) {
//                 final startIndex = pageIndex * itemsPerPage;
//                 final endIndex = (startIndex + itemsPerPage < items.length)
//                     ? startIndex + itemsPerPage
//                     : items.length;
//
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                   child: GridView.builder(
//                     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 1, // Số cột trong lưới
//                       childAspectRatio: 3.5, // Tỷ lệ chiều rộng/chiều cao của mỗi card
//                       mainAxisSpacing: 15.0, // Khoảng cách giữa các hàng
//                     ),
//                     itemCount: endIndex - startIndex, // Số lượng card trên mỗi trang
//                     itemBuilder: (context, index) {
//                       return FeeCard(
//                         item: items[startIndex + index],
//                         onDelete: handleDeleteActivity,
//                       );
//                     },
//                     physics: const NeverScrollableScrollPhysics(), // Ngăn không cho GridView cuộn
//                     shrinkWrap: true,
//                   ),
//                 );
//               },
//             ),
//           ),
//
//           // Dot indicator
//           SizedBox(
//             height: 30,
//             width: 100,
//             child: Center(
//               child: SingleChildScrollView(
//                 controller: _scrollController,
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: List.generate(pageCount, (index) {
//                     return Container(
//                       margin: const EdgeInsets.symmetric(horizontal: 4),
//                       width: 12,
//                       height: 12,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: _currentPage == index ? Colors.blue : Colors.grey,
//                       ),
//                     );
//                   }),
//                 ),
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 12),
//         ],
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:frontend/models/fee_info.dart';
import 'package:frontend/view/home/management/fees_management/required_fees/all_rooms.dart';
import 'package:frontend/view/home/management/fees_management/required_fees/change_details.dart';
import 'package:frontend/view/home/management/fees_management/required_fees/not-paid_rooms.dart';

import '../../../main_home.dart';
import '../common/date_filter.dart';

class CharityActivities extends StatefulWidget {
  const CharityActivities({super.key});

  @override
  State<CharityActivities> createState() => _CharityActivitiesState();
}

class _CharityActivitiesState extends State<CharityActivities> with TickerProviderStateMixin {
  final DateFilterPopup _dateFilterPopup = DateFilterPopup(
    onDateRangeSelected: (start, end) { },
  );

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

  }

  final List<FeeInfo> items = [];
  void handleAddNewFee(int room_id, String service_charge, String manage_charge, String fee) {
    final newItem = FeeInfo(room_id: room_id, service_charge: service_charge, manage_charge: manage_charge,
        fee: fee);
    setState(() {
      items.add(newItem);
    });
  }

  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
            'Required Fees',
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

          bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.white, // Màu văn bản cho tab được chọn
            unselectedLabelColor: Colors.white60,
            tabs: const <Widget>[
              Tab(
                child: Text('All Rooms', style: TextStyle(fontSize: 18 ),),
              ),
              Tab(
                child: Text('Not-pay Rooms', style: TextStyle(fontSize: 18 ),),
              ),
              Tab(
                child: Text('Change Details', style: TextStyle(fontSize: 18 ),),
              ),

            ],
          ),
        ),

        body: TabBarView(
          controller: _tabController,
          children: const <Widget>[
            AllRooms(),
            NotPaidRooms(),
            ChangeDetails(),
          ],
        ),
      ),
    );
  }
}
