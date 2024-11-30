import 'package:flutter/material.dart';
import 'package:frontend/View/Home/main_home.dart';
import '../../../../models/news.dart';

class DetailedNew extends StatefulWidget {
  final News currentNews;
  const DetailedNew({super.key, required this.currentNews});
  @override
  State<DetailedNew> createState() => _DetailedNewState();
}

class _DetailedNewState extends State<DetailedNew> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          leading: IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const MainHome(currentIndex: 0,)));
              },
              icon: const Icon(Icons.arrow_back,color: Colors.white,size: 24,)
          ),
          title: const Text('Detailed News',style: TextStyle(fontSize: 24,color: Colors.white),),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Text(
                    widget.currentNews.title??"No Title",
                    style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 60),
                Image.network(
                  widget.currentNews.linkImage??"No Image",

                ),

                const SizedBox(height: 40,),
                Text(
                  widget.currentNews.content??"No Content",
                  style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 20),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
