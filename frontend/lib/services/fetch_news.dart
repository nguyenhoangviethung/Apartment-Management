import 'dart:convert';

import 'package:frontend/models/news.dart';
import 'package:http/http.dart' as http;

Future<List<News>?> fetchNews() async{
  const String url='https://apartment-management-kjj9.onrender.com/news/get-data';
  try{
    final response=await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type':'application/json',
      }
    );
    print(response.statusCode);
    if(response.statusCode==200){
      print(response.body);
      List<dynamic> jsonresponse=jsonDecode(response.body);
      return jsonresponse.map((json)=> News.fromJson(json)).toList();
    }else{
      throw Exception(response.statusCode);
    }
  }catch(e){
    print('Error:$e');
    return null;
  }
}