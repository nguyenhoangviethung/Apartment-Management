import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../vnpay.dart';
class ElectricityBillScreen extends StatefulWidget {
  const ElectricityBillScreen({super.key});

  @override
  State<ElectricityBillScreen> createState() => _ElectricityBillScreenState();
}

class _ElectricityBillScreenState extends State<ElectricityBillScreen> {
  late double amount;
  late String customer_id;
  bool isload = false;
  bool hasBillData = false;
  TextEditingController customerId = TextEditingController();

  Future<void> getElectricBill(String customerId) async {
    setState(() {
      isload = true;
      hasBillData = false;
    });
    try {
      final url = 'https://apartment-management-kjj9.onrender.com/user/get-electric-bill/$customerId';
      final response = await http.get(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json'
          }
      );
      print(response.body);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        setState(() {
          amount = jsonResponse['amount'];
          customer_id = jsonResponse['customer_id'];
          hasBillData = true;
        });
      }
    } catch (e) {
      print('Error:$e');
    } finally {
      setState(() {
        isload = false;
      });
    }
  }

  Future<void> getUrlPay(String customerId) async {
    final url = 'https://apartment-management-kjj9.onrender.com/user/$customerId/pay-electric-fee';
    try {
      final response = await http.get(
          Uri.parse(url),
      );
      print(response.body);
      if (response.statusCode == 200) {
        final urlResponse = jsonDecode(response.body)['payment_url'];
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VNPayPaymentScreen(paymentUrl: urlResponse)),
          );
        }
      }
    } catch (e) {
      print('Error $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thông tin hóa đơn tiền điện',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                   TextField(
                    decoration: const InputDecoration(
                      labelText: 'Mã khách hàng',
                      prefixIcon: Icon(Icons.person),
                    ),
                    controller: customerId,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      getElectricBill(customerId.text.trim());
                    },
                    child: const Text('Kiểm tra hóa đơn'),
                  ),
                  const SizedBox(height: 20),
                  if (isload)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  if (hasBillData && !isload)
                    _buildPaymentCard(
                      amount: '${amount.toStringAsFixed(0)} VNĐ',
                      nameFee: 'Tiền điện',
                      status: 'Chưa thanh toán',
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard({
    required String amount,
    required String nameFee,
    required String status,
  }) {
    Color statusColor;
    Color cardColor;

    switch (status.toLowerCase()) {
      case 'đã thanh toán':
        statusColor = Colors.green;
        cardColor = Colors.green[50]!;
        break;
      case 'chưa thanh toán':
        statusColor = Colors.orange;
        cardColor = Colors.orange[50]!;
        break;
      case 'quá hạn':
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
                        'Số tiền',
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
                ],
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.bottomRight,
                child: status.toLowerCase() == 'đã thanh toán'
                    ? ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          backgroundColor: Colors.white38,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Thanh toán Online',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: () async {
                          await getUrlPay(customerId.text.trim());
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
                          'Thanh toán Online',
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