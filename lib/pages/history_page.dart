// import 'package:assessment/services/database_helper.dart';
// import 'package:flutter/material.dart';
// import 'dart:convert';

// class HistoryPage extends StatelessWidget {
//   const HistoryPage({super.key});

//   // Future<List<Map<String, dynamic>>> fetchOrderHistory() async {
//   //   return await DatabaseHelper().getOrders();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         title: const Text('Order History'),
//       ),
//       body: FutureBuilder<List<Map<String, dynamic>>>(
//         future: fetchOrderHistory(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return const Center(child: Text('Error fetching order history'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('No order history available'));
//           } else {
//             final orders = snapshot.data!;

//             return ListView.builder(
//               itemCount: orders.length,
//               itemBuilder: (context, index) {
//                 final order = orders[index];
//                 final productDetails =
//                     jsonDecode(order['productDetails']) as Map<String, dynamic>;
//                 final timestamp = DateTime.parse(order['timestamp']).toLocal();

//                 return ListTile(
//                   title: Text(
//                     'Order #${order['id']} - ${order['name']}',
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Phone: +63${order['phone']}'),
//                       Text('Email: ${order['email']}'),
//                       Text('Address: ${order['address']}'),
//                       const SizedBox(height: 5),
//                       Text('Products:'),
//                       ...productDetails.entries.map((entry) {
//                         return Text('${entry.key} x ${entry.value}');
//                       }).toList(),
//                       const SizedBox(height: 5),
//                       Text('Total Price: ₱${order['totalPrice']}'),
//                       Text('Date: ${timestamp.toLocal().toString()}'),
//                     ],
//                   ),
//                   isThreeLine: true,
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }
