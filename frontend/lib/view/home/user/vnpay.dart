import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class VNPayPaymentScreen extends StatefulWidget {
  final String paymentUrl;

  const VNPayPaymentScreen({Key? key, required this.paymentUrl}) : super(key: key);

  @override
  State<VNPayPaymentScreen> createState() => _VNPayPaymentScreenState();
}

class _VNPayPaymentScreenState extends State<VNPayPaymentScreen> {
  String? urlVnPay;
  bool isloading = true;

  Future<void> _launchURL(String url) async {
    try {
      final Uri uri = Uri.parse(url.trim()); // Thêm trim() để loại bỏ khoảng trắng
      if (!await launchUrl(
        uri,
        mode: LaunchMode.externalNonBrowserApplication,
      )) {
        throw 'Không thể mở URL: $uri';
      }
    } catch (e) {
      print('Lỗi khi mở URL: $e');
      // Xử lý lỗi phù hợp với ứng dụng của bạn
    }
  }

  Future<void> getPaymentUrl() async {
    try {
      setState(() => isloading = true);
      final response = await http.get(Uri.parse(widget.paymentUrl));

      if (response.statusCode == 200) {
        final cleanedUrl = response.body.replaceAll('"', '').trim();
        setState(() => urlVnPay = cleanedUrl);
        await _launchURL(cleanedUrl);
      } else {
        throw 'Lỗi API: ${response.statusCode}';
      }
    } catch (e) {
      print('Lỗi: $e');
      // Xử lý lỗi phù hợp
    } finally {
      setState(() => isloading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    getPaymentUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán online'),
      ),
      body: isloading
          ? const Center(child: CircularProgressIndicator())
          : const Center(
        child: Text('Đang chuyển hướng đến trang thanh toán...'),
      ),
    );
  }
}