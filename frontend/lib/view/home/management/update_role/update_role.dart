import 'package:flutter/material.dart';
import 'package:frontend/View/Home/main_home.dart';
import 'package:frontend/models/account_info.dart';
import 'package:frontend/services/fetch_accounts.dart';
import 'package:frontend/view/home/management/update_role/component_update_role/account_card.dart';

class UpdateRole extends StatefulWidget {
  const UpdateRole({super.key});

  @override
  State<UpdateRole> createState() => _UpdateRoleState();
}

class _UpdateRoleState extends State<UpdateRole> {
  List<AccountInfo> _accounts =[];
  List<AccountInfo> _allaccounts=[];
  int numOfResident = 0;

  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();

  int _currentPage = 0;
  final int itemsPerPage = 5; // Số lượng items trên mỗi trang

  @override
  void initState() {
    super.initState();
    fetchAccounts().then((value){
      setState(() {
        _accounts=value;
        _allaccounts=value;
        numOfResident=_allaccounts.where((account)=>account.user_role=='admin'||
            account.user_role=='resident'
        ).length;
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

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int pageCount = (_accounts.length / itemsPerPage).ceil(); // Tính tổng số trang

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            'Update Account Role',
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
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextFormField(
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle:
                        const TextStyle(color: Colors.black54, fontSize: 20),
                    suffixIcon:
                        const Icon(Icons.search, color: Colors.blue, size: 35),
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
                      text = text.toLowerCase();
                      _accounts = _allaccounts.where((accountinfo) {
                        var word = accountinfo.username?.toLowerCase() ?? '';
                        var email = accountinfo.user_email?.toLowerCase() ?? '';
                        var phoneNumber = accountinfo.phone_number?.toLowerCase() ?? '';
                        return word.contains(text)||email.contains(text)||phoneNumber.contains(text);
                      }).toList();
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 20), // Khoảng cách giữa hàng tìm kiếm và PageView

            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: pageCount,
                itemBuilder: (context, pageIndex) {
                  final startIndex = pageIndex * itemsPerPage;
                  final endIndex = (startIndex + itemsPerPage < _accounts.length)
                      ? startIndex + itemsPerPage
                      : _accounts.length;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: SingleChildScrollView(
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1, // Số cột trong lưới
                          childAspectRatio: 3.4, // Tỷ lệ chiều rộng/chiều cao của mỗi card
                          mainAxisSpacing: 22.0, // Khoảng cách giữa các hàng
                        ),
                        itemCount: endIndex - startIndex,
                        itemBuilder: (context, index) {
                          return AccountCard(
                            item: _accounts[startIndex + index],
                            numOfRes: numOfResident,
                          );
                        },
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                      ),
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
