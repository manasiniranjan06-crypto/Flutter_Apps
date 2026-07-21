

// // tailor_profile_screen.dart
// import 'package:firebaseauth/TailorSide/sqflite/tailor_profile_databse.dart';
// import 'package:firebaseauth/TailorSide/view/role_selection.dart';
// import 'package:firebaseauth/TailorSide/view/tailor_appointmentScren.dart';
// import 'package:firebaseauth/TailorSide/view/tailor_bussimess_Anayltic.dart';
// import 'package:firebaseauth/TailorSide/view/tailor_inventory_management.dart';
// import 'package:firebaseauth/TailorSide/view/tailor_supportHalp.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'dart:io';
// import 'package:image_picker/image_picker.dart';

// class TailorProfileScreen extends StatefulWidget {
//   const TailorProfileScreen({Key? key}) : super(key: key);

//   @override
//   State<TailorProfileScreen> createState() => _TailorProfileScreenState();
// }

// class _TailorProfileScreenState extends State<TailorProfileScreen> {
//   // Database helper instance
//   final TailorDatabaseHelper _databaseHelper = TailorDatabaseHelper();

//   // TextEditingControllers for all fields
//   late TextEditingController shopNameController;
//   late TextEditingController ownerNameController;
//   late TextEditingController emailController;
//   late TextEditingController phoneController;
//   late TextEditingController addressController;
//   late TextEditingController experienceController;
//   late TextEditingController specializationController;
//   late TextEditingController descriptionController;
//   late TextEditingController workingHoursController;

//   // Tailor data with default values
//   int? profileId;
//   String shopName = "";
//   String ownerName = "";
//   String email = "";
//   String phone = "";
//   String address = "";
//   String experience = "";
//   String specialization = "";
//   String description = "";
//   String workingHours = "";
//   double rating = 0.0;
//   int totalOrders = 0;
//   int pendingOrders = 0;
//   int completedOrders = 0;
//   bool isShopOpen = true;
//   String? shopLogoPath;

//   // Shop images
//   final ImagePicker _imagePicker = ImagePicker();
//   File? _shopLogo;
//   List<File> _shopImages = [];
//   List<String> _shopImagePaths = [];

//   // Services
//   List<Map<String, dynamic>> _services = [];

//   @override
//   void initState() {
//     super.initState();
    
//     // Initialize controllers
//     shopNameController = TextEditingController();
//     ownerNameController = TextEditingController();
//     emailController = TextEditingController();
//     phoneController = TextEditingController();
//     addressController = TextEditingController();
//     experienceController = TextEditingController();
//     specializationController = TextEditingController();
//     descriptionController = TextEditingController();
//     workingHoursController = TextEditingController();
    
//     _initializeData();
//   }

//   @override
//   void dispose() {
//     // Dispose all controllers
//     shopNameController.dispose();
//     ownerNameController.dispose();
//     emailController.dispose();
//     phoneController.dispose();
//     addressController.dispose();
//     experienceController.dispose();
//     specializationController.dispose();
//     descriptionController.dispose();
//     workingHoursController.dispose();
//     super.dispose();
//   }

//   // Initialize data from database
//   Future<void> _initializeData() async {
//     await _databaseHelper.initializeDefaultProfile();
//     await _loadTailorData();
//     await _loadShopImages();
//     await _loadServices();
//   }

//   // Load tailor data from database
//   Future<void> _loadTailorData() async {
//     final profile = await _databaseHelper.getTailorProfile();
    
//     if (profile != null) {
//       setState(() {
//         profileId = profile['id'];
//         shopName = profile['shop_name'] ?? "";
//         ownerName = profile['owner_name'] ?? "";
//         email = profile['email'] ?? "";
//         phone = profile['phone'] ?? "";
//         address = profile['address'] ?? "";
//         experience = profile['experience'] ?? "";
//         specialization = profile['specialization'] ?? "";
//         description = profile['description'] ?? "";
//         workingHours = profile['working_hours'] ?? "9:00 AM - 7:00 PM";
//         rating = profile['rating']?.toDouble() ?? 0.0;
//         totalOrders = profile['total_orders'] ?? 0;
//         pendingOrders = profile['pending_orders'] ?? 0;
//         completedOrders = profile['completed_orders'] ?? 0;
//         isShopOpen = profile['is_shop_open'] == 1;
//         shopLogoPath = profile['shop_logo_path'];
        
//         // Set controller values
//         shopNameController.text = shopName;
//         ownerNameController.text = ownerName;
//         emailController.text = email;
//         phoneController.text = phone;
//         addressController.text = address;
//         experienceController.text = experience;
//         specializationController.text = specialization;
//         descriptionController.text = description;
//         workingHoursController.text = workingHours;
        
//         // Load shop logo if path exists
//         if (shopLogoPath != null && shopLogoPath!.isNotEmpty) {
//           _shopLogo = File(shopLogoPath!);
//         }
//       });
//     }
//   }

//   // Load shop images from database
//   Future<void> _loadShopImages() async {
//     final imagePaths = await _databaseHelper.getShopImages();
//     setState(() {
//       _shopImagePaths = imagePaths;
//       _shopImages = imagePaths.map((path) => File(path)).toList();
//     });
//   }

//   // Load services from database
//   Future<void> _loadServices() async {
//     final services = await _databaseHelper.getServices();
//     setState(() {
//       _services = services;
//     });
//   }

//   // Save tailor data to database
//   Future<void> _saveTailorData() async {
//     if (profileId != null) {
//       await _databaseHelper.updateTailorProfile({
//         'id': profileId,
//         'shop_name': shopName,
//         'owner_name': ownerName,
//         'email': email,
//         'phone': phone,
//         'address': address,
//         'experience': experience,
//         'specialization': specialization,
//         'description': description,
//         'working_hours': workingHours,
//         'rating': rating,
//         'total_orders': totalOrders,
//         'pending_orders': pendingOrders,
//         'completed_orders': completedOrders,
//         'is_shop_open': isShopOpen ? 1 : 0,
//         'shop_logo_path': shopLogoPath,
//       });
//     }
//   }

//   // Update single field in database
//   Future<void> _updateField(String field, dynamic value) async {
//     await _databaseHelper.updateTailorProfileField(field, value);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       body: CustomScrollView(
//         slivers: [
//           // Shop Header
//           SliverAppBar(
//             expandedHeight: 280,
//             floating: false,
//             pinned: true,
//             flexibleSpace: FlexibleSpaceBar(
//               background: _buildShopHeader(),
//               title: Text(
//                 shopName.isNotEmpty ? shopName : 'Tailor Shop',
//                 style: GoogleFonts.poppins(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   shadows: [
//                     Shadow(
//                       color: Colors.black.withOpacity(0.8),
//                       blurRadius: 10,
//                     ),
//                   ],
//                 ),
//               ),
//               centerTitle: true,
//             ),
//             actions: [
//               IconButton(
//                 icon: const Icon(Icons.edit, color: Colors.white),
//                 onPressed: () => _showEditShopDialog(context),
//               ),
//             ],
//           ),

//           // Shop Content
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Business Status & Rating
//                   _buildStatusCard(),
//                   const SizedBox(height: 20),

//                   // Order Statistics
//                   _buildOrderStats(),
//                   const SizedBox(height: 20),

