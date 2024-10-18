import 'package:flutter/material.dart';
import 'package:frontend/View/Home/main_home.dart';
import 'package:frontend/view/home/admin_management/fee_management/common/fee_item.dart';
import 'package:frontend/view/home/admin_management/fee_management/common/filter.dart';
import 'package:frontend/view/home/admin_management/fee_management/fees/charity_activities.dart';
import 'package:frontend/view/home/admin_management/fee_management/fees/required_fee.dart';

class FeesManagement extends StatefulWidget {
  const FeesManagement({super.key});

  @override
  State<FeesManagement> createState() => _FeesManagementState();
}

class _FeesManagementState extends State<FeesManagement> with TickerProviderStateMixin {
  final DateFilterPopup _dateFilterPopup = new DateFilterPopup(
                                              onDateRangeSelected: (start, end) {
                                              print('Start date: $start');
                                              print('End date: $end');
                                            },);

  final FeeItem item = const FeeItem(
    name: 'Ung ho anh Bay mua World cup',
    fee: '1B USD',
    id: '1',
    startDate: '10/04/2004',
    endDate: '10/04/2025',
  );

  final List<FeeItem> items = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

    // Thêm 10 lần giá trị của item vào items
    for (int i = 0; i < 5; i++) {
      items.add(FeeItem(
        name: '${item.name} $i', // Thêm số thứ tự vào tên để phân biệt
        fee: item.fee,
        id: '${int.parse(item.id) + i}', // Tạo ID khác nhau
        startDate: item.startDate,
        endDate: item.endDate,
      ));
    }
  }

  void handleDeleteActivity(String id) {
    setState(() {
      items.removeWhere((item) => item.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
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
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                );
              }
          ),

          actions: [
            IconButton(
              icon: const Icon(
                Icons.search,
                size: 30,
                color: Colors.white,
              ),
              onPressed: () {
                print('Search button pressed');
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.filter_alt_outlined,
                size: 30,
                color: Colors.white,
              ),
              onPressed: () {
                print('Filter button pressed');
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
                  _showPaymentDialog(context);
                },
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(90),
                ),
                child: const Icon(
                  Icons.payments_outlined,
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


void _showPaymentDialog(BuildContext context) {
  final TextEditingController controller = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Center(child: Text('Thanh Toán', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),)),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Nhập số tiền', // Sử dụng labelText
            border: OutlineInputBorder(), // Thêm border để tạo thành ô chữ nhật
          ),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Xử lý khi nhấn nút OK
              final inputValue = controller.text;
              print('Số tiền nhập: $inputValue');
              Navigator.of(context).pop(); // Đóng popup
            },
            child: const Text('OK', style: TextStyle(fontSize: 20),),
          ),
        ],
      );
    },
  );
}