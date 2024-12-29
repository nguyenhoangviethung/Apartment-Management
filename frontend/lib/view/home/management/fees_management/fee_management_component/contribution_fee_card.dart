// import 'package:flutter/material.dart';
// import 'package:frontend/models/contribution_fee_info.dart';
//
// class ContributionFeeCard extends StatefulWidget {
//   final ContributionFeeResponse contributionFeeResponse;
//   final ContributionFeeInfo item;
//
//   const ContributionFeeCard({
//     super.key,
//     required this.item,
//     required this.contributionFeeResponse,
//   });
//
//   @override
//   State<ContributionFeeCard> createState() => _ContributionFeeCardState();
// }
//
// class _ContributionFeeCardState extends State<ContributionFeeCard> {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: const Center(
//                 child: Text(
//                   'Information',
//                   style: TextStyle(fontSize: 36, fontWeight: FontWeight.w500, color: Colors.blue),
//                 ),
//               ),
//               contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
//               content: SingleChildScrollView(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _buildInfoRow('Description:', widget.contributionFeeResponse.description ?? 'N/A'),
//                     _buildInfoRow('Room:', widget.item.room?.toString() ?? 'N/A'),
//                     _buildInfoRow('Contribution Fee:', widget.item.amount ?? 'N/A'),
//                   ],
//                 ),
//               ),
//               actions: [
//                 TextButton(
//                   child: const Center(
//                     child: Text("OK", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue)),
//                   ),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                 ),
//               ],
//             );
//           },
//         );
//       },
//       child: Card(
//         elevation: 3,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(15.0),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: Row(
//                       children: [
//                         Icon(Icons.home_outlined, color: Colors.blue[500]!, size: 45),
//                         const SizedBox(width: 8),
//                         Expanded(
//                           child: Text(
//                             widget.item.room?.toString() ?? 'Unknown room',
//                             style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.black),
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 1,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 10),
//                 child: Row(
//                   children: [
//                     Flexible(
//                       child: Row(
//                         children: [
//                           Icon(Icons.description, color: Colors.grey[600]!, size: 25),
//                           const SizedBox(width: 10),
//                           Expanded(
//                             child: Text(
//                               widget.contributionFeeResponse.description ?? 'N/A',
//                               style: const TextStyle(fontSize: 17, color: Colors.black87),
//                               overflow: TextOverflow.ellipsis,
//                               maxLines: 1,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Flexible(
//                       child: Row(
//                         children: [
//                           Icon(Icons.money, color: Colors.grey[600]!, size: 25),
//                           const SizedBox(width: 10),
//                           Expanded(
//                             child: Text(
//                               widget.item.amount??'N/A',
//                               style: const TextStyle(fontSize: 17, color: Colors.black87),
//                               overflow: TextOverflow.ellipsis,
//                               maxLines: 1,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInfoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: RichText(
//         text: TextSpan(
//           children: [
//             TextSpan(
//               text: label,
//               style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
//             ),
//             TextSpan(
//               text: ' $value',
//               style: const TextStyle(color: Colors.black, fontSize: 18),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

import '../../../../../models/contribution_fee_info.dart';

class ContributionFeeCard extends StatefulWidget {
  final ContributionFeeResponse contributionFeeResponse;
  final ContributionFeeInfo item;

  const ContributionFeeCard({
    super.key,
    required this.item,
    required this.contributionFeeResponse,
  });

  @override
  State<ContributionFeeCard> createState() => _ContributionFeeCardState();
}

class _ContributionFeeCardState extends State<ContributionFeeCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDetailsDialog(context),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue.shade50],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.home_outlined, color: Colors.blue[700], size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.item.room?.toString() ?? 'Unknown room',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoItem(
                      Icons.description,
                      widget.contributionFeeResponse.description ?? 'N/A',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildInfoItem(
                      Icons.money,
                      widget.item.amount ?? 'N/A',
                      isAmount: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text, {bool isAmount = false}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isAmount ? Colors.green.shade50 : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(
            icon,
            size: 16,
            color: isAmount ? Colors.green.shade700 : Colors.grey.shade700,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: isAmount ? Colors.green.shade700 : Colors.grey.shade700,
              fontWeight: isAmount ? FontWeight.w600 : FontWeight.normal,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _showDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue[700], size: 28),
                    const SizedBox(width: 12),
                    const Text(
                      'Details',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildDetailRow('Description', widget.contributionFeeResponse.description ?? 'N/A'),
                _buildDetailRow('Room', widget.item.room?.toString() ?? 'N/A'),
                _buildDetailRow('Amount', widget.item.amount ?? 'N/A', isAmount: true),
                const SizedBox(height: 24),
                Center(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Close',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isAmount = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: isAmount ? Colors.green.shade700 : Colors.black87,
              fontWeight: isAmount ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}