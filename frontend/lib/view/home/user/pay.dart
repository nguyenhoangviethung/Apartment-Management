import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/view/home/user/vnpay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../main_home.dart';
class Pay extends StatefulWidget {
  const Pay({super.key});

  @override
  State<Pay> createState() => _PayState();
}

class _PayState extends State<Pay> {
  Future<void> getUrlPay(int userId, int feeId, int householdId,int amount) async {
    final url= 'https://apartment-management-kjj9.onrender.com/$userId/$feeId/$householdId/$amount';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tokenlogin = prefs.getString('tokenlogin');
    try{
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $tokenlogin'
        }
      );
      print(response.body);
      if(response.statusCode==302){
        final urlResponse = jsonDecode(response.body);
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VNPayPaymentScreen(paymentUrl: urlResponse)),
          );
        }
      }
    }catch(e){
      print('Error $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Payment Information',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 30, color: Colors.white),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=> const MainHome(currentIndex: 1,)));
            //Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildPaymentCard(
              amount: '1,200,000 VND',
              nameFee: 'Room Fee',
              dueDate: '20/11/2024',
              status: 'Pending',
              context: context,
            ),
            const SizedBox(height: 16),
            _buildPaymentCard(
              amount: '200,000 VND',
              nameFee: 'Electric Fee',
              dueDate: '25/11/2024',
              status: 'Paid', context: context,
            ),
            const SizedBox(height: 16),
            _buildPaymentCard(
              amount: '100,000 VND',
              nameFee: 'Water Fee',
              dueDate: '25/11/2024',
              status: 'Overdue', context: context,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentCard({
    required String amount,
    required String nameFee,
    required String dueDate,
    required String status,
    required BuildContext context
  }) {
    Color statusColor;
    Color cardColor;

    switch (status.toLowerCase()) {
      case 'paid':
        statusColor = Colors.green;
        cardColor = Colors.green[50]!;
        break;
      case 'pending':
        statusColor = Colors.orange;
        cardColor = Colors.orange[50]!;
        break;
      case 'overdue':
        statusColor = Colors.red;
        cardColor = Colors.red[50]!;
        break;
      default:
        statusColor = Colors.grey;
        cardColor = Colors.grey[50]!;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: statusColor,
                width: 6,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    nameFee,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Amount',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        amount,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'Due Date',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dueDate,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () {
                    // Chưa cần logic, sẽ bổ sung sau
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>VNPayPaymentScreen(paymentUrl: 'https://nguyenhaiminh.id.vn/')));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Pay Online',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
