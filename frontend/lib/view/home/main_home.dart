import 'package:flutter/material.dart';
import 'package:frontend/view/home/admin_management/admin_management.dart';
import 'package:frontend/view/home/home_page/home_page.dart';

void main() => runApp(const Home());

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quản lý cư dân',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: const MainHome(),
    );
  }
}

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    Home_Page(),
    const Center(child: Text('Rules Screen')),
    const ResidentManagementScreen(),
    const Center(child: Text('Account Screen')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Text('Welcome back',
            style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600)
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // Xử lý hành động thông báo
            },
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: AdminManagement(
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

class ResidentManagementScreen extends StatelessWidget {
  const ResidentManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ResidentManagementDetailScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Resident Management'),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FeeDetailScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Fee'),
            ),
          ),
        ),
      ],
    );
  }
}

class ResidentManagementDetailScreen extends StatelessWidget {
  const ResidentManagementDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resident Management Detail',
          style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.lightBlue,
      ),
      body: const Center(
        child: Text('Resident Management Detail Screen'),
      ),
    );
  }
}

class FeeDetailScreen extends StatelessWidget {
  const FeeDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fee Detail',
          style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.lightBlue,

      ),
      body: const Center(
        child: Text('Fee Detail Screen'),
      ),
    );
  }
}