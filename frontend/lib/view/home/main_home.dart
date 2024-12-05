import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/view/home/account/account.dart';
import 'package:frontend/view/home/home_page/home_page.dart';
import 'package:frontend/view/home/user/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;
import 'management/management.dart';

class MainHome extends StatefulWidget {
  final int currentIndex;
  const MainHome({super.key, this.currentIndex = 0,});

  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  late int _currentIndex;
  late String _role='user';
  bool _isLoading = true;

  Future<void> fetchUserData() async {
    const String apiUrl = "https://apartment-management-kjj9.onrender.com/user/info";
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('tokenlogin') ?? '';
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          Map<String, dynamic> jsonResponse = json.decode(response.body);
          Map<String, dynamic> userInfo = jsonResponse['info'];
          SharedPreferences prefs =await SharedPreferences.getInstance();
          await prefs.setString('role', userInfo['user_role']);
          setState(() {
            _role=userInfo['user_role'];
            _isLoading = false;
          });
          print('Vai tro $_role');
        } else {
          throw Exception('Empty response from API');
        }
      } else {
        throw Exception('Failed to load user data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error detail: $e');
      setState(() {
        _isLoading=false;
      });
    }
  }
  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    _currentIndex = widget.currentIndex;
    fetchUserData();
  }
  List<Widget> _getScreens() {
    if (_role == 'admin') {
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

  String _getAppBarTitle() {
    switch (_currentIndex) {
      case 1:
        if(_role=='admin') {
          return 'Admin';
        } else {
          return 'User Services';
        }
      case 2:
        return 'Account';
      default:
        return 'Welcome back';
    }
  }
  List<BottomNavigationBarItem> _getBottomNavigationBarItems() {
    if (_role == 'admin') {
      return const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Management',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Account',
        ),
      ];
    } else {
      return const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.rule),
          label: 'User',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Account',
        ),
      ];
    }
  }
  bool _shouldShowBackButton() {
    return _currentIndex != 0;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.pinkAccent,),
      );
    }
    final items = _getBottomNavigationBarItems();
    final _screens= _getScreens();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          title: Text(
            _getAppBarTitle(),
            style: const TextStyle(
              fontSize: 24,
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
              onPressed: () {},
            ),
          ],
        ),
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.lightBlue,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white60,
          items: items,
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
