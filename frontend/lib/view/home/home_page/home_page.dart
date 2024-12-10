import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/services/fetch_news.dart';
import 'package:frontend/view/home/home_page/home_page_component/detailed_new.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/news.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<News> _news = [];
  bool _isLoading = true;
  int _currentPage = 1;
  final int _itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _fetchNewsData();
  }
  Future<void> _fetchNewsData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? savedNews = prefs.getString('news_data');
      final int? timestamp = prefs.getInt('news_timestamp');

      // Kiểm tra xem dữ liệu có cũ hơn 24 giờ không
      if (timestamp != null &&
          DateTime.now().millisecondsSinceEpoch - timestamp > 86400000) {
        print('Dữ liệu quá cũ, xóa news_data');
        await prefs.remove('news_data');
        await prefs.remove('news_timestamp');
      }

      if (savedNews != null) {
        final List<dynamic> decodedNews = jsonDecode(savedNews);
        setState(() {
          _news = decodedNews.map((json) => News.fromJson(json)).toList();
          _isLoading = false;
        });
      } else {
        final allNews = await fetchNews();
        if (allNews != null) {
          // Lưu dữ liệu vào SharedPreferences
          final List<Map<String, dynamic>> newsJsonList =
          allNews.map((news) => news.toJson()).toList();
          await prefs.setString('news_data', jsonEncode(newsJsonList));
          await prefs.setInt('news_timestamp', DateTime.now().millisecondsSinceEpoch);
        }
        setState(() {
          _news = allNews ?? [];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load news: $e')),
      );
    }
  }


  List<News> get _paginatedNews {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    return _news.sublist(
        startIndex, endIndex > _news.length ? _news.length : endIndex);
  }

  int get _totalPages => (_news.length / _itemsPerPage).ceil();

  void _goToNextPage() {
    if (_currentPage < _totalPages) {
      setState(() {
        _currentPage++;
      });
    }
  }

  void _goToPreviousPage() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        title: const Text(
          'Apartment News',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        elevation: 2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _paginatedNews.length,
                    itemBuilder: (context, index) {
                      final newsItem = _paginatedNews[index];
                      return Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: LinearGradient(
                              colors: [
                                Colors.white,
                                Colors.blue.withOpacity(0.1),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  bottomLeft: Radius.circular(15),
                                ),
                                child: Hero(
                                  tag: 'news-${_currentPage}-$index',
                                  child: Image.network(
                                    newsItem.linkImage ?? 'No Image',
                                    height: double.infinity,
                                    width: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[300],
                                        child: const Icon(
                                          Icons.image_not_supported,
                                          size: 40,
                                          color: Colors.grey,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.blue[700],
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          'News ${(_currentPage - 1) * _itemsPerPage + index + 1}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        newsItem.title ?? 'No Title',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        newsItem.content ?? 'No Content',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> DetailedNew(currentNews: _paginatedNews[index],)));
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Pagination Controls
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: _currentPage > 1 ? _goToPreviousPage : null,
                      ),
                      Text(
                        'Page $_currentPage of $_totalPages',
                        style: const TextStyle(fontSize: 16),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed:
                            _currentPage < _totalPages ? _goToNextPage : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
