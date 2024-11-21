import 'package:flutter/material.dart';
import 'dart:math';

import 'package:frontend/services/fetch_news.dart';

import '../../../models/news.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String getRandomOctoberDate() {

    final random = Random();
    final day = random.nextInt(20) + 1;
    final formattedDay = day.toString().padLeft(2, '0');
    return '$formattedDay/10/2024';
  }

  List<News> _news=[];
  List<News> _allnews=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchNews().then((value){
      _news =value!;
      _allnews=value;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Apartment News',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _news.length,
        itemBuilder: (context, index) {
          final randomDate = getRandomOctoberDate();
          return ArticleCard(
            articleTitle: 'News ${index + 1}',
            articleDescription: 'Short discription ${index + 1}',
            articleDate: randomDate,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ArticleDetailPage(
                    articleTitle: 'News ${index + 1}',
                    articleDescription: 'Chiu r k biet viet gi',
                    articleDate: randomDate,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ArticleCard extends StatelessWidget {
  final String articleTitle;
  final String articleDescription;
  final String articleDate;
  final VoidCallback onPressed;

  const ArticleCard({
    super.key,
    required this.articleTitle,
    required this.articleDescription,
    required this.articleDate,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Color(0xFFE3F2FD)],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        articleTitle,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1565C0),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1565C0).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        articleDate,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF1565C0),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  articleDescription,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[800],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: onPressed,
                      icon: const Icon(
                        Icons.arrow_forward,
                        size: 16,
                       // color: Colors.white70,
                      ),
                      label: const Text('Xem thêm'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.lightBlue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ArticleDetailPage extends StatelessWidget {
  final String articleTitle;
  final String articleDescription;
  final String articleDate;

  const ArticleDetailPage({
    super.key,
    required this.articleTitle,
    required this.articleDescription,
    required this.articleDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white), 
        title: const Text(
          'Chi tiết',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                articleTitle,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1565C0),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1565C0).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  articleDate,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1565C0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                articleDescription,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}