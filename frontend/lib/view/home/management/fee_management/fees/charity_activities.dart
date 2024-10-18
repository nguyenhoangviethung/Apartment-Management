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

  @override
  void initState() {
    super.initState();

    // Thêm 10 lần giá trị của item vào items
    for (int i = 0; i < 10; i++) {
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
    return  SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 15),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1, // Số cột trong lưới
                    childAspectRatio: 3.2, // Tỷ lệ chiều rộng/chiều cao của mỗi card
                    mainAxisSpacing: 20.0, // Khoảng cách giữa các hàng
                  ),
                  itemCount: items.length, // Số lượng card
                  itemBuilder: (context, index) {
                    // return ResidentCard(item: item);
                    return FeeCard(
                      item: items[index],
                      onDelete: handleDeleteActivity, // Truyền callback
                    );
                  },
                  physics: const NeverScrollableScrollPhysics(), // Ngăn không cho GridView cuộn
                  shrinkWrap: true, // Giúp GridView tự động điều chỉnh kích thước
                ),
              ),
            ],
          ),
        ),
      );
  }
}