import 'package:flutter/material.dart';

class Home_Page extends StatelessWidget {
  const Home_Page({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: 100,
      itemBuilder: (context, index) {
        return UserButton(
          userName: 'User ${index + 1}',
          onPressed: () {

          },
        );
      },
    );
  }
}

class UserButton extends StatelessWidget {
  final String userName;
  final VoidCallback onPressed;

  const UserButton({
    super.key,
    required this.userName,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(userName),
    );
  }
}