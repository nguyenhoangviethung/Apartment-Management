import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VNPayPaymentScreen extends StatefulWidget {
  final String paymentUrl;

  const VNPayPaymentScreen({super.key, required this.paymentUrl});

  @override
  State<VNPayPaymentScreen> createState() => _VNPayPaymentScreenState();
}

class _VNPayPaymentScreenState extends State<VNPayPaymentScreen> {
  final controller =WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..loadRequest(Uri.parse('https://sandbox.vnpayment.vn/paymentv2/vpcpay.html?vnp_Amount=50000000&vnp_Command=pay&vnp_CreateDate=20241218124002&vnp_CurrCode=VND&vnp_ExpireDate=20241218125002&vnp_IpAddr=222.252.94.241%2C+162.158.178.171%2C+10.210.182.2&vnp_Locale=vn&vnp_OrderInfo=Transaction+101+500000+for+10+by+1&vnp_OrderType=billpayment&vnp_ReturnUrl=http%3A%2F%2F127.0.0.1%3A5000%2Fpay%2Fpayment-return&vnp_TmnCode=AWCGSJ5J&vnp_TxnRef=ea14ca39-f5af-44d0-b752-b907537084f5&vnp_Version=2.1.0&vnp_SecureHash=82a27e1206289f3d93030b326a8dc1fed301f01df815930a7252136b1f528424a6db85d9387b27fd65e7402902be646ec1fff5a93abaee11da117b79e9e77e06'));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán VNPay'),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
