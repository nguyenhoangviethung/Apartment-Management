import 'package:flutter/material.dart';

class AdminManagement extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AdminManagement({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: onTap,
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
          label: 'Resident Management',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Account',
        ),
      ],
    );
  }
}
