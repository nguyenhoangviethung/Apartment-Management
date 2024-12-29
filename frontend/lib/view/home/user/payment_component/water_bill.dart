import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../vnpay.dart';
class WaterBillScreen extends StatefulWidget {
  const WaterBillScreen({super.key});

  @override
  State<WaterBillScreen> createState() => _WaterBillScreenState();
}

class _WaterBillScreenState extends State<WaterBillScreen> {
  late double amount;
  late String customer_id;
  bool isload = false;
  bool hasBillData = false;
  TextEditingController customerId = TextEditingController();

  Future<void> getWaterBill(String customerId) async {
    setState(() {
      isload = true;
      hasBillData = false;
    });
    print(customerId);
    try {
      const url = 'https://apartment-management-kjj9.onrender.com/user/get-water-bill/';
      final response = await http.post(
          Uri.parse(url),
          body: {
            'customer_id': customerId
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
    final url = 'https://apartment-management-kjj9.onrender.com/user/$customer_id/pay-water-fee';
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
            'Thông tin hóa đơn tiền nước',
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
                    controller: customerId,
                    decoration: const InputDecoration(
                      labelText: 'Mã khách hàng',
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),

                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      getWaterBill(customerId.text.trim());
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
                      nameFee: 'Tiền nước',
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final cardPadding = screenWidth * 0.05;

        return Container(
          margin: EdgeInsets.symmetric(vertical: cardPadding / 4),
          padding: EdgeInsets.all(cardPadding / 2),
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
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: statusColor,
                    width: 6,
                  ),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(cardPadding / 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            nameFee,
                            style: TextStyle(
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: cardPadding / 2,
                            vertical: cardPadding / 4,
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
                              fontSize: screenWidth * 0.035,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: cardPadding / 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Số tiền',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: screenWidth * 0.035,
                              ),
                            ),
                            SizedBox(height: cardPadding / 8),
                            Text(
                              amount,
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: cardPadding / 2),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        onPressed: () async {
                          // Logic thanh toán online
                          await getUrlPay("customerIdPlaceholder");
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: cardPadding,
                            vertical: cardPadding / 2,
                          ),
                          backgroundColor: status.toLowerCase() == 'đã thanh toán'
                              ? Colors.grey[300]
                              : Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Thanh toán Online',
                          style: TextStyle(
                            color: status.toLowerCase() == 'đã thanh toán'
                                ? Colors.black
                                : Colors.white,
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

}