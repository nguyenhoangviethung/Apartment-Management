import 'package:flutter/material.dart';
import '../../main_home.dart';
import 'common/date_filter.dart';
import 'common/fee_add_footer.dart';
import 'common/fee_item.dart';
import 'fees/charity_activities.dart';
import 'fees/required_fee.dart';

class FeesManagement extends StatefulWidget {
  const FeesManagement({super.key});

  @override
  State<FeesManagement> createState() => _FeesManagementState();
}

class _FeesManagementState extends State<FeesManagement> with TickerProviderStateMixin {
  final DateFilterPopup _dateFilterPopup = DateFilterPopup(
                                              onDateRangeSelected: (start, end) { },
                                          );

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

  }

  final List<FeeItem> items = [];
  void handleAddNewFee(String name, String fee, String id, String startDate, String endDate) {
    final newItem = FeeItem(name: name, fee: fee, id: id,
        startDate: startDate, endDate: endDate);
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
        appBar:
        AppBar(
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

          bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.white, // Màu văn bản cho tab được chọn
            unselectedLabelColor: Colors.white60,
            tabs: const <Widget>[
              Tab(
                child: Text('Required Fees', style: TextStyle(fontSize: 18 ),),
              ),
              Tab(
                child: Text('Charity Activities', style: TextStyle(fontSize: 18 ),),
              ),

            ],
          ),
        ),

        body: TabBarView(
          controller: _tabController,
          children: const <Widget>[
            RequiredFees(),
            CharityActivities(),
          ],
        ),

        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                onPressed: () {
                  // Hành động khi nhấn nút
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return AddFee(addNewFee: handleAddNewFee,);
                      }
                  );
                },
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(90),
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

