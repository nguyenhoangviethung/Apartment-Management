import 'package:flutter/material.dart';
import 'package:frontend/View/Home/main_home.dart';
import 'package:frontend/models/resident_info.dart';
import 'package:frontend/services/fetch_residents.dart';
import 'add_residents/add_residents.dart';
import 'common/resident_card.dart';

class ResidentsManagement extends StatefulWidget {
  const ResidentsManagement({super.key});

  @override
  State<ResidentsManagement> createState() => _ResidentsManagementState();
}

class _ResidentsManagementState extends State<ResidentsManagement> {

  // final ResidentItem item = const ResidentItem(
  //   name: 'Do Xuan Chien',
  //   room: 'vip-909',
  //   phoneNumber: '0999999999',
  //   dob: '10/04/2004',
  //   age: '20',
  //   status: 'Single',
  //   idNumber: '102',
  // );

  List<ResidentInfo> _residents =[];
  List<ResidentInfo> _allresidents=[];


  // final List<ResidentItem> items = [];
  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();

  int _currentPage = 0;
  final int itemsPerPage = 5; // Số lượng items trên mỗi trang

  @override
  void initState() {
    super.initState();

    // Thêm 100 lần giá trị của item vào items
    // for (int i = 0; i < 100; i++) {
    //   items.add(ResidentItem(
    //     name: '${item.name} $i', // Thêm số thứ tự vào tên để phân biệt
    //     room: item.room,
    //     phoneNumber: item.phoneNumber,
    //     dob: item.dob,
    //     age: item.age,
    //     status: item.status,
    //     idNumber: '${int.parse(item.idNumber) + i}', // Tạo ID khác nhau
    //   ));
    // }

    fetchResidents().then((value){
      setState(() {
        _residents=value;
        _allresidents=value;
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

  void handleDeleteActivity(String id) {
    setState(() {
      _residents.removeWhere((item) => item.id_number == id);
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
    final int pageCount = (_residents.length / itemsPerPage).ceil(); // Tính tổng số trang

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            'Residents Management',
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 30, color: Colors.white),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const MainHome(currentIndex: 2,)));
            },
          ),
        ),

        body: Column(
          children: [
            const SizedBox(height: 15),
            // Thanh tìm kiếm
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
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
                          _residents=_allresidents.where((residentinfo){
                            var word= residentinfo.full_name?.toLowerCase()??'';
                            return word.contains(text);
                          }).toList();
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.add, color: Colors.white, size: 35),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AddResidents()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20), // Khoảng cách giữa hàng tìm kiếm và PageView

            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: pageCount,
                itemBuilder: (context, pageIndex) {
                  final startIndex = pageIndex * itemsPerPage;
                  final endIndex = (startIndex + itemsPerPage < _residents.length)
                      ? startIndex + itemsPerPage
                      : _residents.length;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1, // Số cột trong lưới
                        childAspectRatio: 3.4, // Tỷ lệ chiều rộng/chiều cao của mỗi card
                        mainAxisSpacing: 22.0, // Khoảng cách giữa các hàng
                      ),
                      itemCount: endIndex - startIndex,
                      itemBuilder: (context, index) {
                        return ResidentCard(
                          item: _residents[startIndex + index],
                          onDelete: handleDeleteActivity,
                        );
                      },
                      physics: const NeverScrollableScrollPhysics(),
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
        ),
      ),
    );
  }
}
