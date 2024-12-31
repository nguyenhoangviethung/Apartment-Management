// import 'package:flutter/material.dart';
//
// class CustomPagination extends StatelessWidget {
//   final int currentPage;
//   final int totalPages;
//   final Function() onPrevious;
//   final Function() onNext;
//
//   const CustomPagination({
//     Key? key,
//     required this.currentPage,
//     required this.totalPages,
//     required this.onPrevious,
//     required this.onNext,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 10,
//             offset: const Offset(0, -2),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // Previous Page Button
//           Material(
//             color: Colors.transparent,
//             child: InkWell(
//               onTap: currentPage > 1 ? onPrevious : null,
//               borderRadius: BorderRadius.circular(8),
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//                 decoration: BoxDecoration(
//                   color: currentPage > 1 ? Colors.blue.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(
//                       Icons.arrow_back_ios,
//                       size: 16,
//                       color: currentPage > 1 ? Colors.blue[700] : Colors.grey,
//                     ),
//                     const SizedBox(width: 4),
//
//                   ],
//                 ),
//               ),
//             ),
//           ),
//
//           // Page Numbers
//           Container(
//             margin: const EdgeInsets.symmetric(horizontal: 10),
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: Colors.grey.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 if (currentPage > 2)
//                   _buildPageNumber(1, currentPage == 1),
//                 if (currentPage > 3)
//                   _buildEllipsis(),
//                 if (currentPage > 1)
//                   _buildPageNumber(currentPage - 1, false),
//                 _buildPageNumber(currentPage, true),
//                 if (currentPage < totalPages)
//                   _buildPageNumber(currentPage + 1, false),
//                 if (currentPage < totalPages - 2)
//                   _buildEllipsis(),
//                 if (currentPage < totalPages - 1)
//                   _buildPageNumber(totalPages, currentPage == totalPages),
//               ],
//             ),
//           ),
//
//           // Next Page Button
//           Material(
//             color: Colors.transparent,
//             child: InkWell(
//               onTap: currentPage < totalPages ? onNext : null,
//               borderRadius: BorderRadius.circular(8),
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//                 decoration: BoxDecoration(
//                   color: currentPage < totalPages ? Colors.blue.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Row(
//                   children: [
//                     const SizedBox(width: 4),
//                     Icon(
//                       Icons.arrow_forward_ios,
//                       size: 16,
//                       color: currentPage < totalPages ? Colors.blue[700] : Colors.grey,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPageNumber(int pageNumber, bool isSelected) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 4),
//       width: 35,
//       height: 35,
//       decoration: BoxDecoration(
//         color: isSelected ? Colors.blue[700] : Colors.transparent,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Center(
//         child: Text(
//           pageNumber.toString(),
//           style: TextStyle(
//             color: isSelected ? Colors.white : Colors.blue[700],
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildEllipsis() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 4),
//       width: 35,
//       height: 35,
//       child: Center(
//         child: Text(
//           '...',
//           style: TextStyle(
//             color: Colors.blue[700],
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class MinimalPagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function() onPrevious;
  final Function() onNext;
  final Function(int) onPageChange;

  const MinimalPagination({
    Key? key,
    required this.currentPage,
    required this.totalPages,
    required this.onPrevious,
    required this.onNext,
    required this.onPageChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Nút Previous
          _buildArrowButton(
            Icons.arrow_back_ios,
            onTap: currentPage > 1 ? onPrevious : null,
          ),

          // Các khối số trang
          const SizedBox(width: 8),
          ..._buildPageNumbers(),
          const SizedBox(width: 8),

          // Nút Next
          _buildArrowButton(
            Icons.arrow_forward_ios,
            onTap: currentPage < totalPages ? onNext : null,
          ),
        ],
      ),
    );
  }

  Widget _buildArrowButton(IconData icon, {required Function()? onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: onTap != null ? Colors.blue.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 16,
            color: onTap != null ? Colors.blue[700] : Colors.grey,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPageNumbers() {
    List<Widget> widgets = [];

    // Hiển thị trang đầu tiên
    widgets.add(_buildPageNumber(1, isSelected: currentPage == 1));

    // Nếu cần hiển thị dấu "..." trước
    if (currentPage > 3) {
      widgets.add(_buildEllipsis());
    }

    // Hiển thị các trang liền kề (trang hiện tại và 1 trang trước/sau nếu có)
    for (int i = currentPage - 1; i <= currentPage + 1; i++) {
      if (i > 1 && i < totalPages) {
        widgets.add(_buildPageNumber(i, isSelected: i == currentPage));
      }
    }

    // Nếu cần hiển thị dấu "..." sau
    if (currentPage < totalPages - 2) {
      widgets.add(_buildEllipsis());
    }

    // Hiển thị trang cuối cùng
    if (totalPages > 1) {
      widgets.add(_buildPageNumber(totalPages, isSelected: currentPage == totalPages));
    }

    return widgets;
  }

  Widget _buildPageNumber(int pageNumber, {required bool isSelected}) {
    return GestureDetector(
      onTap: () {
        if (pageNumber != currentPage) {
          onPageChange(pageNumber);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[700] : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.blue[700]! : Colors.grey,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          pageNumber.toString(),
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.blue[700],
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildEllipsis() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: const Text(
        '...',
        style: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

