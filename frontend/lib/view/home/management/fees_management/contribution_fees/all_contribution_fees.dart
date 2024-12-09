import 'package:flutter/material.dart';
import 'package:frontend/services/fetch_contribution_fees.dart'; // Đảm bảo import đúng dịch vụ
import '../../../../../models/contribution_fee_info.dart'; // Nhập mô hình ContributionFeeInfo
import '../fee_management_component/contribution_fee_card.dart'; // Nhập ContributionFeeCard

class AllContributionFees extends StatefulWidget {
  const AllContributionFees({super.key});

  @override
  State<AllContributionFees> createState() => _AllContributionFeesState();
}

class _AllContributionFeesState extends State<AllContributionFees> {
  late Future<ContributionFeeResponse?> futureContributionFees;

  List<ContributionFeeInfo> _originalFees = []; // Danh sách gốc
  List<ContributionFeeInfo> _displayedFees = []; // Danh sách hiển thị
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    futureContributionFees = fetchContributionFees().then((response) {
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
              (feeInfo.contributionFee?.toString().contains(query) ?? false);
        }).toList();
      }
      _pageController.jumpToPage(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    const int itemsPerPage = 5;
    int pageCount = (_displayedFees.length / itemsPerPage).ceil();

    return FutureBuilder<ContributionFeeResponse?>(
      future: futureContributionFees,
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
                      borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.blue[200]!, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.grey, width: 2.0),
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
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          childAspectRatio: 3.3,
                          mainAxisSpacing: 15.0,
                        ),
                        itemCount: endIndex - startIndex,
                        itemBuilder: (context, index) {
                          return ContributionFeeCard(
                            item: _displayedFees[startIndex + index],
                            contributionFeeResponse: snapshot.data!, // Truyền toàn bộ response
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

                const SizedBox(height: 15),
              ],
            ),
          );
        }
      },
    );
  }
}