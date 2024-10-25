import 'package:flutter/material.dart';
import 'package:frontend/models/not-paid_room_info.dart';
import 'package:frontend/view/home/management/fees_management/common/not-paid_room_card.dart';

class NotPaidRooms extends StatefulWidget {
  const NotPaidRooms({super.key});

  @override
  State<NotPaidRooms> createState() => _NotPaidRoomsState();
}

class _NotPaidRoomsState extends State<NotPaidRooms> {
  final NotPaidRoomInfo item = NotPaidRoomInfo(
      room_id: 101,
      amount: 10000,
      due_date: '31/12/2024',
      service_fee: 5000,
      manage_fee: 5000,
      fee_type: 'Ung ho anh Bay mua World cup'
  );

  final List<NotPaidRoomInfo> items = [];
  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();

  int _currentPage = 0;
  final int totalDots = 5;

  @override
  void initState() {
    super.initState();

    // Thêm 10 lần giá trị của item vào items
    for (int i = 0; i < 10; i++) {
      items.add(NotPaidRoomInfo(
          room_id: item.room_id! + i, // tao so phong khac nhau
          amount: item.amount,
          due_date: item.due_date,
          service_fee: item.service_fee,
          manage_fee: item.manage_fee,
          fee_type: item.fee_type
      ));
    }

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

  void handleDeleteActivity(int id) {
    setState(() {
      items.removeWhere((item) => item.room_id == id);
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
    final int pageCount = (items.length / itemsPerPage).ceil();

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
                final endIndex = (startIndex + itemsPerPage < items.length)
                    ? startIndex + itemsPerPage
                    : items.length;

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
                        item: items[startIndex + index],
                        onDelete: handleDeleteActivity, // Truyền callback
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

