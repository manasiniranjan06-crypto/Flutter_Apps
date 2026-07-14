
// import 'package:firebaseauth/customerside/components/gradient_scaffold.dart';
// import 'package:firebaseauth/customerside/screens/order_tracking_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class OrdersPage extends StatefulWidget {
//   const OrdersPage({Key? key}) : super(key: key);

//   @override
//   State<OrdersPage> createState() => _OrdersPageState();
// }

// class _OrdersPageState extends State<OrdersPage> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
  
//   final List<Map<String, dynamic>> orders = [
//     {
//       'orderId': 'ORD-2024-1234',
//       'tailorName': 'Fashion Hub',
//       'tailorImage': 'https://images.unsplash.com/photo-1556906781-9a412961c28c?w=500',
//       'itemName': 'Custom Suit',
//       'itemImage': 'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?w=500',
//       'status': 'In Progress',
//       'orderDate': '10 Oct 2024',
//       'deliveryDate': '20 Oct 2024',
//       'price': 2499,
//       'quantity': 1,
//       'measurements': true,
//       'progress': 0.6,
//     },
//     {
//       'orderId': 'ORD-2024-1233',
//       'tailorName': 'Style Studio',
//       'tailorImage': 'https://images.unsplash.com/photo-1558769132-cb1aea3c1eff?w=500',
//       'itemName': 'Designer Kurta',
//       'itemImage': 'https://images.unsplash.com/photo-1583743814966-8936f5b7be1a?w=500',
//       'status': 'Pending',
//       'orderDate': '09 Oct 2024',
//       'deliveryDate': '19 Oct 2024',
//       'price': 1899,
//       'quantity': 2,
//       'measurements': true,
//       'progress': 0.2,
//     },
//     {
//       'orderId': 'ORD-2024-1232',
//       'tailorName': 'Elite Boutique',
//       'tailorImage': 'https://images.unsplash.com/photo-1567401893414-76b7b1e5a7a5?w=500',
//       'itemName': 'Wedding Dress',
//       'itemImage': 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=500',
//       'status': 'Ready',
//       'orderDate': '05 Oct 2024',
//       'deliveryDate': '11 Oct 2024',
//       'price': 4999,
//       'quantity': 1,
//       'measurements': true,
//       'progress': 1.0,
//     },
//   ];

//   final List<Map<String, dynamic>> completedOrders = [
//     {
//       'orderId': 'ORD-2024-1231',
//       'tailorName': 'Fashion Hub',
//       'tailorImage': 'https://images.unsplash.com/photo-1556906781-9a412961c28c?w=500',
//       'itemName': 'Cotton Shirt',
//       'itemImage': 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=500',
//       'status': 'Delivered',
//       'orderDate': '25 Sep 2024',
//       'deliveryDate': '05 Oct 2024',
//       'price': 899,
//       'quantity': 3,
//       'rated': true,
//       'rating': 4.5,
//     },
//     {
//       'orderId': 'ORD-2024-1230',
//       'tailorName': 'Style Studio',
//       'tailorImage': 'https://images.unsplash.com/photo-1558769132-cb1aea3c1eff?w=500',
//       'itemName': 'Party Gown',
//       'itemImage': 'https://images.unsplash.com/photo-1566174053879-31528523f8ae?w=500',
//       'status': 'Delivered',
//       'orderDate': '15 Sep 2024',
//       'deliveryDate': '28 Sep 2024',
//       'price': 3499,
//       'quantity': 1,
//       'rated': false,
//     },
//   ];

//   final List<Map<String, dynamic>> cancelledOrders = [
//     {
//       'orderId': 'ORD-2024-1229',
//       'tailorName': 'Trend Setters',
//       'tailorImage': 'https://images.unsplash.com/photo-1441984904996-e0b6ba687e04?w=500',
//       'itemName': 'Denim Jacket',
//       'itemImage': 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=500',
//       'status': 'Cancelled',
//       'orderDate': '20 Sep 2024',
//       'cancelDate': '22 Sep 2024',
//       'price': 1599,
//       'quantity': 1,
//       'reason': 'Changed mind',
//     },
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GradientScaffold(
//       appBar: AppBar(
//         title: Text(
//           'My Orders',
//           style: GoogleFonts.poppins(
//             color: Colors.white,
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.search, color: Colors.white),
//             onPressed: () {
//               _showSearchDialog();
//             },
//           ),
//         ],
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(60),
//           child: Container(
//             color: Colors.transparent,
//             child: TabBar(
//               controller: _tabController,
//               labelColor: Colors.white,
//               unselectedLabelColor: Colors.grey[300],
//               indicatorColor: const Color(0xFF8075FF),
//               indicatorWeight: 3,
//               labelStyle: GoogleFonts.poppins(
//                 fontSize: 15,
//                 fontWeight: FontWeight.w600,
//               ),
//               unselectedLabelStyle: GoogleFonts.poppins(
//                 fontSize: 15,
//                 fontWeight: FontWeight.w500,
//               ),
//               tabs: const [
//                 Tab(text: 'Active'),
//                 Tab(text: 'Completed'),
//                 Tab(text: 'Cancelled'),
//               ],
//             ),
//           ),
//         ),
//       ),
//       child: TabBarView(
//         controller: _tabController,
//         children: [
//           _buildActiveOrdersTab(),
//           _buildCompletedOrdersTab(),
//           _buildCancelledOrdersTab(),
//         ],
//       ),
//     );
//   }

