import 'package:flutter/material.dart';
import '../common/fee_card.dart';
import '../common/fee_item.dart';

class CharityActivities extends StatefulWidget {
  const CharityActivities({super.key});

  @override
  State<CharityActivities> createState() => _CharityActivitiesState();
}

class _CharityActivitiesState extends State<CharityActivities> {
  final FeeItem item = const FeeItem(
    name: 'Ung ho anh Bay mua World cup',
    fee: '1B USD',
    id: '1',
    startDate: '10/04/2004',
    endDate: '10/04/2025',
  );

  final List<FeeItem> items = [];
  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();

  int _currentPage = 0;
  final int itemsPerPage = 5; // Số lượng items trên mỗi trang

  @override
  void initState() {
    super.initState();

    // Thêm 100 lần giá trị của item vào items
    for (int i = 0; i < 10; i++) {
      items.add(FeeItem(
        name: '${item.name} $i', // Thêm số thứ tự vào tên để phân biệt
        fee: item.fee,
        id: '${int.parse(item.id) + i}', // Tạo ID khác nhau
        startDate: item.startDate,
        endDate: item.endDate,
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
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  void handleDeleteActivity(String id) {
    setState(() {
      items.removeWhere((item) => item.id == id);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int pageCount = (items.length / itemsPerPage).ceil(); // Tính tổng số trang

    return Column(
      children: [
        const SizedBox(height: 15),
        // Nội dung PageView
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
                    childAspectRatio: 3.5, // Tỷ lệ chiều rộng/chiều cao của mỗi card
                    mainAxisSpacing: 15.0, // Khoảng cách giữa các hàng
                  ),
                  itemCount: endIndex - startIndex, // Số lượng card trên mỗi trang
                  itemBuilder: (context, index) {
                    return FeeCard(
                      item: items[startIndex + index],
                      onDelete: handleDeleteActivity,
                    );
                  },
                  physics: const NeverScrollableScrollPhysics(), // Ngăn không cho GridView cuộn
                  shrinkWrap: true,
                ),
              );
            },
          ),
        ),

        // Dot indicator
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

        const SizedBox(height: 12),
      ],
    );
  }
}
