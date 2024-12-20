import 'package:flutter/material.dart';
import 'package:frontend/View/Authentication/login.dart';
import 'package:frontend/view/home/main_home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;

Future<bool> checkAutoLog() async{
     const String url='https://apartment-management-kjj9.onrender.com/auth/check-autolog';
     SharedPreferences prefs= await SharedPreferences.getInstance();
     String? tokenlogin=prefs.getString('tokenlogin');
     if (tokenlogin == null || tokenlogin.isEmpty) {
          // Token không tồn tại hoặc rỗng
          return false;
     }
     try{
          final response=await http.get(
               Uri.parse(url),
               headers: {
                    'Authorization': 'Bearer $tokenlogin',
               }
          );
          print(response.body);
          if(response.statusCode==200){
               return true;
          }else{
               return false;
          }
     }catch(e){
          return false;
     }

}
void main() async{
     WidgetsFlutterBinding.ensureInitialized(); // Đảm bảo Flutter được khởi tạo trước
     if(await checkAutoLog()){
          runApp(const MainHome(currentIndex: 0,));
     }else{
          runApp(
              const MaterialApp(
                   debugShowCheckedModeBanner: false,
                   home: Login(),
              )
          );
     }
}



