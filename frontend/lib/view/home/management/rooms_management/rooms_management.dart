import 'package:flutter/material.dart';
import 'package:frontend/View/Home/main_home.dart';
import 'package:frontend/models/room_info.dart';
import '../../../../services/fetch_rooms.dart';
import 'component_room/room_card.dart';

class RoomsManagement extends StatefulWidget {
  const RoomsManagement({super.key});

  @override
  State<RoomsManagement> createState() => _RoomsManagementState();
}

class _RoomsManagementState extends State<RoomsManagement> {
  List<RoomInfo> _rooms =[];
  List<RoomInfo> _allrooms =[];
  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 0;
  final int itemsPerPage = 5;

  @override
  void initState() {
    super.initState();
    fetchRooms().then((value){
      setState(() {
        _rooms=value;
        _allrooms=value;
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

  void updateRoomInfoById(int id, int newNumResidents, String newPhoneNumber) {
    setState(() {
      for (var room in _rooms) {
        if (room.apartment_number == id.toString()) {
          room.num_residents = newNumResidents;  // Cập nhật số cư dân
          room.phone_number = newPhoneNumber;     // Cập nhật số điện thoại
          break; // Dừng vòng lặp khi tìm thấy
        }
      }
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
    final int pageCount = (_rooms.length / itemsPerPage).ceil(); // Tính tổng số trang

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            'Rooms Management',
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 30, color: Colors.white),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const MainHome(currentIndex: 1,)));
            },
          ),
        ),

        body: Column(
          children: [
            const SizedBox(height: 15),
            // Thanh tìm kiếm
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),

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
                    _rooms=_allrooms.where((roominfo){
                      var word= roominfo.apartment_number!.toLowerCase();
                      return word.contains(text);
                    }).toList();
                  });
                },
              ),
            ),

            const SizedBox(height: 20), // Khoảng cách giữa hàng tìm kiếm và PageView

            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: pageCount,
                itemBuilder: (context, pageIndex) {
                  final startIndex = pageIndex * itemsPerPage;
                  final endIndex = (startIndex + itemsPerPage < _rooms.length)
                      ? startIndex + itemsPerPage
                      : _rooms.length;

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
                        return RoomCard(
                          item: _rooms[startIndex + index],
                          onEdit: (id, newNumResidents, newPhoneNumber) {
                            updateRoomInfoById(id, newNumResidents, newPhoneNumber);
                            setState(() {
                            });
                          },
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



