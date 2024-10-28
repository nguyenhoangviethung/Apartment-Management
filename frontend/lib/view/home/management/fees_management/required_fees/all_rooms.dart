import 'package:flutter/material.dart';
import 'package:frontend/services/fetch_required_fees.dart';
import '../../../../../models/fee_required_info.dart';
import '../fee_management_component/fee_card.dart';

class AllRooms extends StatefulWidget {
  const AllRooms({super.key});

  @override
  State<AllRooms> createState() => _AllRoomsState();
}

class _AllRoomsState extends State<AllRooms> {
  late Future<FeeResponse?> futureFees;

  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();

  int _currentPage = 0;
  final int totalDots = 5;
  List<FeeInfo> _fees = [];
  List<FeeInfo> _allFees = [];

  @override
  void initState() {
    super.initState();
    futureFees = fetchRequiredFees();
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
    const int itemsPerPage = 5;

    return FutureBuilder<FeeResponse?>(
      future: futureFees,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data!.fees != null) {
          FeeResponse feeResponse = snapshot.data!;
          _fees = feeResponse.fees!;
          _allFees = feeResponse.fees!;
          int pageCount = (_fees.length / itemsPerPage).ceil();

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                const SizedBox(height: 15),

                // Search input
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
                  onChanged: (text) {
                    setState(() {
                      _fees = _allFees.where((feeinfo) {
                        var roomWord = feeinfo.room!;
                        return roomWord.contains(text);
                      }).toList();

                      // In ra danh sách filtered fees sau khi đã lọc
                      print('Filtered fees: ${_fees.map((fee) => 'Room: ${fee.room}, Amount: ${fee.fee}').toList()}');
                    });
                  },

                ),

                const SizedBox(height: 15),

                // Danh sách các phòng
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: pageCount,
                    itemBuilder: (context, pageIndex) {
                      final startIndex = pageIndex * itemsPerPage;
                      final endIndex = (startIndex + itemsPerPage < _fees.length)
                          ? startIndex + itemsPerPage
                          : _fees.length;

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
                            return FeeCard(
                              item: _fees[startIndex + index], // Chọn khoản phí cụ thể cho trang này
                              feeResponse: feeResponse,
                            );
                          },
                          physics: const NeverScrollableScrollPhysics(), // Ngăn không cho GridView cuộn
                          shrinkWrap: true, // Giúp GridView tự động điều chỉnh kích thước
                        ),
                      );
                    },
                  ),
                ),

                // Các dot chuyển trang
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
        } else {
          return const Center(child: Text('No fees available'));
        }
      },
    );
  }
}
