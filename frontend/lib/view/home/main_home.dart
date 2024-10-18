import 'package:flutter/material.dart';
import 'package:frontend/view/home/home_page/home_page.dart';

import 'management/management.dart';


class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomePage(),
    const Center(child: Text('Rules Screen')),
    const Management(),
    const Center(child: Text('Account Screen')),
  ];

  String _getAppBarTitle() {
    switch (_currentIndex) {
      case 1:
        return 'Rules';
      case 2:
        return 'Management';
      case 3:
        return 'Account';
      default:
        return 'Welcome back';
    }
  }

  bool _shouldShowBackButton() {
    return _currentIndex != 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text(
          _getAppBarTitle(),
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: _shouldShowBackButton()
            ? IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rule),
            label: 'Rules',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Management',
          ),
          BottomNavigationBarItem(
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
    );
  }
}

