import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/models/user_fee.dart';
import 'package:frontend/services/fetch_user_fee.dart';
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
  late UserFee? userHouseholdFee;
  late UserFee? userParkFee;
  late List<UserContributionFee> ? userContributionFee;
  bool isLoading = true;

  Future<void> getUrlPay(int feeId,String amount,String description,String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tokenlogin = prefs.getString('tokenlogin');
    String? userId= prefs.getString('user_id');
    if(type=='park'){
      final url= 'https://apartment-management-kjj9.onrender.com/user/${int.parse(userId!)}/$feeId/${double.parse(amount).toInt()}/$description/pay-park-fee';
      print(url);
      try{
        final response = await http.get(
            Uri.parse(url),
            headers: {
              'Authorization': 'Bearer $tokenlogin'
            }
        );
        print(response.body);
        if(response.statusCode==200){
          final urlResponse = jsonDecode(response.body)['payment_url'];
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
    }else{
      String descrip = description.replaceAll('/', '');
      final url2= 'https://apartment-management-kjj9.onrender.com/user/${int.parse(userId!)}/$feeId/${double.parse(amount).toInt()}/$descrip/pay-fee';
      print(url2);
      try{
        final response = await http.get(
            Uri.parse(url2),
            headers: {
              'Authorization': 'Bearer $tokenlogin'
            }
        );
        print(response.body);
        if(response.statusCode==200){
          final urlResponse = jsonDecode(response.body)['payment_url'];
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
  }
  Future<void> fetchData() async {
    try {
      userHouseholdFee = await fetchUserFee('user/fees');
      userParkFee = await fetchUserFee('user/park-fees');
      userContributionFee = await fetchUserContributionFee();
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
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
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text('Required Fee'),
                  _buildPaymentCard(
                    amount: userHouseholdFee?.amount.toString() ?? 'N/A',
                    nameFee: userHouseholdFee?.name_fee ?? 'N/A',
                    dueDate: userHouseholdFee?.due_date ?? 'N/A',
                    status: userHouseholdFee?.status ?? 'N/A',
                    feeId: userHouseholdFee?.fee_id??0,
                    typeFee: 'required'
                  ),
                  const SizedBox(height: 20),
                  const Text('Park Fee'),
                  _buildPaymentCard(
                    amount: userParkFee?.amount.toString() ?? 'N/A',
                    nameFee: userParkFee?.name_fee ?? 'N/A',
                    dueDate: userParkFee?.due_date ?? 'N/A',
                    status: userParkFee?.status ?? 'N/A',
                    feeId: userParkFee?.fee_id??0,
                    typeFee: 'park'
                  ),
                  const SizedBox(height: 20),
                  const Text('Contribution Fee'),
                  ListView.builder(
                      shrinkWrap: true, // Thêm shrinkWrap để tối ưu hóa
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: userContributionFee?.length,
                      itemBuilder: (BuildContext context, int index){
                        return Column(
                          children: [
                            _buildPaymentCard(amount: userContributionFee?[index].amount??'N/A',
                                nameFee: userContributionFee?[index].description??'N/A',
                                dueDate: userContributionFee?[index].due_date??'N/A',
                                status: 'N/A',
                                feeId: userContributionFee?[index].fee_id??0,
                                typeFee: 'contribution'
                            ),
                            const SizedBox(height: 10,)
                          ],
                        );
                      }
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
    required int feeId,
    required String typeFee,
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
                  onPressed: () async{
                    await getUrlPay(feeId, amount, nameFee,typeFee);
                    // Chưa cần logic, sẽ bổ sung sau
                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>VNPayPaymentScreen(paymentUrl: 'https://nguyenhaiminh.id.vn/')));
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
