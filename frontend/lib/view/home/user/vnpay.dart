import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
class VNPayPaymentScreen extends StatefulWidget {
  final String paymentUrl;

  const VNPayPaymentScreen({super.key, required this.paymentUrl});

  @override
  State<VNPayPaymentScreen> createState() => _VNPayPaymentScreenState();
}

class _VNPayPaymentScreenState extends State<VNPayPaymentScreen> {
  late String ?urlVnPay;
  late final WebViewController controller;
  bool isloading=true;
  Future<void> getPaymentUrl()async{
    try{
      final response= await http.get(Uri.parse(widget.paymentUrl));
      print(response.body);
      if(response.statusCode==200){
        String cleanedUrl = response.body.replaceAll('"', '');
        setState(() {
          urlVnPay = cleanedUrl;
        });
      }
      print(urlVnPay);
      if (urlVnPay != null) {
        controller.loadRequest(Uri.parse(urlVnPay!));
      }
    }catch(e){
      print('Error: $e');
    }finally{
      setState(() {
        isloading=false;
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
    getPaymentUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pay online'),
      ),
      // body: WebViewWidget(controller: controller),
      body: isloading
          ? const Center(child: CircularProgressIndicator())
          : WebViewWidget(controller: controller),
    );
  }
}
