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
  late String _role;
  late List<Widget> _screens = [];
  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    _currentIndex = widget.currentIndex;
    isAdminOrNot();
  }
  Future<void> isAdminOrNot()async{
    SharedPreferences prefs =await SharedPreferences.getInstance();
    String? role=prefs.getString('role');

    setState(() {
      _role=role!;
    });
    if(role=='admin'){
      setState(() {
        _screens=[
          const HomePage(),
          const User(),
          const Management(),
          const AccountScreen(),
        ];
      });
    }else{
      setState(() {
        _screens=[
          const HomePage(),
          const User(),
          const AccountScreen(),
        ];
      });
    }
  }

  String _getAppBarTitle() {
    if(_role=='admin'){
      switch (_currentIndex) {
        case 1:
          return 'User Services';
        case 2:
          return 'Management';
        case 3:
          return 'Account';
        default:
          return 'Welcome back';
      }
    }else{
      switch (_currentIndex) {
        case 1:
          return 'User Services';
        case 2:
          return 'Account';
        default:
          return 'Welcome back';
      }
    }
  }

  bool _shouldShowBackButton() {
    return _currentIndex != 0;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          title: Text(
            _getAppBarTitle(),
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
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const NotificationScreen()));
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
          items: _role=='admin'? [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.rule),
              label:'User Services',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.manage_accounts),
              label:'Management',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Account',
            ),
          ]: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.rule),
              label: 'User Services',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Account',
            ),
          ],
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}