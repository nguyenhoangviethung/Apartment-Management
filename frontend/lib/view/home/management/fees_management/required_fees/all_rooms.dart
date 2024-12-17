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

  List<ParkingFeeInfo> _originalFees = []; // Danh sách gốc
  List<ParkingFeeInfo> _displayedFees = []; // Danh sách hiển thị
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int totalDots = 5;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    futureFees = fetchRequiredFees().then((response) {
      if (response != null && response.fees != null) {
        setState(() {
          _originalFees = response.fees!;
          _displayedFees = _originalFees;
        });
      }
      return response;
    });
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });

      // Tính toán vị trí của scroll view để đảm bảo dot màu xanh luôn nằm trong tầm nhìn
      double offset = 0;
      if (_currentPage >= 4) {
        offset = (_currentPage * 20.0 - 60.0); // Điều chỉnh giá trị này dựa vào khoảng cách giữa các dot
      }
      _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
      );
    });
  }

  // Hàm tìm kiếm mới
  void _filterFees(String query) {
    setState(() {
      if (query.isEmpty) {
        _displayedFees = _originalFees;
      } else {
        _displayedFees = _originalFees.where((feeInfo) {
          return (feeInfo.room?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
              (feeInfo.fee?.toString().contains(query) ?? false);
        }).toList();
      }
      _pageController.jumpToPage(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    const int itemsPerPage = 5;
    int pageCount = (_displayedFees.length / itemsPerPage).ceil();

    return FutureBuilder<FeeResponse?>(
      future: futureFees,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                const SizedBox(height: 15),
                TextFormField(
                  controller: _searchController,
                  onChanged: _filterFees,
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
                ),
                const SizedBox(height: 15,),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: pageCount,
                    itemBuilder: (context, pageIndex) {
                      final startIndex = pageIndex * itemsPerPage;
                      final endIndex =
                          (startIndex + itemsPerPage < _displayedFees.length)
                              ? startIndex + itemsPerPage
                              : _displayedFees.length;

                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          childAspectRatio: 3.3,
                          mainAxisSpacing: 15.0,
                        ),
                        itemCount: endIndex - startIndex,
                        itemBuilder: (context, index) {
                          return FeeCard(
                            item: _displayedFees[startIndex + index],
                            feeResponse:
                                snapshot.data!, // Truyền toàn bộ response
                          );
                        },
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                      );
                    },
                  ),
                ),

                // Phần dot chuyển trang
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
                              color: _currentPage == index
                                  ? Colors.blue
                                  : Colors.grey,
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
      },
    );
  }
}
