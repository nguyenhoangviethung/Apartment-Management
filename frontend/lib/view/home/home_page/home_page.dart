import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh Sách Bài Báo Về Chung Cư'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: 10, // số lượng bài báo, bạn có thể thay đổi theo dữ liệu thực
        itemBuilder: (context, index) {
          return ArticleCard(
            articleTitle: 'Bài Báo ${index + 1}', // giả lập tiêu đề bài báo
            articleDescription: 'Mô tả ngắn về bài báo ${index + 1}', // mô tả ngắn
            articleDate: 'Ngày đăng: 2024-10-01', // giả lập ngày đăng
            onPressed: () {
              // Mở dialog hiển thị thông tin chi tiết hoặc điều hướng sang trang khác
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Bài Báo ${index + 1}'),
                  content: Text('Thông tin chi tiết về bài báo ${index + 1}'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Đóng'),
                    ),
                  ],
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
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        title: Text(articleTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(articleDescription),
            const SizedBox(height: 5),
            Text(articleDate, style: const TextStyle(color: Colors.grey)),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Xem Chi Tiết'),
        ),
      ),
    );
  }
}
