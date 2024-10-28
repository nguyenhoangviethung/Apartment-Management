import 'package:flutter/material.dart';
import 'package:frontend/models/not-paid_room_info.dart';
import 'package:frontend/services/fetch_not_paid.dart';

import '../fee_management_component/not-paid_room_card.dart';

class NotPaidRooms extends StatefulWidget {
  const NotPaidRooms({super.key});

  @override
  State<NotPaidRooms> createState() => _NotPaidRoomsState();
}

class _NotPaidRoomsState extends State<NotPaidRooms> {

  List<NotPaidRoomInfo> _notpaidrooms = [];
  List<NotPaidRoomInfo> _allnotpaidrooms = [];
  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();

  int _currentPage = 0;
  final int totalDots = 5;

  @override
  void initState() {
    super.initState();

    fetchNotPaid().then((value){
      setState(() {
        _notpaidrooms=value;
        _allnotpaidrooms=value;
      });
    });
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });

      // Tính toán vị trí của scroll view để đảm bảo dot màu xanh luôn nằm trong tầm nhìn
      double offset = 0;
      if (_currentPage >= 4) offset = (_currentPage * 20.0 - 60.0); // Điều chỉnh giá trị này dựa vào khoảng cách giữa các dot
      _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // Số lượng item trên mỗi trang
    final int itemsPerPage = 5;
    final int pageCount = (_notpaidrooms.length / itemsPerPage).ceil();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          const SizedBox(height: 15),

          TextFormField(
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
            decoration: InputDecoration(
              hintText: 'Search',
              hintStyle: const TextStyle(color: Colors.black54, fontSize: 20),
              suffixIcon: const Icon(Icons.search, color: Colors.blue, size: 35),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(
                  color: Colors.blue,
                  width: 2.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: Colors.blue[200]!,
                  width: 2.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 2.0,
                ),
              ),
            ),
            onChanged: (text){
              setState(() {
                text=text.toLowerCase();
                _notpaidrooms=_allnotpaidrooms.where((notpaidroominfo){
                  var roomword= notpaidroominfo.room!;
                  return roomword.contains(text);
                }).toList();
              });
            },
          ),

          const SizedBox(height: 15),

          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: pageCount,
              itemBuilder: (context, pageIndex) {
                final startIndex = pageIndex * itemsPerPage;
                final endIndex = (startIndex + itemsPerPage < _notpaidrooms.length)
                    ? startIndex + itemsPerPage
                    : _notpaidrooms.length;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1, // Số cột trong lưới
                      childAspectRatio: 3.2, // Tỷ lệ chiều rộng/chiều cao của mỗi card
                      mainAxisSpacing: 15.0, // Khoảng cách giữa các hàng
                    ),
                    itemCount: endIndex - startIndex, // Chỉ hiển thị số lượng card trên trang
                    itemBuilder: (context, index) {
                      return NotPaidRoomCard(
                        item: _notpaidrooms[startIndex + index],
                      );
                    },
                    physics: const NeverScrollableScrollPhysics(), // Ngăn không cho GridView cuộn
                    shrinkWrap: true, // Giúp GridView tự động điều chỉnh kích thước
                  ),
                );
              },
            ),
          ),

          SizedBox(
            height: 30,
            width: 100,
            child: Center(
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(pageCount, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == index ? Colors.blue : Colors.grey,
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),

          const SizedBox(height: 15),
        ],
      ),
    );
  }
}

