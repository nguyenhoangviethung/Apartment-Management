import 'package:flutter/material.dart';
import 'package:frontend/view/home/account/account.dart';
import 'package:frontend/view/home/home_page/home_page.dart';
import 'package:frontend/view/home/notification/notification_screen.dart';
import 'package:frontend/view/home/user/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'management/management.dart';

class MainHome extends StatefulWidget {
  final int currentIndex;

  const MainHome({super.key, this.currentIndex = 0});

  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  late int _currentIndex;
  late Future<String> _roleFuture;
  late List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
    _roleFuture = _getRole();
  }

  Future<String> _getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? role = prefs.getString('role');
    return role ?? 'user';
  }

  String _getAppBarTitle(String role) {
    if (role == 'admin') {
      switch (_currentIndex) {
        case 1:
          return 'Quản lý';
        case 2:
          return 'Tài khoản';
        default:
          return 'Welcome back';
      }
    } else {
      switch (_currentIndex) {
        case 1:
          return 'Dịch vụ người dùng';
        case 2:
          return 'Tài khoản';
        default:
          return 'Welcome back';
      }
    }
  }

  bool _shouldShowBackButton() {
    return _currentIndex != 0; // Chỉ hiển thị back button khi _currentIndex khác 0
  }

  List<BottomNavigationBarItem> _buildBottomNavigationBarItems(String role) {
    if (role == 'admin') {
      return [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Trang chủ',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.manage_accounts),
          label: 'Quản lý',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Tài khoản',
        ),
      ];
    } else {
      return [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Trang chủ',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.rule),
          label: 'Dịch vụ người dùng',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Tài khoản',
        ),
      ];
    }
  }

  List<Widget> _buildScreens(String role) {
    if (role == 'admin') {
      return [
        const HomePage(),
        const Management(),
        const AccountScreen(),
      ];
    } else {
      return [
        const HomePage(),
        const User(),
        const AccountScreen(),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _roleFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasError) {
          return Scaffold(
              body: Center(child: Text('Error: ${snapshot.error}')));
        } else {
          String role = snapshot.data ?? 'user';
          _screens = _buildScreens(role);

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.lightBlue,
              title: Text(
                _getAppBarTitle(role),
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
              leading: _shouldShowBackButton()
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      // Thay đổi màu nút back
                      onPressed: () {
                        setState(() {
                          _currentIndex = 0;
                        });
                      },
                    )
                  : null,
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NotificationScreen()));
                  },
                ),
              ],
            ),
            body: _screens[_currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.lightBlue,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white60,
              items: _buildBottomNavigationBarItems(role),
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          );
        }
      },
    );
  }
}