//                   // Shop Information
//                   _buildSectionHeader('Shop Information'),
//                   const SizedBox(height: 12),
//                   _buildInfoCard(
//                     icon: Icons.store,
//                     title: 'Shop Name',
//                     subtitle: shopName.isNotEmpty ? shopName : 'Tap to add shop name',
//                     onTap: () => _showEditDialog(
//                       context, 
//                       'Shop Name', 
//                       shopName, 
//                       shopNameController,
//                       (value) {
//                         setState(() {
//                           shopName = value;
//                         });
//                         _updateField('shop_name', value);
//                       }
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   _buildInfoCard(
//                     icon: Icons.person,
//                     title: 'Owner Name',
//                     subtitle: ownerName.isNotEmpty ? ownerName : 'Tap to add owner name',
//                     onTap: () => _showEditDialog(
//                       context, 
//                       'Owner Name', 
//                       ownerName, 
//                       ownerNameController,
//                       (value) {
//                         setState(() {
//                           ownerName = value;
//                         });
//                         _updateField('owner_name', value);
//                       }
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   _buildInfoCard(
//                     icon: Icons.phone,
//                     title: 'Contact Number',
//                     subtitle: phone.isNotEmpty ? phone : 'Tap to add contact number',
//                     onTap: () => _showEditDialog(
//                       context, 
//                       'Phone', 
//                       phone, 
//                       phoneController,
//                       (value) {
//                         setState(() {
//                           phone = value;
//                         });
//                         _updateField('phone', value);
//                       }
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   _buildInfoCard(
//                     icon: Icons.email,
//                     title: 'Email',
//                     subtitle: email.isNotEmpty ? email : 'Tap to add email',
//                     onTap: () => _showEditDialog(
//                       context, 
//                       'Email', 
//                       email, 
//                       emailController,
//                       (value) {
//                         setState(() {
//                           email = value;
//                         });
//                         _updateField('email', value);
//                       }
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   _buildInfoCard(
//                     icon: Icons.location_on,
//                     title: 'Shop Address',
//                     subtitle: address.isNotEmpty ? address : 'Tap to add shop address',
//                     onTap: () => _showEditDialog(
//                       context, 
//                       'Address', 
//                       address, 
//                       addressController,
//                       (value) {
//                         setState(() {
//                           address = value;
//                         });
//                         _updateField('address', value);
//                       },
//                       maxLines: 3,
//                     ),
//                   ),
//                   const SizedBox(height: 20),

//                   // Professional Details
//                   _buildSectionHeader('Professional Details'),
//                   const SizedBox(height: 12),
//                   _buildInfoCard(
//                     icon: Icons.work_history,
//                     title: 'Experience',
//                     subtitle: experience.isNotEmpty ? '$experience years' : 'Tap to add experience',
//                     onTap: () => _showEditDialog(
//                       context, 
//                       'Experience (years)', 
//                       experience, 
//                       experienceController,
//                       (value) {
//                         setState(() {
//                           experience = value;
//                         });
//                         _updateField('experience', value);
//                       }
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   _buildInfoCard(
//                     icon: Icons.style,
//                     title: 'Specialization',
//                     subtitle: specialization.isNotEmpty ? specialization : 'Tap to add specialization',
//                     onTap: () => _showEditDialog(
//                       context, 
//                       'Specialization', 
//                       specialization, 
//                       specializationController,
//                       (value) {
//                         setState(() {
//                           specialization = value;
//                         });
//                         _updateField('specialization', value);
//                       }
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   _buildInfoCard(
//                     icon: Icons.schedule,
//                     title: 'Working Hours',
//                     subtitle: workingHours.isNotEmpty ? workingHours : 'Tap to add working hours',
//                     onTap: () => _showEditDialog(
//                       context, 
//                       'Working Hours', 
//                       workingHours, 
//                       workingHoursController,
//                       (value) {
//                         setState(() {
//                           workingHours = value;
//                         });
//                         _updateField('working_hours', value);
//                       }
//                     ),
//                   ),
//                   const SizedBox(height: 20),

//                   // Shop Description
//                   _buildDescriptionCard(),
//                   const SizedBox(height: 20),

//                   // Shop Gallery
//                   _buildGallerySection(),
//                   const SizedBox(height: 20),

//                   // Services & Pricing
//                   _buildServicesSection(),
//                   const SizedBox(height: 20),

//                   // Business Tools
//                   _buildSectionHeader('Business Tools'),
//                   const SizedBox(height: 12),
//                  // In your TailorProfileScreen, update the Business Tools section:
//                   _buildBusinessToolCard(
//                     icon: Icons.inventory,
//                     title: 'Inventory Management',
//                     subtitle: 'Manage fabrics and materials',
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>  InventoryManagementScreen(),
//                         ),
//                       );
//                     },
//                   ),
//                   const SizedBox(height: 12),
//                   // In your TailorProfileScreen, update the Order Management card:
//                     _buildBusinessToolCard(
//                       icon: Icons.assignment,
//                       title: 'Support & Help',
//                       subtitle: 'Customer Support',
//                       onTap: () {
//                           Navigator.push(context, MaterialPageRoute(builder: (context) => const TailorHelpSupportPage()));
      
//                       },
//                     ),
//                   const SizedBox(height: 12),
//                  _buildBusinessToolCard(
//                             icon: Icons.analytics,
//                             title: 'Business Analytics',
//                             subtitle: 'View sales and performance',
//                             onTap: () {
//                              Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => const BusinessAnalyticsPage(),
//                               ),
//                             );
//                             }
//                           ),
//                   const SizedBox(height: 12),
//                   _buildBusinessToolCard(
//                     icon: Icons.calendar_today,
//                     title: 'Appointment Schedule',
//                     subtitle: 'Manage customer appointments',
//                     onTap: () {
//                        Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => const AppointmentScheduleScreen(),
//                               ),
//                             );
//                     }
//                   ),
//                   const SizedBox(height: 24),

//                   // Logout Button
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton.icon(
//                       onPressed: () => _showLogoutDialog(context),
//                       icon: const Icon(Icons.logout),
//                       label: const Text(
//                         'Logout',
//                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red.shade400,
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ----------------- Header Section -----------------
//   Widget _buildShopHeader() {
//     return Stack(
//       children: [
//         // Shop background image
//         Container(
//           height: 280,
//           width: double.infinity,
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [
//                 const Color(0xFF6A5ACD),
//                 const Color(0xFF836FFF),
//               ],
//             ),
//           ),
//           child: _shopImages.isNotEmpty
//               ? PageView.builder(
//                   itemCount: _shopImages.length,
//                   itemBuilder: (context, index) {
//                     return Image.file(
//                       _shopImages[index],
//                       fit: BoxFit.cover,
//                     );
//                   },
//                 )
//               : Container(
//                   color: const Color(0xFF6A5ACD),
//                   child: Icon(
//                     Icons.store,
//                     size: 80,
//                     color: Colors.white.withOpacity(0.3),
//                   ),
//                 ),
//         ),

//         // Gradient overlay
//         Container(
//           height: 280,
//           width: double.infinity,
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Colors.transparent,
//                 Colors.black.withOpacity(0.6),
//               ],
//             ),
//           ),
//         ),

//         // Shop logo and basic info
//         Positioned(
//           bottom: 16,
//           left: 16,
//           right: 16,
//           child: Row(
//             children: [
//               // Shop Logo
//               GestureDetector(
//                 onTap: _showLogoPickerBottomSheet,
//                 child: Container(
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     border: Border.all(color: Colors.white, width: 3),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.3),
//                         blurRadius: 8,
//                         offset: const Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: Stack(
//                     children: [
//                       CircleAvatar(
//                         radius: 40,
//                         backgroundColor: Colors.white,
//                         backgroundImage: _shopLogo != null
//                             ? FileImage(_shopLogo!)
//                             : null,
//                         child: _shopLogo == null
//                             ? Icon(
//                                 Icons.store,
//                                 size: 40,
//                                 color: const Color(0xFF6A5ACD),
//                               )
//                             : null,
//                       ),
//                       Positioned(
//                         bottom: 0,
//                         right: 0,
//                         child: Container(
//                           padding: const EdgeInsets.all(6),
//                           decoration: const BoxDecoration(
//                             color: Colors.white,
//                             shape: BoxShape.circle,
//                           ),
//                           child: Icon(
//                             Icons.camera_alt,
//                             color: const Color(0xFF6A5ACD),
//                             size: 16,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       shopName.isNotEmpty ? shopName : 'Your Shop Name',
//                       style: GoogleFonts.poppins(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     Text(
//                       ownerName.isNotEmpty ? ownerName : 'Owner Name',
//                       style: GoogleFonts.poppins(
//                         fontSize: 16,
//                         color: Colors.white.withOpacity(0.9),
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Row(
//                       children: [
//                         Icon(Icons.star, color: Colors.amber, size: 16),
//                         const SizedBox(width: 4),
//                         Text(
//                           rating.toStringAsFixed(1),
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         Icon(Icons.place, color: Colors.white, size: 14),
//                         const SizedBox(width: 4),
//                         Text(
//                           '2.5 km',
//                           style: TextStyle(
//                             color: Colors.white.withOpacity(0.9),
//                             fontSize: 12,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),

//         // Add photos button
//         Positioned(
//           top: 16,
//           right: 16,
//           child: FloatingActionButton.small(
//             onPressed: _showGalleryPickerBottomSheet,
//             backgroundColor: Colors.white,
//             foregroundColor: const Color(0xFF6A5ACD),
//             child: const Icon(Icons.add_photo_alternate),
//           ),
//         ),
//       ],
//     );
//   }

//   // ----------------- Business Status Card -----------------
//   Widget _buildStatusCard() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Business Status',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Row(
//                   children: [
//                     Container(
//                       width: 12,
//                       height: 12,
//                       decoration: BoxDecoration(
//                         color: isShopOpen ? Colors.green : Colors.red,
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Text(
//                       isShopOpen ? 'Shop is Open' : 'Shop is Closed',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: isShopOpen ? Colors.green : Colors.red,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Switch(
//             value: isShopOpen,
//             onChanged: (value) async {
//               setState(() {
//                 isShopOpen = value;
//               });
//               await _updateField('is_shop_open', value ? 1 : 0);
//             },
//             activeColor: Colors.green,
//           ),
//         ],
//       ),
//     );
//   }

//   // ----------------- Order Statistics -----------------
//   Widget _buildOrderStats() {
//     return Row(
//       children: [
//         Expanded(
//           child: _buildStatCard(
//             'Total Orders',
//             totalOrders.toString(),
//             Icons.shopping_bag,
//             const Color(0xFF6A5ACD),
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: _buildStatCard(
//             'Pending',
//             pendingOrders.toString(),
//             Icons.pending_actions,
//             Colors.orange,
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: _buildStatCard(
//             'Completed',
//             completedOrders.toString(),
//             Icons.check_circle,
//             Colors.green,
//           ),
//         ),
//       ],
//     );
//   }

//   // ----------------- Description Card -----------------
//   Widget _buildDescriptionCard() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'About Our Shop',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//               IconButton(
//                 icon: Icon(Icons.edit, size: 20, color: Colors.grey[600]),
//                 onPressed: () => _showEditDialog(
//                   context, 
//                   'Shop Description', 
//                   description, 
//                   descriptionController,
//                   (value) {
//                     setState(() {
//                       description = value;
//                     });
//                     _updateField('description', value);
//                   },
//                   maxLines: 5,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Text(
//             description.isNotEmpty 
//                 ? description 
//                 : 'Add a description about your tailoring services, expertise, and what makes your shop unique.',
//             style: TextStyle(
//               fontSize: 14,
//               color: description.isNotEmpty ? Colors.grey[700] : Colors.grey[500],
//               fontStyle: description.isEmpty ? FontStyle.italic : FontStyle.normal,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ----------------- Gallery Section -----------------
//   Widget _buildGallerySection() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Shop Gallery',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//               TextButton.icon(
//                 onPressed: _showGalleryPickerBottomSheet,
//                 icon: const Icon(Icons.add, size: 18),
//                 label: const Text('Add Photos'),
//                 style: TextButton.styleFrom(foregroundColor: const Color(0xFF6A5ACD)),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           _shopImages.isNotEmpty
//               ? SizedBox(
//                   height: 120,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: _shopImages.length,
//                     itemBuilder: (context, index) {
//                       return Padding(
//                         padding: const EdgeInsets.only(right: 8.0),
//                         child: Stack(
//                           children: [
//                             Container(
//                               width: 120,
//                               height: 120,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(12),
//                                 image: DecorationImage(
//                                   image: FileImage(_shopImages[index]),
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                             ),
//                             Positioned(
//                               top: 4,
//                               right: 4,
//                               child: GestureDetector(
//                                 onTap: () => _removeShopImage(index),
//                                 child: Container(
//                                   padding: const EdgeInsets.all(4),
//                                   decoration: const BoxDecoration(
//                                     color: Colors.red,
//                                     shape: BoxShape.circle,
//                                   ),
//                                   child: const Icon(
//                                     Icons.close,
//                                     color: Colors.white,
//                                     size: 14,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 )
//               : Container(
//                   height: 120,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[100],
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: Colors.grey[300]!),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.photo_library,
//                         size: 40,
//                         color: Colors.grey[400],
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         'Add photos of your shop',
//                         style: TextStyle(
//                           color: Colors.grey[500],
//                           fontSize: 14,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//         ],
//       ),
//     );
//   }

//   // ----------------- Services Section -----------------
//   Widget _buildServicesSection() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Services & Pricing',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//               TextButton.icon(
//                 onPressed: () => _showAddServiceDialog(context),
//                 icon: const Icon(Icons.add, size: 18),
//                 label: const Text('Add Service'),
//                 style: TextButton.styleFrom(foregroundColor: const Color(0xFF6A5ACD)),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           _services.isEmpty
//               ? Container(
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     color: Colors.grey[50],
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Column(
//                     children: [
//                       Icon(Icons.style, size: 40, color: Colors.grey[400]),
//                       const SizedBox(height: 8),
//                       Text(
//                         'No services added yet',
//                         style: TextStyle(color: Colors.grey[500]),
//                       ),
//                     ],
//                   ),
//                 )
//               : Column(
//                   children: _services.map((service) => _buildServiceItem(service)).toList(),
//                 ),
//         ],
//       ),
//     );
//   }

//   Widget _buildServiceItem(Map<String, dynamic> service) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.grey[50],
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey[200]!),
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: const Color(0xFF6A5ACD).withOpacity(0.1),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Icon(Icons.cut, color: const Color(0xFF6A5ACD), size: 20),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   service['name'] ?? 'Service',
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 Text(
//                   service['price_range'] ?? 'Not set',
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.green[700],
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(
//                 service['delivery_time'] ?? 'Not set',
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Colors.grey[600],
//                 ),
//               ),
//               const SizedBox(height: 4),
//               GestureDetector(
//                 onTap: () => _showEditServiceDialog(context, service),
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                   decoration: BoxDecoration(
//                     color: Colors.blue[50],
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Text(
//                     'Edit',
//                     style: TextStyle(
//                       fontSize: 10,
//                       color: Colors.blue[700],
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   // ----------------- Helper Widgets -----------------
//   Widget _buildSectionHeader(String title) => Text(
//         title,
//         style: const TextStyle(
//           fontSize: 18, 
//           fontWeight: FontWeight.bold, 
//           color: Colors.black87
//         ),
//       );

//   Widget _buildStatCard(String title, String value, IconData icon, Color color) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Icon(icon, size: 24, color: color),
//           const SizedBox(height: 8),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 18, 
//               fontWeight: FontWeight.bold, 
//               color: color
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             title,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 10, 
//               color: Colors.grey[600]
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildInfoCard({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required VoidCallback onTap,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: ListTile(
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         leading: Container(
//           padding: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             color: const Color(0xFF6A5ACD).withOpacity(0.1),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Icon(icon, color: const Color(0xFF6A5ACD), size: 22),
//         ),
//         title: Text(
//           title,
//           style: const TextStyle(
//             fontSize: 14, 
//             fontWeight: FontWeight.w600, 
//             color: Colors.black87
//           ),
//         ),
//         subtitle: Text(
//           subtitle,
//           style: TextStyle(fontSize: 13, color: Colors.grey[600]),
//           maxLines: 2,
//           overflow: TextOverflow.ellipsis,
//         ),
//         trailing: Icon(Icons.edit, color: Colors.grey[400], size: 20),
//         onTap: onTap,
//       ),
//     );
//   }

//   Widget _buildBusinessToolCard({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required VoidCallback onTap,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: ListTile(
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         leading: Container(
//           padding: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             color: Colors.grey.shade100,
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Icon(icon, color: Colors.grey[700], size: 22),
//         ),
//         title: Text(
//           title,
//           style: const TextStyle(
//             fontSize: 15, 
//             fontWeight: FontWeight.w600, 
//             color: Colors.black87
//           ),
//         ),
//         subtitle: Text(
//           subtitle,
//           style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//         ),
//         trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
//         onTap: onTap,
//       ),
//     );
//   }

//   // ----------------- Image Picker Methods -----------------
//   void _showLogoPickerBottomSheet() {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (context) => Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: const BorderRadius.only(
//             topLeft: Radius.circular(20),
//             topRight: Radius.circular(20),
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.2),
//               blurRadius: 10,
//               offset: const Offset(0, -2),
//             ),
//           ],
//         ),
//         child: SafeArea(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 child: const Text(
//                   'Choose Shop Logo',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//               ),
//               const Divider(height: 1),
//               _buildImagePickerOption(
//                 icon: Icons.photo_library,
//                 title: 'Choose from Gallery',
//                 onTap: () => _pickLogoFromGallery(),
//               ),
//               _buildImagePickerOption(
//                 icon: Icons.photo_camera,
//                 title: 'Take Photo',
//                 onTap: () => _pickLogoFromCamera(),
//               ),
//               if (_shopLogo != null)
//                 _buildImagePickerOption(
//                   icon: Icons.delete,
//                   title: 'Remove Logo',
//                   onTap: _removeLogo,
//                   color: Colors.red,
//                 ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: SizedBox(
//                   width: double.infinity,
//                   child: TextButton(
//                     onPressed: () => Navigator.pop(context),
//                     style: TextButton.styleFrom(
//                       foregroundColor: Colors.grey[600],
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     child: const Text('Cancel'),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 8),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _showGalleryPickerBottomSheet() {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (context) => Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: const BorderRadius.only(
//             topLeft: Radius.circular(20),
//             topRight: Radius.circular(20),
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.2),
//               blurRadius: 10,
//               offset: const Offset(0, -2),
//             ),
//           ],
//         ),
//         child: SafeArea(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 child: const Text(
//                   'Add Shop Photos',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//               ),
//               const Divider(height: 1),
//               _buildImagePickerOption(
//                 icon: Icons.photo_library,
//                 title: 'Choose from Gallery',
//                 onTap: () => _pickShopImageFromGallery(),
//               ),
//               _buildImagePickerOption(
//                 icon: Icons.photo_camera,
//                 title: 'Take Photo',
//                 onTap: () => _pickShopImageFromCamera(),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: SizedBox(
//                   width: double.infinity,
//                   child: TextButton(
//                     onPressed: () => Navigator.pop(context),
//                     style: TextButton.styleFrom(
//                       foregroundColor: Colors.grey[600],
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     child: const Text('Cancel'),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 8),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildImagePickerOption({
//     required IconData icon,
//     required String title,
//     required VoidCallback onTap,
//     Color? color,
//   }) {
//     return ListTile(
//       leading: Icon(icon, color: color ?? const Color(0xFF6A5ACD)),
//       title: Text(
//         title,
//         style: TextStyle(
//           color: color ?? Colors.black87,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//       onTap: () {
//         Navigator.pop(context);
//         onTap();
//       },
//     );
//   }

//   Future<void> _pickLogoFromGallery() async {
//     try {
//       final XFile? pickedFile = await _imagePicker.pickImage(
//         source: ImageSource.gallery,
//         imageQuality: 80,
//         maxWidth: 512,
//         maxHeight: 512,
//       );

//       if (pickedFile != null) {
//         setState(() {
//           _shopLogo = File(pickedFile.path);
//           shopLogoPath = pickedFile.path;
//         });
//         await _updateField('shop_logo_path', pickedFile.path);
//         _showSnackBar(context, 'Shop logo updated');
//       }
//     } catch (e) {
//       _showErrorSnackBar(context, 'Failed to pick image: $e');
//     }
//   }

//   Future<void> _pickLogoFromCamera() async {
//     try {
//       final XFile? pickedFile = await _imagePicker.pickImage(
//         source: ImageSource.camera,
//         imageQuality: 80,
//         maxWidth: 512,
//         maxHeight: 512,
//       );

//       if (pickedFile != null) {
//         setState(() {
//           _shopLogo = File(pickedFile.path);
//           shopLogoPath = pickedFile.path;
//         });
//         await _updateField('shop_logo_path', pickedFile.path);
//         _showSnackBar(context, 'Shop logo updated');
//       }
//     } catch (e) {
//       _showErrorSnackBar(context, 'Failed to capture image: $e');
//     }
//   }

//   Future<void> _pickShopImageFromGallery() async {
//     try {
//       final XFile? pickedFile = await _imagePicker.pickImage(
//         source: ImageSource.gallery,
//         imageQuality: 80,
//         maxWidth: 1024,
//         maxHeight: 768,
//       );

//       if (pickedFile != null) {
//         final imageId = await _databaseHelper.insertShopImage(pickedFile.path);
//         if (imageId > 0) {
//           setState(() {
//             _shopImages.add(File(pickedFile.path));
//             _shopImagePaths.add(pickedFile.path);
//           });
//           _showSnackBar(context, 'Shop photo added');
//         }
//       }
//     } catch (e) {
//       _showErrorSnackBar(context, 'Failed to pick image: $e');
//     }
//   }

//   Future<void> _pickShopImageFromCamera() async {
//     try {
//       final XFile? pickedFile = await _imagePicker.pickImage(
//         source: ImageSource.camera,
//         imageQuality: 80,
//         maxWidth: 1024,
//         maxHeight: 768,
//       );

//       if (pickedFile != null) {
//         final imageId = await _databaseHelper.insertShopImage(pickedFile.path);
//         if (imageId > 0) {
//           setState(() {
//             _shopImages.add(File(pickedFile.path));
//             _shopImagePaths.add(pickedFile.path);
//           });
//           _showSnackBar(context, 'Shop photo added');
//         }
//       }
//     } catch (e) {
//       _showErrorSnackBar(context, 'Failed to capture image: $e');
//     }
//   }

//   void _removeLogo() async {
//     setState(() {
//       _shopLogo = null;
//       shopLogoPath = null;
//     });
//     await _updateField('shop_logo_path', '');
//     _showSnackBar(context, 'Shop logo removed');
//   }

//   void _removeShopImage(int index) async {
//     final imagePath = _shopImagePaths[index];
//     final success = await _databaseHelper.deleteShopImageByPath(imagePath);
//     if (success > 0) {
//       setState(() {
//         _shopImages.removeAt(index);
//         _shopImagePaths.removeAt(index);
//       });
//       _showSnackBar(context, 'Shop photo removed');
//     }
//   }

//   // ----------------- Service Management -----------------
//   void _showAddServiceDialog(BuildContext context) {
//     final nameController = TextEditingController();
//     final priceController = TextEditingController();
//     final timeController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Add New Service'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: nameController,
//               decoration: const InputDecoration(
//                 labelText: 'Service Name',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 12),
//             TextField(
//               controller: priceController,
//               decoration: const InputDecoration(
//                 labelText: 'Price Range (e.g., ₹500 - ₹1500)',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 12),
//             TextField(
//               controller: timeController,
//               decoration: const InputDecoration(
//                 labelText: 'Delivery Time (e.g., 3-5 days)',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context), 
//             child: const Text('Cancel')
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               if (nameController.text.trim().isNotEmpty) {
//                 final serviceId = await _databaseHelper.insertService({
//                   'name': nameController.text.trim(),
//                   'price_range': priceController.text.trim(),
//                   'delivery_time': timeController.text.trim(),
//                 });
                
//                 if (serviceId > 0) {
//                   await _loadServices();
//                   Navigator.pop(context);
//                   _showSnackBar(context, 'Service added successfully');
//                 }
//               } else {
//                 _showErrorSnackBar(context, 'Service name is required');
//               }
//             },
//             child: const Text('Add Service'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showEditServiceDialog(BuildContext context, Map<String, dynamic> service) {
//     final nameController = TextEditingController(text: service['name']);
//     final priceController = TextEditingController(text: service['price_range']);
//     final timeController = TextEditingController(text: service['delivery_time']);

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Edit Service'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: nameController,
//               decoration: const InputDecoration(
//                 labelText: 'Service Name',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 12),
//             TextField(
//               controller: priceController,
//               decoration: const InputDecoration(
//                 labelText: 'Price Range',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 12),
//             TextField(
//               controller: timeController,
//               decoration: const InputDecoration(
//                 labelText: 'Delivery Time',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context), 
//             child: const Text('Cancel')
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               if (nameController.text.trim().isNotEmpty) {
//                 final success = await _databaseHelper.updateService({
//                   'id': service['id'],
//                   'name': nameController.text.trim(),
//                   'price_range': priceController.text.trim(),
//                   'delivery_time': timeController.text.trim(),
//                 });
                
//                 if (success > 0) {
//                   await _loadServices();
//                   Navigator.pop(context);
//                   _showSnackBar(context, 'Service updated successfully');
//                 }
//               } else {
//                 _showErrorSnackBar(context, 'Service name is required');
//               }
//             },
//             child: const Text('Update'),
//           ),
//         ],
//       ),
//     );
//   }

//   // ----------------- Utility Methods -----------------
//   void _showEditDialog(
//     BuildContext context, 
//     String field, 
//     String currentValue, 
//     TextEditingController controller, 
//     Function(String) onSave,
//     {int maxLines = 1}
//   ) {
//     controller.text = currentValue;

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Edit $field'),
//         content: TextField(
//           controller: controller,
//           decoration: InputDecoration(
//             labelText: field, 
//             border: const OutlineInputBorder(),
//             hintText: 'Enter your $field'
//           ),
//           maxLines: maxLines,
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context), 
//             child: const Text('Cancel')
//           ),
//           ElevatedButton(
//             onPressed: () {
//               final newValue = controller.text.trim();
//               if (newValue.isNotEmpty) {
//                 onSave(newValue);
//                 Navigator.pop(context);
//                 _showSnackBar(context, '$field updated successfully');
//               } else {
//                 _showErrorSnackBar(context, '$field cannot be empty');
//               }
//             },
//             child: const Text('Save'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showEditShopDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Edit Shop Information'),
//         content: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               _buildEditField('Shop Name', shopNameController),
//               const SizedBox(height: 12),
//               _buildEditField('Owner Name', ownerNameController),
//               const SizedBox(height: 12),
//               _buildEditField('Phone', phoneController),
//               const SizedBox(height: 12),
//               _buildEditField('Email', emailController),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context), 
//             child: const Text('Cancel')
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               // Save all fields
//               setState(() {
//                 shopName = shopNameController.text.trim();
//                 ownerName = ownerNameController.text.trim();
//                 phone = phoneController.text.trim();
//                 email = emailController.text.trim();
//               });
//               await _saveTailorData();
//               Navigator.pop(context);
//               _showSnackBar(context, 'Shop information updated');
//             },
//             child: const Text('Save All'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEditField(String label, TextEditingController controller) {
//     return TextField(
//       controller: controller,
//       decoration: InputDecoration(
//         labelText: label,
//         border: const OutlineInputBorder(),
//       ),
//     );
//   }

// void _showLogoutDialog(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (context) => AlertDialog(
//       title: const Text('Logout'),
//       content: const Text('Are you sure you want to logout?'),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context), 
//           child: const Text('Cancel')
//         ),
//         ElevatedButton(
//           onPressed: () async {
            
//             Navigator.pop(context); // Close the dialog
            
//             // Navigate to role selection screen and clear all previous routes
//             Navigator.pushAndRemoveUntil(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => RoleSelectionScreen(), // Replace with your actual role selection screen
//               ),
//               (route) => false, // This removes all previous routes
//             );
            
//             _showSnackBar(context, 'Logged out successfully');
//           },
//           style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//           child: const Text('Logout'),
//         ),
//       ],
//     ),
//   );
// }

//   // Clear tailor data on logout
//   Future<void> _clearTailorData() async {
//     await _databaseHelper.clearAllData();
//     setState(() {
//       shopName = "";
//       ownerName = "";
//       email = "";
//       phone = "";
//       address = "";
//       experience = "";
//       specialization = "";
//       description = "";
//       workingHours = "9:00 AM - 7:00 PM";
//       rating = 0.0;
//       totalOrders = 0;
//       pendingOrders = 0;
//       completedOrders = 0;
//       isShopOpen = true;
//       _shopLogo = null;
//       shopLogoPath = null;
//       _shopImages.clear();
//       _shopImagePaths.clear();
//       _services.clear();
      
//       // Clear controllers
//       shopNameController.clear();
//       ownerNameController.clear();
//       emailController.clear();
//       phoneController.clear();
//       addressController.clear();
//       experienceController.clear();
//       specializationController.clear();
//       descriptionController.clear();
//       workingHoursController.clear();
//     });
    
//     // Reinitialize default profile
//     await _databaseHelper.initializeDefaultProfile();
//     await _loadTailorData();
//   }

//   void _showSnackBar(BuildContext context, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         behavior: SnackBarBehavior.floating,
//         duration: const Duration(seconds: 2),
//         backgroundColor: const Color(0xFF6A5ACD),
//       ),
//     );
//   }

//   void _showErrorSnackBar(BuildContext context, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         behavior: SnackBarBehavior.floating,
//         duration: const Duration(seconds: 3),
//         backgroundColor: Colors.red,
//       ),
//     );
//   }
// }

// tailor_profile_screen.dart
import 'package:firebaseauth/TailorSide/view/role_selection.dart';
import 'package:firebaseauth/TailorSide/view/tailor_appointmentScren.dart';
import 'package:firebaseauth/TailorSide/view/tailor_bussimess_Anayltic.dart';
import 'package:firebaseauth/TailorSide/view/tailor_inventory_management.dart';
import 'package:firebaseauth/TailorSide/view/tailor_supportHalp.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class TailorProfileScreen extends StatefulWidget {
  const TailorProfileScreen({Key? key}) : super(key: key);

  @override
  State<TailorProfileScreen> createState() => _TailorProfileScreenState();
}

class _TailorProfileScreenState extends State<TailorProfileScreen> {
  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // TextEditingControllers for all fields
  late TextEditingController shopNameController;
  late TextEditingController ownerNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  late TextEditingController experienceController;
  late TextEditingController specializationController;
  late TextEditingController descriptionController;
  late TextEditingController workingHoursController;

  // Tailor data with default values
  String shopName = "";
  String ownerName = "";
  String email = "";
  String phone = "";
  String address = "";
  String experience = "";
  String specialization = "";
  String description = "";
  String workingHours = "9:00 AM - 7:00 PM";
  String category = "";
  String city = "";
  String gstNumber = "";
  double rating = 0.0;
  int totalOrders = 0;
  int pendingOrders = 0;
  int completedOrders = 0;
  bool isShopOpen = true;
  bool isVerified = false;
  String? profilePhotoUrl;
  
  // Shop images
  final ImagePicker _imagePicker = ImagePicker();
  File? _shopLogo;
  List<File> _shopImages = [];

  // Services
  List<Map<String, dynamic>> _services = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    
    // Initialize controllers
    shopNameController = TextEditingController();
    ownerNameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    addressController = TextEditingController();
    experienceController = TextEditingController();
    specializationController = TextEditingController();
    descriptionController = TextEditingController();
    workingHoursController = TextEditingController();
    
    _loadTailorDataFromFirebase();
  }

  @override
  void dispose() {
    // Dispose all controllers
    shopNameController.dispose();
    ownerNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    experienceController.dispose();
    specializationController.dispose();
    descriptionController.dispose();
    workingHoursController.dispose();
    super.dispose();
  }

  // Load tailor data from Firebase
  Future<void> _loadTailorDataFromFirebase() async {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        final doc = await _firestore.collection('tailors').doc(user.uid).get();
        
        if (doc.exists) {
          final data = doc.data()!;
          setState(() {
            shopName = data['shopName'] ?? "";
            ownerName = data['name'] ?? "";
            email = data['email'] ?? "";
            phone = data['phone'] ?? "";
            address = data['address'] ?? "";
            experience = data['experience'] ?? "";
            specialization = data['specialization'] ?? "";
            description = data['description'] ?? "";
            workingHours = data['workingHours'] ?? "9:00 AM - 7:00 PM";
            category = data['category'] ?? "";
            city = data['city'] ?? "";
            gstNumber = data['gstNumber'] ?? "";
            rating = (data['rating'] ?? 0.0).toDouble();
            totalOrders = data['totalOrders'] ?? 0;
            pendingOrders = data['pendingOrders'] ?? 0;
            completedOrders = data['completedOrders'] ?? 0;
            isShopOpen = data['isShopOpen'] ?? true;
            isVerified = data['isVerified'] ?? false;
            profilePhotoUrl = data['photoURL'];
            
            // Set controller values
            shopNameController.text = shopName;
            ownerNameController.text = ownerName;
            emailController.text = email;
            phoneController.text = phone;
            addressController.text = address;
            experienceController.text = experience;
            specializationController.text = specialization;
            descriptionController.text = description;
            workingHoursController.text = workingHours;
          });
        }
      }
    } catch (e) {
      _showErrorSnackBar(context, 'Failed to load profile data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Update field in Firebase
  Future<void> _updateFieldInFirebase(String field, dynamic value) async {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('tailors').doc(user.uid).update({
          field: value,
          'updatedAt': FieldValue.serverTimestamp(),
        });
        _showSnackBar(context, 'Profile updated successfully');
      }
    } catch (e) {
      _showErrorSnackBar(context, 'Failed to update profile: $e');
    }
  }

  // Update multiple fields in Firebase
  Future<void> _updateMultipleFields(Map<String, dynamic> updates) async {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        updates['updatedAt'] = FieldValue.serverTimestamp();
        await _firestore.collection('tailors').doc(user.uid).update(updates);
        _showSnackBar(context, 'Profile updated successfully');
      }
    } catch (e) {
      _showErrorSnackBar(context, 'Failed to update profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6A5ACD)),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // Shop Header
          SliverAppBar(
            expandedHeight: 280,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildShopHeader(),
              title: Text(
                shopName.isNotEmpty ? shopName : 'Tailor Shop',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.8),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
              centerTitle: true,
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: () => _showEditShopDialog(context),
              ),
            ],
          ),

          // Shop Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Verification Status
                  if (!isVerified) _buildVerificationBanner(),
                  if (!isVerified) const SizedBox(height: 16),

                  // Business Status & Rating
                  _buildStatusCard(),
                  const SizedBox(height: 20),

                  // Order Statistics
                  _buildOrderStats(),
                  const SizedBox(height: 20),

                  // Shop Information
                  _buildSectionHeader('Shop Information'),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    icon: Icons.store,
                    title: 'Shop Name',
                    subtitle: shopName.isNotEmpty ? shopName : 'Tap to add shop name',
                    onTap: () => _showEditDialog(
                      context, 
                      'Shop Name', 
                      shopName, 
                      shopNameController,
                      (value) {
                        setState(() {
                          shopName = value;
                        });
                        _updateFieldInFirebase('shopName', value);
                      }
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    icon: Icons.person,
                    title: 'Owner Name',
                    subtitle: ownerName.isNotEmpty ? ownerName : 'Tap to add owner name',
                    onTap: () => _showEditDialog(
                      context, 
                      'Owner Name', 
                      ownerName, 
                      ownerNameController,
                      (value) {
                        setState(() {
                          ownerName = value;
                        });
                        _updateFieldInFirebase('name', value);
                      }
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    icon: Icons.phone,
                    title: 'Contact Number',
                    subtitle: phone.isNotEmpty ? phone : 'Tap to add contact number',
                    onTap: () => _showEditDialog(
                      context, 
                      'Phone', 
                      phone, 
                      phoneController,
                      (value) {
                        setState(() {
                          phone = value;
                        });
                        _updateFieldInFirebase('phone', value);
                      }
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    icon: Icons.email,
                    title: 'Email',
                    subtitle: email.isNotEmpty ? email : 'Tap to add email',
                    onTap: () => _showEditDialog(
                      context, 
                      'Email', 
                      email, 
                      emailController,
                      (value) {
                        setState(() {
                          email = value;
                        });
                        _updateFieldInFirebase('email', value);
                      }
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    icon: Icons.location_on,
                    title: 'Shop Address',
                    subtitle: address.isNotEmpty ? address : 'Tap to add shop address',
                    onTap: () => _showEditDialog(
                      context, 
                      'Address', 
                      address, 
                      addressController,
                      (value) {
                        setState(() {
                          address = value;
                        });
                        _updateFieldInFirebase('address', value);
                      },
                      maxLines: 3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    icon: Icons.category,
                    title: 'Shop Category',
                    subtitle: category.isNotEmpty ? category : 'Not selected',
                    onTap: () => _showCategoryDialog(),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    icon: Icons.location_city,
                    title: 'City',
                    subtitle: city.isNotEmpty ? city : 'Not selected',
                    onTap: () => _showCityDialog(),
                  ),
                  if (gstNumber.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      icon: Icons.receipt,
                      title: 'GST Number',
                      subtitle: gstNumber,
                      onTap: () {},
                    ),
                  ],
                  const SizedBox(height: 20),

                  // Professional Details
                  _buildSectionHeader('Professional Details'),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    icon: Icons.work_history,
                    title: 'Experience',
                    subtitle: experience.isNotEmpty ? '$experience years' : 'Tap to add experience',
                    onTap: () => _showEditDialog(
                      context, 
                      'Experience (years)', 
                      experience, 
                      experienceController,
                      (value) {
                        setState(() {
                          experience = value;
                        });
                        _updateFieldInFirebase('experience', value);
                      }
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    icon: Icons.style,
                    title: 'Specialization',
                    subtitle: specialization.isNotEmpty ? specialization : 'Tap to add specialization',
                    onTap: () => _showEditDialog(
                      context, 
                      'Specialization', 
                      specialization, 
                      specializationController,
                      (value) {
                        setState(() {
                          specialization = value;
                        });
                        _updateFieldInFirebase('specialization', value);
                      }
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    icon: Icons.schedule,
                    title: 'Working Hours',
                    subtitle: workingHours.isNotEmpty ? workingHours : 'Tap to add working hours',
                    onTap: () => _showEditDialog(
                      context, 
                      'Working Hours', 
                      workingHours, 
                      workingHoursController,
                      (value) {
                        setState(() {
                          workingHours = value;
                        });
                        _updateFieldInFirebase('workingHours', value);
                      }
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Shop Description
                  _buildDescriptionCard(),
                  const SizedBox(height: 20),

                  // Business Tools
                  _buildSectionHeader('Business Tools'),
                  const SizedBox(height: 12),
                  _buildBusinessToolCard(
                    icon: Icons.inventory,
                    title: 'Inventory Management',
                    subtitle: 'Manage fabrics and materials',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InventoryManagementScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildBusinessToolCard(
                    icon: Icons.assignment,
                    title: 'Support & Help',
                    subtitle: 'Customer Support',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const TailorHelpSupportPage()));
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildBusinessToolCard(
                    icon: Icons.analytics,
                    title: 'Business Analytics',
                    subtitle: 'View sales and performance',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BusinessAnalyticsPage(),
                        ),
                      );
                    }
                  ),
                  const SizedBox(height: 12),
                  _buildBusinessToolCard(
                    icon: Icons.calendar_today,
                    title: 'Appointment Schedule',
                    subtitle: 'Manage customer appointments',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AppointmentScheduleScreen(),
                        ),
                      );
                    }
                  ),
                  const SizedBox(height: 24),

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _showLogoutDialog(context),
                      icon: const Icon(Icons.logout),
                      label: const Text(
                        'Logout',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade400,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ----------------- Header Section -----------------
  Widget _buildShopHeader() {
    return Stack(
      children: [
        // Shop background with gradient
        Container(
          height: 280,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF6A5ACD),
                const Color(0xFF836FFF),
              ],
            ),
          ),
          child: _shopImages.isNotEmpty
              ? PageView.builder(
                  itemCount: _shopImages.length,
                  itemBuilder: (context, index) {
                    return Image.file(
                      _shopImages[index],
                      fit: BoxFit.cover,
                    );
                  },
                )
              : Container(
                  color: const Color(0xFF6A5ACD),
                  child: Icon(
                    Icons.store,
                    size: 80,
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
        ),

        // Gradient overlay
        Container(
          height: 280,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.6),
              ],
            ),
          ),
        ),

        // Shop logo and basic info
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Row(
            children: [
              // Shop Logo
              GestureDetector(
                onTap: _showLogoPickerBottomSheet,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        backgroundImage: _shopLogo != null
                            ? FileImage(_shopLogo!)
                            : (profilePhotoUrl != null 
                                ? NetworkImage(profilePhotoUrl!) as ImageProvider
                                : null),
                        child: _shopLogo == null && profilePhotoUrl == null
                            ? Icon(
                                Icons.store,
                                size: 40,
                                color: const Color(0xFF6A5ACD),
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            color: const Color(0xFF6A5ACD),
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shopName.isNotEmpty ? shopName : 'Your Shop Name',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      ownerName.isNotEmpty ? ownerName : 'Owner Name',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          rating.toStringAsFixed(1),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.verified, 
                            color: isVerified ? Colors.green : Colors.grey, 
                            size: 16),
                        const SizedBox(width: 4),
                        Text(
                          isVerified ? 'Verified' : 'Not Verified',
                          style: TextStyle(
                            color: isVerified ? Colors.green : Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ----------------- Verification Banner -----------------
  Widget _buildVerificationBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.info, color: Colors.orange[800]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Account Verification Pending',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[800],
                  ),
                ),
                Text(
                  'Your account is under verification process',
                  style: TextStyle(
                    color: Colors.orange[700],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ----------------- Business Status Card -----------------
  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Business Status',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: isShopOpen ? Colors.green : Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isShopOpen ? 'Shop is Open' : 'Shop is Closed',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isShopOpen ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Switch(
            value: isShopOpen,
            onChanged: (value) async {
              setState(() {
                isShopOpen = value;
              });
              await _updateFieldInFirebase('isShopOpen', value);
            },
            activeColor: Colors.green,
          ),
        ],
      ),
    );
  }

  // ----------------- Order Statistics -----------------
  Widget _buildOrderStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Orders',
            totalOrders.toString(),
            Icons.shopping_bag,
            const Color(0xFF6A5ACD),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Pending',
            pendingOrders.toString(),
            Icons.pending_actions,
            Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Completed',
            completedOrders.toString(),
            Icons.check_circle,
            Colors.green,
          ),
        ),
      ],
    );
  }

  // ----------------- Description Card -----------------
  Widget _buildDescriptionCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'About Our Shop',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit, size: 20, color: Colors.grey[600]),
                onPressed: () => _showEditDialog(
                  context, 
                  'Shop Description', 
                  description, 
                  descriptionController,
                  (value) {
                    setState(() {
                      description = value;
                    });
                    _updateFieldInFirebase('description', value);
                  },
                  maxLines: 5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description.isNotEmpty 
                ? description 
                : 'Add a description about your tailoring services, expertise, and what makes your shop unique.',
            style: TextStyle(
              fontSize: 14,
              color: description.isNotEmpty ? Colors.grey[700] : Colors.grey[500],
              fontStyle: description.isEmpty ? FontStyle.italic : FontStyle.normal,
            ),
          ),
        ],
      ),
    );
  }

  // ----------------- Helper Widgets -----------------
  Widget _buildSectionHeader(String title) => Text(
        title,
        style: const TextStyle(
          fontSize: 18, 
          fontWeight: FontWeight.bold, 
          color: Colors.black87
        ),
      );

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18, 
              fontWeight: FontWeight.bold, 
              color: color
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10, 
              color: Colors.grey[600]
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF6A5ACD).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF6A5ACD), size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14, 
            fontWeight: FontWeight.w600, 
            color: Colors.black87
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Icon(Icons.edit, color: Colors.grey[400], size: 20),
        onTap: onTap,
      ),
    );
  }

  Widget _buildBusinessToolCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.grey[700], size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 15, 
            fontWeight: FontWeight.w600, 
            color: Colors.black87
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
        onTap: onTap,
      ),
    );
  }

  // ----------------- Dialog Methods -----------------
  void _showEditDialog(
    BuildContext context, 
    String field, 
    String currentValue, 
    TextEditingController controller, 
    Function(String) onSave,
    {int maxLines = 1}
  ) {
    controller.text = currentValue;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $field'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: field, 
            border: const OutlineInputBorder(),
            hintText: 'Enter your $field'
          ),
          maxLines: maxLines,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text('Cancel')
          ),
          ElevatedButton(
            onPressed: () {
              final newValue = controller.text.trim();
              if (newValue.isNotEmpty) {
                onSave(newValue);
                Navigator.pop(context);
              } else {
                _showErrorSnackBar(context, '$field cannot be empty');
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showCategoryDialog() {
    final categories = [
      'Traditional Wear', 'Western Wear', 'Bridal & Wedding', 
      'Custom Tailoring', 'Alterations & Repairs', 'Uniforms', 
      'Accessories', 'Other'
    ];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Category'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(categories[index]),
                trailing: category == categories[index] 
                    ? const Icon(Icons.check, color: Colors.green) 
                    : null,
                onTap: () {
                  setState(() {
                    category = categories[index];
                  });
                  _updateFieldInFirebase('category', categories[index]);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showCityDialog() {
    final cities = [
      'Mumbai', 'Delhi', 'Bangalore', 'Hyderabad', 
      'Chennai', 'Kolkata', 'Pune', 'Ahmedabad'
    ];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select City'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: cities.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(cities[index]),
                trailing: city == cities[index] 
                    ? const Icon(Icons.check, color: Colors.green) 
                    : null,
                onTap: () {
                  setState(() {
                    city = cities[index];
                  });
                  _updateFieldInFirebase('city', cities[index]);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showEditShopDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Shop Information'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildEditField('Shop Name', shopNameController),
              const SizedBox(height: 12),
              _buildEditField('Owner Name', ownerNameController),
              const SizedBox(height: 12),
              _buildEditField('Phone', phoneController),
              const SizedBox(height: 12),
              _buildEditField('Email', emailController),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text('Cancel')
          ),
          ElevatedButton(
            onPressed: () async {
              // Save all fields
              final updates = {
                'shopName': shopNameController.text.trim(),
                'name': ownerNameController.text.trim(),
                'phone': phoneController.text.trim(),
                'email': emailController.text.trim(),
              };
              
              setState(() {
                shopName = updates['shopName']!;
                ownerName = updates['name']!;
                phone = updates['phone']!;
                email = updates['email']!;
              });
              
              await _updateMultipleFields(updates);
              Navigator.pop(context);
            },
            child: const Text('Save All'),
          ),
        ],
      ),
    );
  }

  Widget _buildEditField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text('Cancel')
          ),
          ElevatedButton(
            onPressed: () async {
              await _auth.signOut();
              Navigator.pop(context);
              
              // Navigate to role selection screen and clear all previous routes
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => RoleSelectionScreen(),
                ),
                (route) => false,
              );
              
              _showSnackBar(context, 'Logged out successfully');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  // ----------------- Image Picker Methods -----------------
  void _showLogoPickerBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: const Text(
                  'Choose Shop Logo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const Divider(height: 1),
              _buildImagePickerOption(
                icon: Icons.photo_library,
                title: 'Choose from Gallery',
                onTap: () => _pickLogoFromGallery(),
              ),
              _buildImagePickerOption(
                icon: Icons.photo_camera,
                title: 'Take Photo',
                onTap: () => _pickLogoFromCamera(),
              ),
              if (_shopLogo != null)
                _buildImagePickerOption(
                  icon: Icons.delete,
                  title: 'Remove Logo',
                  onTap: _removeLogo,
                  color: Colors.red,
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey[600],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePickerOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? const Color(0xFF6A5ACD)),
      title: Text(
        title,
        style: TextStyle(
          color: color ?? Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  Future<void> _pickLogoFromGallery() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 512,
        maxHeight: 512,
      );

      if (pickedFile != null) {
        setState(() {
          _shopLogo = File(pickedFile.path);
        });
        _showSnackBar(context, 'Shop logo updated');
        // Here you would upload to Firebase Storage and update the URL
      }
    } catch (e) {
      _showErrorSnackBar(context, 'Failed to pick image: $e');
    }
  }

  Future<void> _pickLogoFromCamera() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 512,
        maxHeight: 512,
      );

      if (pickedFile != null) {
        setState(() {
          _shopLogo = File(pickedFile.path);
        });
        _showSnackBar(context, 'Shop logo updated');
        // Here you would upload to Firebase Storage and update the URL
      }
    } catch (e) {
      _showErrorSnackBar(context, 'Failed to capture image: $e');
    }
  }

  void _removeLogo() {
    setState(() {
      _shopLogo = null;
    });
    _updateFieldInFirebase('photoURL', null);
    _showSnackBar(context, 'Shop logo removed');
  }

  // ----------------- Utility Methods -----------------
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF6A5ACD),
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
      ),
    );
  }
}