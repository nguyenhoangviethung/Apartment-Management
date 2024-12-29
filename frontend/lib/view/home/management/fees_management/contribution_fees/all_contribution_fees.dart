// import 'package:flutter/material.dart';
// import '../../../../../models/contribution_fee_info.dart';
// import '../../../../../services/fetch_contribution_fees.dart';
// import '../fee_management_component/contribution_fee_card.dart';
//
// class ContributionFeeListScreen extends StatefulWidget {
//   const ContributionFeeListScreen({super.key});
//
//   @override
//   State<ContributionFeeListScreen> createState() => _ContributionFeeListScreenState();
// }
//
// class _ContributionFeeListScreenState extends State<ContributionFeeListScreen> {
//   late Future<List<ContributionFeeResponse>?> futureContributionFees;
//
//   @override
//   void initState() {
//     super.initState();
//     futureContributionFees = fetchContributionFees();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder<List<ContributionFeeResponse>?>(
//         future: futureContributionFees,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Text(
//                 'Error: ${snapshot.error}',
//                 style: const TextStyle(fontSize: 18, color: Colors.red),
//               ),
//             );
//           } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
//             final contributionFees = snapshot.data!;
//             return _buildContributionFeeList(contributionFees);
//           } else {
//             return const Center(child: Text('No data available'));
//           }
//         },
//       ),
//     );
//   }
//
//   Widget _buildContributionFeeList(List<ContributionFeeResponse> contributionFees) {
//     return ListView.builder(
//       itemCount: contributionFees.length,
//       itemBuilder: (context, index) {
//         final contributionFeeResponse = contributionFees[index];
//         return ExpansionTile(
//           title: Text(
//             contributionFeeResponse.description ?? 'No Description',
//             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           children: contributionFeeResponse.detail!
//               .map(
//                 (item) => Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
//               child: ContributionFeeCard(
//                 item: item,
//                 contributionFeeResponse: contributionFeeResponse,
//               ),
//             ),
//           )
//               .toList(),
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../../../../../models/contribution_fee_info.dart';
import '../../../../../services/fetch_contribution_fees.dart';
import '../fee_management_component/contribution_fee_card.dart';

class ContributionFeeListScreen extends StatefulWidget {
  const ContributionFeeListScreen({super.key});

  @override
  State<ContributionFeeListScreen> createState() => _ContributionFeeListScreenState();
}

class _ContributionFeeListScreenState extends State<ContributionFeeListScreen> {
  late Future<List<ContributionFeeResponse>?> futureContributionFees;

  @override
  void initState() {
    super.initState();
    futureContributionFees = fetchContributionFees();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: FutureBuilder<List<ContributionFeeResponse>?>(
          future: futureContributionFees,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.red[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              final contributionFees = snapshot.data!;
              return _buildContributionFeeList(contributionFees);
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox, size: 60, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'No data available',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildContributionFeeList(List<ContributionFeeResponse> contributionFees) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: contributionFees.length,
      itemBuilder: (context, index) {
        final contributionFeeResponse = contributionFees[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: Icon(
                Icons.description,
                color: Colors.blue.shade700,
              ),
            ),
            title: Text(
              contributionFeeResponse.description ?? 'No Description',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: contributionFeeResponse.detail!
                      .map(
                        (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ContributionFeeCard(
                        item: item,
                        contributionFeeResponse: contributionFeeResponse,
                      ),
                    ),
                  )
                      .toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}