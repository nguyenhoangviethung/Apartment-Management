import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> notifications = [
      {
        "title": "Thông báo thay đổi lịch thu phí quản lý chung cư",
        "date": "11/12/2024",
        "content": "Thông báo về việc thay đổi lịch thu phí quản lý chung cư tại tòa nhà A."
      },
      {
        "title": "Chương trình kiểm tra hệ thống PCCC tại chung cư",
        "date": "03/12/2024",
        "content": "Ban quản lý chung cư thông báo về chương trình kiểm tra định kỳ hệ thống phòng cháy chữa cháy..."
      },
      {
        "title": "Mời cư dân tham dự cuộc họp thường niên tại chung cư",
        "date": "02/12/2024",
        "content": "Cuộc họp thường niên với sự tham gia của cư dân sẽ được tổ chức tại hội trường tầng trệt..."
      },
      {
        "title": "Thông báo bảo trì thang máy tại chung cư",
        "date": "27/11/2024",
        "content": "Thông báo về việc bảo trì thang máy tại tòa nhà B, cư dân vui lòng sử dụng thang máy khác trong thời gian bảo trì."
      }
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông báo', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
        centerTitle: true,
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(
              Icons.arrow_back,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          );
        }),

        actions: [
          IconButton(
            icon: const Icon(
              Icons.edit,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () {
              _showNewNotificationDialog(context);
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'ADMIN',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        notification['date']!,
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    notification['title']!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const Divider( // Thêm đường kẻ ngang
                    color: Colors.grey,
                    thickness: 1, // Độ dày của đường kẻ
                    height: 24, // Khoảng cách giữa đường kẻ và các widget xung quanh
                  ),
                  Text(
                    notification['content']!,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        _showDetailDialog(context, notification);
                      },
                      child: const Text(
                        'Chi tiết',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Hàm hiển thị popup chi tiết thông báo
void _showDetailDialog(BuildContext context, Map<String, String> notification) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Center(
          child: Column(
            children: [
              Text(
                notification['title']!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider( // Thêm đường kẻ ngang
                color: Colors.grey,
                thickness: 1, // Độ dày của đường kẻ
                height: 16, // Khoảng cách giữa đường kẻ và các widget xung quanh
              ),
            ],
          ),
        ),
        content: Text(
          notification['content']!,
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Đóng popup
            },
            child: const Text(
              'Đóng',
              style: TextStyle(color: Colors.blue, fontSize: 18),
            ),
          ),
        ],
      );
    },
  );
}

// Hàm hiển thị dialog để nhập thông báo mới
void _showNewNotificationDialog(BuildContext context) {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Center(
          child: Text(
            'New Notification',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        content: Container(
          width: 400,
          height: 250,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: dateController,
                  decoration: const InputDecoration(
                    labelText: 'Date',
                  ),
                  keyboardType: TextInputType.datetime,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Tittle',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: contentController,
                  decoration: const InputDecoration(
                    labelText: 'Content',
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Đóng dialog
            },
            child: const Text(
              'Hủy',
              style: TextStyle(color: Colors.red),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Thực hiện hành động lưu thông báo mới tại đây
              String newDate = dateController.text;
              String newTitle = titleController.text;
              String newContent = contentController.text;

              // Thêm thông báo mới vào danh sách (hoặc xử lý dữ liệu theo yêu cầu)
              print('Date: $newDate');
              print('Tittle: $newTitle');
              print('Content: $newContent');

              Navigator.of(context).pop(); // Đóng dialog sau khi lưu
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}