//   Widget _buildActiveOrdersTab() {
//     if (orders.isEmpty) {
//       return _buildEmptyState(
//         icon: Icons.shopping_bag_outlined,
//         title: 'No Active Orders',
//         subtitle: 'Your active orders will appear here',
//       );
//     }

//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: orders.length,
//       itemBuilder: (context, index) {
//         return _buildActiveOrderCard(orders[index]);
//       },
//     );
//   }

//   Widget _buildActiveOrderCard(Map<String, dynamic> order) {
//     Color statusColor = _getStatusColor(order['status']);
    
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.06),
//             blurRadius: 15,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(16),
//           onTap: () => _showOrderDetails(order),
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       order['orderId'],
//                       style: GoogleFonts.poppins(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                         color: const Color(0xFF8075FF),
//                       ),
//                     ),
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                       decoration: BoxDecoration(
//                         color: statusColor.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Text(
//                         order['status'],
//                         style: GoogleFonts.poppins(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w600,
//                           color: statusColor,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
                
//                 Row(
//                   children: [
//                     Container(
//                       width: 80,
//                       height: 80,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(
//                           color: const Color(0xFF8075FF).withOpacity(0.2),
//                           width: 2,
//                         ),
//                       ),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(10),
//                         child: Image.network(
//                           order['itemImage'],
//                           fit: BoxFit.cover,
//                           errorBuilder: (context, error, stack) => Container(
//                             color: Colors.grey[200],
//                             child: const Icon(Icons.image, color: Colors.grey),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 16),
                    
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             order['itemName'],
//                             style: GoogleFonts.poppins(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black87,
//                             ),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           const SizedBox(height: 4),
//                           Row(
//                             children: [
//                               Container(
//                                 width: 30,
//                                 height: 30,
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   border: Border.all(
//                                     color: const Color(0xFF8075FF).withOpacity(0.3),
//                                     width: 2,
//                                   ),
//                                 ),
//                                 child: ClipOval(
//                                   child: Image.network(
//                                     order['tailorImage'],
//                                     fit: BoxFit.cover,
//                                     errorBuilder: (context, error, stack) => Icon(
//                                       Icons.store,
//                                       size: 16,
//                                       color: Colors.grey[400],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 8),
//                               Expanded(
//                                 child: Text(
//                                   order['tailorName'],
//                                   style: GoogleFonts.poppins(
//                                     fontSize: 13,
//                                     color: Colors.grey[600],
//                                   ),
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 8),
//                           Row(
//                             children: [
//                               Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
//                               const SizedBox(width: 4),
//                               Text(
//                                 'Delivery: ${order['deliveryDate']}',
//                                 style: GoogleFonts.poppins(
//                                   fontSize: 12,
//                                   color: Colors.grey[600],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
                
//                 const SizedBox(height: 16),
                
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           'Order Progress',
//                           style: GoogleFonts.poppins(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.grey[700],
//                           ),
//                         ),
//                         Text(
//                           '${(order['progress'] * 100).toInt()}%',
//                           style: GoogleFonts.poppins(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w600,
//                             color: const Color(0xFF8075FF),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(10),
//                       child: LinearProgressIndicator(
//                         value: order['progress'],
//                         backgroundColor: Colors.grey[200],
//                         valueColor: AlwaysStoppedAnimation<Color>(statusColor),
//                         minHeight: 8,
//                       ),
//                     ),
//                   ],
//                 ),
                
//                 const SizedBox(height: 16),
//                 const Divider(height: 1),
//                 const SizedBox(height: 12),
                
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Total Amount',
//                           style: GoogleFonts.poppins(
//                             fontSize: 12,
//                             color: Colors.grey[600],
//                           ),
//                         ),
//                         Text(
//                           '₹${order['price']}',
//                           style: GoogleFonts.poppins(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: const Color(0xFF8075FF),
//                           ),
//                         ),
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         if (order['status'] == 'Pending')
//                           OutlinedButton(
//                             onPressed: () => _cancelOrder(order),
//                             style: OutlinedButton.styleFrom(
//                               foregroundColor: Colors.red,
//                               side: const BorderSide(color: Colors.red),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                             ),
//                             child: Text(
//                               'Cancel',
//                               style: GoogleFonts.poppins(fontSize: 12),
//                             ),
//                           ),
//                         if (order['status'] == 'Pending') const SizedBox(width: 8),
//                         ElevatedButton(
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => CustomerOrderTracking(
//                               order: order,
//                               accentColor: Colors.purple,
//                               primaryColor: Colors.blue,
//                               orderId: order['orderId'],
//                               textPrimary: Colors.black,
//                               textSecondary: Colors.grey,
//                               cardColor: Colors.white,
//                             ),

//                               ),
//                             );
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF8075FF),
//                             foregroundColor: Colors.white,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             elevation: 0,
//                           ),
//                           child: Text(
//                             'Track',
//                             style: GoogleFonts.poppins(fontSize: 12),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildCompletedOrdersTab() {
//     if (completedOrders.isEmpty) {
//       return _buildEmptyState(
//         icon: Icons.check_circle_outline,
//         title: 'No Completed Orders',
//         subtitle: 'Your completed orders will appear here',
//       );
//     }

//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: completedOrders.length,
//       itemBuilder: (context, index) {
//         return _buildCompletedOrderCard(completedOrders[index]);
//       },
//     );
//   }

//   Widget _buildCompletedOrderCard(Map<String, dynamic> order) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.06),
//             blurRadius: 15,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   order['orderId'],
//                   style: GoogleFonts.poppins(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     color: const Color(0xFF8075FF),
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: Colors.green.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Row(
//                     children: [
//                       const Icon(Icons.check_circle, size: 14, color: Colors.green),
//                       const SizedBox(width: 4),
//                       Text(
//                         'Delivered',
//                         style: GoogleFonts.poppins(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.green,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
            
//             Row(
//               children: [
//                 Container(
//                   width: 80,
//                   height: 80,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(
//                       color: Colors.green.withOpacity(0.2),
//                       width: 2,
//                     ),
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(10),
//                     child: Image.network(
//                       order['itemImage'],
//                       fit: BoxFit.cover,
//                       errorBuilder: (context, error, stack) => Container(
//                         color: Colors.grey[200],
//                         child: const Icon(Icons.image, color: Colors.grey),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 16),
                
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         order['itemName'],
//                         style: GoogleFonts.poppins(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black87,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         order['tailorName'],
//                         style: GoogleFonts.poppins(
//                           fontSize: 13,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         'Delivered on ${order['deliveryDate']}',
//                         style: GoogleFonts.poppins(
//                           fontSize: 12,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
            
//             const SizedBox(height: 16),
//             const Divider(height: 1),
//             const SizedBox(height: 12),
            
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   '₹${order['price']}',
//                   style: GoogleFonts.poppins(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: const Color(0xFF8075FF),
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     if (order['rated'] == false)
//                       OutlinedButton.icon(
//                         onPressed: () => _showRatingDialog(order),
//                         icon: const Icon(Icons.star_border, size: 18),
//                         label: Text(
//                           'Rate',
//                           style: GoogleFonts.poppins(fontSize: 12),
//                         ),
//                         style: OutlinedButton.styleFrom(
//                           foregroundColor: Colors.amber,
//                           side: const BorderSide(color: Colors.amber),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                       )
//                     else
//                       Row(
//                         children: [
//                           const Icon(Icons.star, color: Colors.amber, size: 18),
//                           const SizedBox(width: 4),
//                           Text(
//                             '${order['rating']}',
//                             style: GoogleFonts.poppins(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.amber,
//                             ),
//                           ),
//                         ],
//                       ),
//                     const SizedBox(width: 8),
//                     ElevatedButton(
//                       onPressed: () => _reorder(order),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF8075FF),
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         elevation: 0,
//                       ),
//                       child: Text(
//                         'Reorder',
//                         style: GoogleFonts.poppins(fontSize: 12),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCancelledOrdersTab() {
//     if (cancelledOrders.isEmpty) {
//       return _buildEmptyState(
//         icon: Icons.cancel_outlined,
//         title: 'No Cancelled Orders',
//         subtitle: 'Your cancelled orders will appear here',
//       );
//     }

//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: cancelledOrders.length,
//       itemBuilder: (context, index) {
//         return _buildCancelledOrderCard(cancelledOrders[index]);
//       },
//     );
//   }

//   Widget _buildCancelledOrderCard(Map<String, dynamic> order) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.06),
//             blurRadius: 15,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   order['orderId'],
//                   style: GoogleFonts.poppins(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     color: const Color(0xFF8075FF),
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: Colors.red.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Text(
//                     'Cancelled',
//                     style: GoogleFonts.poppins(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.red,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
            
//             Row(
//               children: [
//                 Container(
//                   width: 80,
//                   height: 80,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(
//                       color: Colors.red.withOpacity(0.2),
//                       width: 2,
//                     ),
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(10),
//                     child: ColorFiltered(
//                       colorFilter: ColorFilter.mode(
//                         Colors.grey.withOpacity(0.5),
//                         BlendMode.saturation,
//                       ),
//                       child: Image.network(
//                         order['itemImage'],
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stack) => Container(
//                           color: Colors.grey[200],
//                           child: const Icon(Icons.image, color: Colors.grey),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 16),
                
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         order['itemName'],
//                         style: GoogleFonts.poppins(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black87,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         order['tailorName'],
//                         style: GoogleFonts.poppins(
//                           fontSize: 13,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                         decoration: BoxDecoration(
//                           color: Colors.red.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                         child: Text(
//                           'Reason: ${order['reason']}',
//                           style: GoogleFonts.poppins(
//                             fontSize: 11,
//                             color: Colors.red,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
            
//             const SizedBox(height: 16),
//             const Divider(height: 1),
//             const SizedBox(height: 12),
            
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Cancelled on ${order['cancelDate']}',
//                       style: GoogleFonts.poppins(
//                         fontSize: 12,
//                         color: Colors.grey[600],
//                       ),
//                     ),
//                     Text(
//                       '₹${order['price']}',
//                       style: GoogleFonts.poppins(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.grey[600],
//                         decoration: TextDecoration.lineThrough,
//                       ),
//                     ),
//                   ],
//                 ),
//                 ElevatedButton(
//                   onPressed: () => _reorder(order),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF8075FF),
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     elevation: 0,
//                   ),
//                   child: Text(
//                     'Order Again',
//                     style: GoogleFonts.poppins(fontSize: 12),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildEmptyState({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//   }) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(icon, size: 100, color: Colors.grey[300]),
//           const SizedBox(height: 20),
//           Text(
//             title,
//             style: GoogleFonts.poppins(
//               fontSize: 20,
//               fontWeight: FontWeight.w600,
//               color: Colors.grey[600],
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             subtitle,
//             style: GoogleFonts.poppins(
//               fontSize: 14,
//               color: Colors.grey[500],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showSearchDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(
//           'Search Orders',
//           style: GoogleFonts.poppins(
//             fontWeight: FontWeight.bold,
//             color: const Color(0xFF8075FF),
//           ),
//         ),
//         content: TextField(
//           decoration: InputDecoration(
//             hintText: 'Search by order ID, item name...',
//             prefixIcon: const Icon(Icons.search),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: const Text('Search'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showOrderDetails(Map<String, dynamic> order) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => Container(
//         height: MediaQuery.of(context).size.height * 0.8,
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(25),
//             topRight: Radius.circular(25),
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Center(
//                 child: Container(
//                   width: 60,
//                   height: 4,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[300],
//                     borderRadius: BorderRadius.circular(2),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 'Order Details',
//                 style: GoogleFonts.poppins(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: const Color(0xFF8075FF),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 'Order ID: ${order['orderId']}',
//                 style: GoogleFonts.poppins(fontSize: 16),
//               ),
//               const SizedBox(height: 10),
//               Text(
//                 'Item: ${order['itemName']}',
//                 style: GoogleFonts.poppins(fontSize: 16),
//               ),
//               const SizedBox(height: 10),
//               Text(
//                 'Tailor: ${order['tailorName']}',
//                 style: GoogleFonts.poppins(fontSize: 16),
//               ),
//               const Spacer(),
//               ElevatedButton(
//                 onPressed: () => Navigator.pop(context),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF8075FF),
//                   foregroundColor: Colors.white,
//                   minimumSize: const Size(double.infinity, 50),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: Text(
//                   'Close',
//                   style: GoogleFonts.poppins(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _cancelOrder(Map<String, dynamic> order) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(
//           'Cancel Order?',
//           style: GoogleFonts.poppins(
//             fontWeight: FontWeight.bold,
//             color: Colors.red,
//           ),
//         ),
//         content: Text(
//           'Are you sure you want to cancel order ${order['orderId']}?',
//           style: GoogleFonts.poppins(),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('No'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               _showSnackBar('Order ${order['orderId']} cancelled');
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//             ),
//             child: const Text('Yes, Cancel'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showRatingDialog(Map<String, dynamic> order) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(
//           'Rate Order',
//           style: GoogleFonts.poppins(
//             fontWeight: FontWeight.bold,
//             color: const Color(0xFF8075FF),
//           ),
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               'How was your experience with ${order['itemName']}?',
//               style: GoogleFonts.poppins(),
//             ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: List.generate(5, (index) => Icon(
//                 Icons.star,
//                 color: index < 4 ? Colors.amber : Colors.grey[300],
//                 size: 30,
//               )),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               _showSnackBar('Thank you for your rating!');
//             },
//             child: const Text('Submit Rating'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _reorder(Map<String, dynamic> order) {
//     _showSnackBar('${order['itemName']} added to cart for reorder');
//   }

//   Color _getStatusColor(String status) {
//     switch (status) {
//       case 'Pending':
//         return Colors.orange;
//       case 'In Progress':
//         return Colors.blue;
//       case 'Ready':
//         return Colors.green;
//       default:
//         return Colors.grey;
//     }
//   }

//   void _showSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         behavior: SnackBarBehavior.floating,
//         duration: const Duration(seconds: 2),
//         backgroundColor: const Color(0xFF8075FF),
//       ),
//     );
//   }
// }

import 'dart:async';

import 'package:firebaseauth/customerside/components/gradient_scaffold.dart';
import 'package:firebaseauth/customerside/screens/order_tracking_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  
  List<Map<String, dynamic>> _activeOrders = [];
  List<Map<String, dynamic>> _completedOrders = [];
  List<Map<String, dynamic>> _cancelledOrders = [];
  bool _isLoading = true;
  String _errorMessage = '';
  bool _needsIndex = false;

  StreamSubscription<QuerySnapshot>? _ordersSubscription;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchOrders();
    _setupRealTimeListener();
  }

  void _setupRealTimeListener() {
    if (_currentUser != null) {
      _ordersSubscription = _firestore
          .collection('tailor_orders')
          .where('customerId', isEqualTo: _currentUser!.uid)
          .snapshots()
          .listen((snapshot) {
        _processOrders(snapshot.docs);
        if (mounted) {
          setState(() {});
        }
      }, onError: (error) {
        print('Real-time listener error: $error');
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _ordersSubscription?.cancel();
    super.dispose();
  }

  Future<void> _fetchOrders() async {
    if (_currentUser == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'User not logged in';
      });
      return;
    }

    try {
      Query query = _firestore
          .collection('tailor_orders')
          .where('customerId', isEqualTo: _currentUser!.uid)
          .orderBy('orderDate', descending: true);

      final querySnapshot = await query.get();
      _processOrders(querySnapshot.docs);
      
      setState(() {
        _isLoading = false;
        _needsIndex = false;
      });
    } catch (e) {
      if (e.toString().contains('index')) {
        await _fetchOrdersWithoutIndex();
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to load orders: $e';
        });
      }
    }
  }

  Future<void> _fetchOrdersWithoutIndex() async {
    try {
      final querySnapshot = await _firestore
          .collection('tailor_orders')
          .where('customerId', isEqualTo: _currentUser!.uid)
          .get();

      final docs = querySnapshot.docs;
      docs.sort((a, b) {
        final aDate = _getOrderDate(a.data());
        final bDate = _getOrderDate(b.data());
        return bDate.compareTo(aDate);
      });

      _processOrders(docs);
      
      setState(() {
        _isLoading = false;
        _needsIndex = true;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load orders: $e';
      });
    }
  }

  DateTime _getOrderDate(Map<String, dynamic> data) {
    final orderDate = data['orderDate'];
    if (orderDate is Timestamp) {
      return orderDate.toDate();
    } else if (orderDate is DateTime) {
      return orderDate;
    } else {
      return DateTime.now();
    }
  }

  void _processOrders(List<QueryDocumentSnapshot> docs) {
    _activeOrders.clear();
    _completedOrders.clear();
    _cancelledOrders.clear();

    for (var doc in docs) {
      final data = doc.data() as Map<String, dynamic>;
      
      final List<dynamic> items = data['items'] ?? [];
      final Map<String, dynamic> firstItem = items.isNotEmpty ? items[0] : {};
      
      // Generate proper order ID
      String orderId = data['orderId'] ?? 'ORD-${doc.id.substring(0, 8).toUpperCase()}';
      
      // Get order date for sorting
      DateTime orderDateTime = _getOrderDate(data);
      
      final order = {
        'id': doc.id,
        'orderId': orderId,
        'tailorName': data['tailorName'] ?? 'Unknown Tailor',
        'tailorId': data['tailorId'] ?? '',
        'tailorImage': data['tailorImage'] ?? 'https://images.unsplash.com/photo-1567401893414-76b7b1e5a7a5?w=150',
        'itemName': firstItem['garmentType'] ?? 'Custom Order',
        'itemImage': firstItem['itemImage'] ?? _getDefaultItemImage(firstItem['garmentType']),
        'status': data['status'] ?? 'pending',
        'orderDate': _formatDate(data['orderDate']),
        'orderDateTime': orderDateTime,
        'deliveryDate': _formatDate(data['deliveryDate']),
        'price': (data['totalAmount'] ?? 0).toDouble(),
        'quantity': _calculateTotalQuantity(items),
        'progress': _calculateProgress(data['status'] ?? 'pending'),
        'measurements': _hasMeasurements(items),
        'rated': data['rated'] ?? false,
        'rating': (data['rating'] ?? 0).toDouble(),
        'cancelDate': _formatDate(data['cancelDate']),
        'reason': data['reason'] ?? 'Not specified',
        'items': items,
        'customerName': data['customerName'] ?? '',
        'customerPhone': data['customerPhone'] ?? '',
        'specialInstructions': firstItem['specialInstructions'] ?? '',
      };

      final status = order['status'].toString().toLowerCase();
      if (status == 'delivered' || status == 'completed') {
        _completedOrders.add(order);
      } else if (status == 'cancelled' || status == 'rejected') {
        _cancelledOrders.add(order);
      } else {
        _activeOrders.add(order);
      }
    }

    // Sort all lists by date
    _activeOrders.sort((a, b) => b['orderDateTime'].compareTo(a['orderDateTime']));
    _completedOrders.sort((a, b) => b['orderDateTime'].compareTo(a['orderDateTime']));
    _cancelledOrders.sort((a, b) => b['orderDateTime'].compareTo(a['orderDateTime']));
  }

  String _getDefaultItemImage(String? garmentType) {
    const defaultImage = 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=150';
    
    final images = {
      'shirt': 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=150',
      'trouser': 'https://images.unsplash.com/photo-1542272604-787c3835535d?w=150',
      'dress': 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=150',
      'kurta': 'https://images.unsplash.com/photo-1583743814966-8936f5b7be1a?w=150',
      'blouse': 'https://images.unsplash.com/photo-1583496661160-fb5886a13d77?w=150',
      'suit': 'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?w=150',
      'jacket': 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=150',
      'sherwani': 'https://images.unsplash.com/photo-1583743814966-8936f5b7be1a?w=150',
      'lehenga': 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=150',
      'waistcoat': 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=150',
      'shorts': 'https://images.unsplash.com/photo-1542272604-787c3835535d?w=150',
      'jumpsuit': 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=150',
      'other': 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=150',
    };
    
    if (garmentType != null) {
      return images[garmentType.toLowerCase()] ?? defaultImage;
    }
    return defaultImage;
  }

  int _calculateTotalQuantity(List<dynamic> items) {
    int total = 0;
    for (var item in items) {
      total += (item['quantity'] ?? 1) as int;
    }
    return total;
  }

  bool _hasMeasurements(List<dynamic> items) {
    for (var item in items) {
      final measurements = item['measurements'] ?? {};
      if (measurements.isNotEmpty && measurements.values.any((value) => value.toString().isNotEmpty)) {
        return true;
      }
    }
    return false;
  }

  double _calculateProgress(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 0.2;
      case 'confirmed':
      case 'accepted':
        return 0.4;
      case 'in progress':
      case 'production':
        return 0.6;
      case 'ready for fitting':
      case 'fitting':
        return 0.8;
      case 'ready':
      case 'completed':
        return 1.0;
      case 'delivered':
        return 1.0;
      default:
        return 0.0;
    }
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'Not set';
    if (date is Timestamp) {
      return DateFormat('dd MMM yyyy').format(date.toDate());
    }
    if (date is DateTime) {
      return DateFormat('dd MMM yyyy').format(date);
    }
    return date.toString();
  }

  Future<void> _refreshOrders() async {
    setState(() {
      _isLoading = true;
    });
    await _fetchOrders();
  }

  void _createIndex() {
    _showSnackBar('Please create the index in Firebase Console and try again.');
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        title: Text(
          'My Orders',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: _showSearchDialog,
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _refreshOrders,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            color: Colors.transparent,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey[300],
              indicatorColor: const Color(0xFF8075FF),
              indicatorWeight: 3,
              labelStyle: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              tabs: const [
                Tab(text: 'Active'),
                Tab(text: 'Completed'),
                Tab(text: 'Cancelled'),
              ],
            ),
          ),
        ),
      ),
      child: _isLoading
          ? _buildLoadingState()
          : _needsIndex
              ? _buildIndexPrompt()
              : _errorMessage.isNotEmpty
                  ? _buildErrorState()
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        _buildActiveOrdersTab(),
                        _buildCompletedOrdersTab(),
                        _buildCancelledOrdersTab(),
                      ],
                    ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8075FF)),
      ),
    );
  }

  Widget _buildIndexPrompt() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.build, size: 80, color: Colors.orange[300]),
            const SizedBox(height: 20),
            Text(
              'Index Required',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'For better performance, please create a Firestore index for order queries.',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _refreshOrders,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8075FF),
                foregroundColor: Colors.white,
              ),
              child: Text(
                'Try Again',
                style: GoogleFonts.poppins(),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: _createIndex,
              child: Text(
                'Learn More',
                style: GoogleFonts.poppins(
                  color: const Color(0xFF8075FF),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: Colors.red[300]),
            const SizedBox(height: 20),
            Text(
              'Error Loading Orders',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _errorMessage,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _refreshOrders,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8075FF),
                foregroundColor: Colors.white,
              ),
              child: Text(
                'Try Again',
                style: GoogleFonts.poppins(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveOrdersTab() {
    if (_activeOrders.isEmpty) {
      return _buildEmptyState(
        icon: Icons.shopping_bag_outlined,
        title: 'No Active Orders',
        subtitle: 'Your active orders will appear here',
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshOrders,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _activeOrders.length,
        itemBuilder: (context, index) {
          return _buildActiveOrderCard(_activeOrders[index]);
        },
      ),
    );
  }

  Widget _buildCompletedOrdersTab() {
    if (_completedOrders.isEmpty) {
      return _buildEmptyState(
        icon: Icons.check_circle_outline,
        title: 'No Completed Orders',
        subtitle: 'Your completed orders will appear here',
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshOrders,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _completedOrders.length,
        itemBuilder: (context, index) {
          return _buildCompletedOrderCard(_completedOrders[index]);
        },
      ),
    );
  }

  Widget _buildCancelledOrdersTab() {
    if (_cancelledOrders.isEmpty) {
      return _buildEmptyState(
        icon: Icons.cancel_outlined,
        title: 'No Cancelled Orders',
        subtitle: 'Your cancelled orders will appear here',
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshOrders,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _cancelledOrders.length,
        itemBuilder: (context, index) {
          return _buildCancelledOrderCard(_cancelledOrders[index]);
        },
      ),
    );
  }

  Widget _buildActiveOrderCard(Map<String, dynamic> order) {
    Color statusColor = _getStatusColor(order['status']);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showOrderDetails(order),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      order['orderId'],
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF8075FF),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _formatStatus(order['status']),
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF8075FF).withOpacity(0.2),
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          order['itemImage'],
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: Colors.grey[200],
                              child: const Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8075FF)),
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stack) => Container(
                            color: Colors.grey[200],
                            child: Icon(Icons.inventory_2_outlined, color: Colors.grey[400]),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order['itemName'],
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFF8075FF).withOpacity(0.3),
                                    width: 2,
                                  ),
                                ),
                                child: ClipOval(
                                  child: Image.network(
                                    order['tailorImage'],
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stack) => Icon(
                                      Icons.store,
                                      size: 16,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  order['tailorName'],
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(
                                'Delivery: ${order['deliveryDate']}',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Order Progress',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                        Text(
                          '${(order['progress'] * 100).toInt()}%',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF8075FF),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: order['progress'],
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 12),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Amount',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          '₹${order['price']}',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF8075FF),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        if (order['status'].toString().toLowerCase() == 'pending')
                          OutlinedButton(
                            onPressed: () => _cancelOrder(order),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.poppins(fontSize: 12),
                            ),
                          ),
                        if (order['status'].toString().toLowerCase() == 'pending') 
                          const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CustomerOrderTracking(
                                  order: order,
                                  accentColor: Colors.purple,
                                  primaryColor: Colors.blue,
                                  orderId: order['orderId'],
                                  textPrimary: Colors.black,
                                  textSecondary: Colors.grey,
                                  cardColor: Colors.white,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8075FF),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Track',
                            style: GoogleFonts.poppins(fontSize: 12),
                          ),
                        ),
                      ],
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

  Widget _buildCompletedOrderCard(Map<String, dynamic> order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order['orderId'],
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF8075FF),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, size: 14, color: Colors.green),
                      const SizedBox(width: 4),
                      Text(
                        'Delivered',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.green.withOpacity(0.2),
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      order['itemImage'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stack) => Container(
                        color: Colors.grey[200],
                        child: Icon(Icons.inventory_2_outlined, color: Colors.grey[400]),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order['itemName'],
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        order['tailorName'],
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Delivered on ${order['deliveryDate']}',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 12),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '₹${order['price']}',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF8075FF),
                  ),
                ),
                Row(
                  children: [
                    if (order['rated'] == false)
                      OutlinedButton.icon(
                        onPressed: () => _showRatingDialog(order),
                        icon: const Icon(Icons.star_border, size: 18),
                        label: Text(
                          'Rate',
                          style: GoogleFonts.poppins(fontSize: 12),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.amber,
                          side: const BorderSide(color: Colors.amber),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      )
                    else
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            '${order['rating']}',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.amber,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => _reorder(order),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8075FF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Reorder',
                        style: GoogleFonts.poppins(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCancelledOrderCard(Map<String, dynamic> order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order['orderId'],
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF8075FF),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Cancelled',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.red.withOpacity(0.2),
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        Colors.grey.withOpacity(0.5),
                        BlendMode.saturation,
                      ),
                      child: Image.network(
                        order['itemImage'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stack) => Container(
                          color: Colors.grey[200],
                          child: Icon(Icons.inventory_2_outlined, color: Colors.grey[400]),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order['itemName'],
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        order['tailorName'],
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Reason: ${order['reason']}',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 12),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cancelled on ${order['cancelDate']}',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      '₹${order['price']}',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () => _reorder(order),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8075FF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Order Again',
                    style: GoogleFonts.poppins(fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return RefreshIndicator(
      onRefresh: _refreshOrders,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 100, color: Colors.grey[300]),
                const SizedBox(height: 20),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Search Orders',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF8075FF),
          ),
        ),
        content: TextField(
          decoration: InputDecoration(
            hintText: 'Search by order ID, item name...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  void _showOrderDetails(Map<String, dynamic> order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildOrderDetailsSheet(order),
    );
  }

  Widget _buildOrderDetailsSheet(Map<String, dynamic> order) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 60,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Order Details',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF8075FF),
              ),
            ),
            const SizedBox(height: 20),
            
            Expanded(
              child: ListView(
                children: [
                  _buildDetailItem('Order ID', order['orderId']),
                  _buildDetailItem('Tailor', order['tailorName']),
                  _buildDetailItem('Status', _formatStatus(order['status'])),
                  _buildDetailItem('Order Date', order['orderDate']),
                  _buildDetailItem('Delivery Date', order['deliveryDate']),
                  _buildDetailItem('Total Amount', '₹${order['price']}'),
                  
                  const SizedBox(height: 20),
                  Text(
                    'Order Items:',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  
                  ...List.generate(order['items'].length, (index) {
                    final item = order['items'][index];
                    return _buildOrderItemDetail(item, index + 1);
                  }),
                ],
              ),
            ),
            
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8075FF),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Close',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$title:',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItemDetail(Map<String, dynamic> item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Item $index: ${item['garmentType']}',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text('Fabric: ${item['fabric']}'),
          Text('Color: ${item['color']}'),
          Text('Quantity: ${item['quantity']}'),
          Text('Price: ₹${item['price']}'),
          if (item['specialInstructions'] != null && item['specialInstructions'].isNotEmpty)
            Text('Instructions: ${item['specialInstructions']}'),
        ],
      ),
    );
  }

  void _cancelOrder(Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Cancel Order?',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        content: Text(
          'Are you sure you want to cancel order ${order['orderId']}?',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await _firestore.collection('tailor_orders').doc(order['id']).update({
                  'status': 'cancelled',
                  'reason': 'Cancelled by customer',
                  'cancelDate': DateTime.now(),
                  'updatedAt': FieldValue.serverTimestamp(),
                });
                _showSnackBar('Order ${order['orderId']} cancelled');
                _refreshOrders();
              } catch (e) {
                _showSnackBar('Failed to cancel order: $e', isError: true);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  void _showRatingDialog(Map<String, dynamic> order) {
    double rating = 0;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(
              'Rate Order',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF8075FF),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'How was your experience with ${order['itemName']}?',
                  style: GoogleFonts.poppins(),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      onPressed: () {
                        setState(() {
                          rating = (index + 1).toDouble();
                        });
                      },
                      icon: Icon(
                        Icons.star,
                        color: index < rating ? Colors.amber : Colors.grey[300],
                        size: 30,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 10),
                Text(
                  rating == 0 ? 'Tap to rate' : 'Rating: $rating/5',
                  style: GoogleFonts.poppins(),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: rating == 0 ? null : () async {
                  Navigator.pop(context);
                  try {
                    await _firestore.collection('tailor_orders').doc(order['id']).update({
                      'rated': true,
                      'rating': rating,
                      'updatedAt': FieldValue.serverTimestamp(),
                    });
                    _showSnackBar('Thank you for your rating!');
                    _refreshOrders();
                  } catch (e) {
                    _showSnackBar('Failed to submit rating: $e', isError: true);
                  }
                },
                child: const Text('Submit Rating'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _reorder(Map<String, dynamic> order) {
    _showSnackBar('${order['itemName']} added to cart for reorder');
  }

  Color _getStatusColor(String status) {
    final statusLower = status.toLowerCase();
    switch (statusLower) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
      case 'accepted':
        return Colors.blue;
      case 'in progress':
      case 'production':
        return Colors.blue;
      case 'ready for fitting':
      case 'fitting':
        return Colors.purple;
      case 'ready':
        return Colors.green;
      case 'delivered':
      case 'completed':
        return Colors.green;
      case 'cancelled':
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatStatus(String status) {
    final statusLower = status.toLowerCase();
    switch (statusLower) {
      case 'pending':
        return 'Pending';
      case 'confirmed':
      case 'accepted':
        return 'Confirmed';
      case 'in progress':
      case 'production':
        return 'In Progress';
      case 'ready for fitting':
      case 'fitting':
        return 'Ready for Fitting';
      case 'ready':
        return 'Ready';
      case 'delivered':
      case 'completed':
        return 'Delivered';
      case 'cancelled':
      case 'rejected':
        return 'Cancelled';
      default:
        return status;
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        backgroundColor: isError ? Colors.red : const Color(0xFF8075FF),
      ),
    );
  }
}