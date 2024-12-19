import 'package:flutter/material.dart';
import 'package:frontend/view/home/management/fees_management/contribution_fees/all_contribution_fees.dart';
import 'package:frontend/view/home/management/fees_management/contribution_fees/change_details/change_details.dart';
import 'package:frontend/view/home/management/fees_management/fees_management.dart';
import 'package:intl/intl.dart';

import '../../../../../models/contribution_fee_info.dart';
import '../fee_management_component/date_filter.dart';

class ContributionFees extends StatefulWidget {
  const ContributionFees({super.key});

  @override
  State<ContributionFees> createState() => _ContributionFeesState();
}

class _ContributionFeesState extends State<ContributionFees> with TickerProviderStateMixin {
  final DateFilterPopup _dateFilterPopup = DateFilterPopup(
    onDateRangeSelected: (startDate, endDate) {
      // Xử lý khi người dùng chọn khoảng thời gian
      print('Selected date range: ${DateFormat('yyyy-MM-dd').format(startDate)} - ${DateFormat('yyyy-MM-dd').format(endDate)}');
      // Bạn có thể thêm logic để xử lý ngày đã chọn, ví dụ cập nhật UI hoặc lưu trữ giá trị
    },
  );

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

  }

  final List<ContributionFeeInfo> items = [];
  // void handleAddNewFee(int room_id, String service_charge, String manage_charge, String fee) {
  //   final newItem = FeeInfo(room_id: room_id, service_charge: service_charge, manage_charge: manage_charge,
  //       fee: fee);
  //   setState(() {
  //     items.add(newItem);
  //   });
  // }

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
            'Contribution Fees',
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
                      MaterialPageRoute(builder: (context) => const FeesManagement()),
                    );
                  },
                );
              }
          ),

          actions: [
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
            labelPadding: const EdgeInsets.only(bottom: 2),
            tabs: const <Widget>[
              Tab(
                child: Text('All', style: TextStyle(fontSize: 18), textAlign:TextAlign.center),
              ),
              Tab(
                child: Text('Change Details', style: TextStyle(fontSize: 18), textAlign:TextAlign.center),
              ),
            ],
          ),
        ),

        body: TabBarView(
          controller: _tabController,
          children: const <Widget>[
            AllContributionFees(),
            ChangeDetails(),
          ],
        ),
      ),
    );
  }
}


