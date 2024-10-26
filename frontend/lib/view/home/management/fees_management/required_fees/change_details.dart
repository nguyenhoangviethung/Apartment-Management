import 'package:flutter/material.dart';

class ChangeDetails extends StatefulWidget {
  const ChangeDetails({super.key});

  @override
  State<ChangeDetails> createState() => _ChangeDetailsState();
}

class _ChangeDetailsState extends State<ChangeDetails> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Column(
          children: [
            Container(
              color: Colors.blue,
              child: const TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white60,
                tabs: [
                  Tab(child: Text('Add', style: TextStyle(fontSize: 15), textAlign:TextAlign.center)),
                  Tab(child: Text('Update', style: TextStyle(fontSize: 15), textAlign:TextAlign.center)),
                  Tab(child: Text('Delete', style: TextStyle(fontSize: 15), textAlign:TextAlign.center)),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Add(),
                  Update(),
                  const Delete(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Add extends StatelessWidget {
  Add({super.key});

  // Tạo các controller riêng cho mỗi trường nhập liệu
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();
  final TextEditingController serviceRateController = TextEditingController();
  final TextEditingController manageRateController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  void handleOnClick() {
    // Lấy giá trị từ tất cả các trường nhập liệu
    final name = startDateController.text.trim();
    final fee = dueDateController.text.trim();
    var id = serviceRateController.text.trim();
    final startDate = manageRateController.text.trim();
    final endDate = descriptionController.text.trim();
    if(id == '') {
      id = DateTime.now().toString();
    }

    // Xóa giá trị sau khi thêm
    startDateController.clear();
    dueDateController.clear();
    serviceRateController.clear();
    manageRateController.clear();
    descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: 465, // Tăng chiều cao nếu cần
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const SizedBox(height: 15),
                            _buildTextField('Enter start date', startDateController),
                            const SizedBox(height: 16),
                            _buildTextField('Enter due date', dueDateController),
                            const SizedBox(height: 16),
                            _buildTextField('Enter service rate', serviceRateController),
                            const SizedBox(height: 16),
                            _buildTextField('Enter manage rate', manageRateController),
                            const SizedBox(height: 16),
                            _buildTextField('Enter description', descriptionController),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                handleOnClick();
                                FocusScope.of(context).unfocus();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text(
                                'Add',
                                style: TextStyle(
                                  fontFamily: 'Times New Roman',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
              );
            },
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(90),
            ),
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
      ],
    );
  }
}

class Update extends StatelessWidget {
  Update({super.key});

  // Tạo các controller riêng cho mỗi trường nhập liệu
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController manageRateController = TextEditingController();
  final TextEditingController serviceRateController = TextEditingController();

  void handleOnClick() {
    // Lấy giá trị từ tất cả các trường nhập liệu
    final description = descriptionController.text.trim();
    final manageRate = manageRateController.text.trim();
    final serviceRate = serviceRateController.text.trim();


    // Xóa giá trị sau khi thêm
    descriptionController.clear();
    manageRateController.clear();
    serviceRateController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: 320, // Tăng chiều cao nếu cần
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const SizedBox(height: 15),
                            _buildTextField('Enter new description', descriptionController),
                            const SizedBox(height: 16),
                            _buildTextField('Enter new manage rate', manageRateController),
                            const SizedBox(height: 16),
                            _buildTextField('Enter new service rate', serviceRateController),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                handleOnClick();
                                FocusScope.of(context).unfocus();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text(
                                'Update',
                                style: TextStyle(
                                  fontFamily: 'Times New Roman',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
              );
            },
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(90),
            ),
            child: const Icon(
              Icons.edit_calendar_outlined,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
      ],
    );
  }
}

class Delete extends StatelessWidget {
  const Delete({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            onPressed: () {

            },
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(90),
            ),
            child: const Icon(
              Icons.delete_outline,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
      ],
    );
  }
}

Widget _buildTextField(String label, TextEditingController controller) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blue, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    style: const TextStyle(
      fontFamily: 'Times New Roman',
      fontWeight: FontWeight.bold,
      fontSize: 18,
    ),
  );
}
