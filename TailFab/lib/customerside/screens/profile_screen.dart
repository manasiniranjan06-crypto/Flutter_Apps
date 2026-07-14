
// import 'package:firebaseauth/customerside/components/gradient_scaffold.dart';
// import 'package:firebaseauth/customerside/screens/customer_SuppertHelp.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'dart:io';
// import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({Key? key}) : super(key: key);

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   // TextEditingControllers for all fields
//   late TextEditingController nameController;
//   late TextEditingController emailController;
//   late TextEditingController phoneController;
//   late TextEditingController addressController;

//   // User data with default values
//   String userName = "";
//   String userEmail = "";
//   String userPhone = "";
//   String userAddress = "";
//   int totalOrders = 0;
//   int activeOrders = 0;

//   // Image picker
//   final ImagePicker _imagePicker = ImagePicker();
//   File? _selectedImage;
//   String? _imagePath;

//   // SharedPreferences instance
//   late SharedPreferences _prefs;

//   @override
//   void initState() {
//     super.initState();
    
//     // Initialize controllers
//     nameController = TextEditingController();
//     emailController = TextEditingController();
//     phoneController = TextEditingController();
//     addressController = TextEditingController();
    
//     _loadUserData();
//   }

//   @override
//   void dispose() {
//     // Dispose all controllers
//     nameController.dispose();
//     emailController.dispose();
//     phoneController.dispose();
//     addressController.dispose();
//     super.dispose();
//   }

//   // Load user data from SharedPreferences
//   Future<void> _loadUserData() async {
//     _prefs = await SharedPreferences.getInstance();
    
//     setState(() {
//       userName = _prefs.getString('userName') ?? "";
//       userEmail = _prefs.getString('userEmail') ?? "";
//       userPhone = _prefs.getString('userPhone') ?? "";
//       userAddress = _prefs.getString('userAddress') ?? "";
//       totalOrders = _prefs.getInt('totalOrders') ?? 0;
//       activeOrders = _prefs.getInt('activeOrders') ?? 0;
//       _imagePath = _prefs.getString('profileImagePath');
      
//       // Set controller values
//       nameController.text = userName;
//       emailController.text = userEmail;
//       phoneController.text = userPhone;
//       addressController.text = userAddress;
      
//       // Load image if path exists
//       if (_imagePath != null && _imagePath!.isNotEmpty) {
//         _selectedImage = File(_imagePath!);
//       }
//     });
//   }

//   // Save user data to SharedPreferences
//   Future<void> _saveUserData() async {
//     await _prefs.setString('userName', userName);
//     await _prefs.setString('userEmail', userEmail);
//     await _prefs.setString('userPhone', userPhone);
//     await _prefs.setString('userAddress', userAddress);
//     await _prefs.setInt('totalOrders', totalOrders);
//     await _prefs.setInt('activeOrders', activeOrders);
//   }

//   // Save image path to SharedPreferences
//   Future<void> _saveImagePath(String? path) async {
//     if (path != null) {
//       await _prefs.setString('profileImagePath', path);
//     } else {
//       await _prefs.remove('profileImagePath');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GradientScaffold(
//       appBar: AppBar(
//         title: Text(
//           'Profile',
//           style: GoogleFonts.poppins(
//             color: Colors.white,
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       child: LayoutBuilder(
//         builder: (context, constraints) {
//           return SingleChildScrollView(
//             physics: const AlwaysScrollableScrollPhysics(),
//             child: ConstrainedBox(
//               constraints: BoxConstraints(
//                 minHeight: constraints.maxHeight,
//               ),
//               child: IntrinsicHeight(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Profile Header - Fixed height
//                     Container(
//                       height: 220,
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                           colors: [
//                             const Color(0xFF8075FF),
//                             const Color(0xFF8075FF).withOpacity(0.8)
//                           ],
//                         ),
//                       ),
//                       child: SafeArea(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             // Profile Picture
//                             GestureDetector(
//                               onTap: _showImagePickerBottomSheet,
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   border: Border.all(color: Colors.white, width: 3),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black.withOpacity(0.2),
//                                       blurRadius: 8,
//                                       offset: const Offset(0, 4),
//                                     ),
//                                   ],
//                                 ),
//                                 child: Stack(
//                                   children: [
//                                     CircleAvatar(
//                                       radius: 50,
//                                       backgroundColor: Colors.white,
//                                       backgroundImage: _selectedImage != null
//                                           ? FileImage(_selectedImage!)
//                                           : null,
//                                       child: _selectedImage == null
//                                           ? Text(
//                                               userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
//                                               style: TextStyle(
//                                                 fontSize: 40,
//                                                 fontWeight: FontWeight.bold,
//                                                 color: const Color(0xFF8075FF),
//                                               ),
//                                             )
//                                           : null,
//                                     ),
//                                     // Edit icon overlay
//                                     Positioned(
//                                       bottom: 0,
//                                       right: 0,
//                                       child: Container(
//                                         padding: const EdgeInsets.all(6),
//                                         decoration: const BoxDecoration(
//                                           color: Colors.white,
//                                           shape: BoxShape.circle,
//                                         ),
//                                         child: Icon(
//                                           Icons.camera_alt,
//                                           color: const Color(0xFF8075FF),
//                                           size: 16,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 16),
//                             Text(
//                               userName.isNotEmpty ? userName : 'Your Name',
//                               style: GoogleFonts.poppins(
//                                 fontSize: 24,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white,
//                               ),
//                             ),
//                             Text(
//                               userEmail.isNotEmpty ? userEmail : 'your.email@example.com',
//                               style: GoogleFonts.poppins(
//                                 fontSize: 16,
//                                 color: Colors.white.withOpacity(0.9),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),

//                     // Profile Content - Flexible to take remaining space
//                     Expanded(
//                       child: Container(
//                         width: double.infinity,
//                         child: Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               // Order Statistics
//                               Row(
//                                 children: [
//                                   Expanded(
//                                     child: _buildStatCard(
//                                       'Total Orders',
//                                       totalOrders.toString(),
//                                       Icons.shopping_bag,
//                                       const Color(0xFF8075FF),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 16),
//                                   Expanded(
//                                     child: _buildStatCard(
//                                       'Active Orders',
//                                       activeOrders.toString(),
//                                       Icons.pending_actions,
//                                       Colors.orange,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 24),

//                               // Personal Information
//                               _buildSectionHeader('Personal Information'),
//                               const SizedBox(height: 12),
//                               _buildInfoCard(
//                                 icon: Icons.person,
//                                 title: 'Name',
//                                 subtitle: userName.isNotEmpty ? userName : 'Tap to add your name',
//                                 onTap: () => _showEditDialog(
//                                   context, 
//                                   'Name', 
//                                   userName, 
//                                   nameController,
//                                   (value) {
//                                     setState(() {
//                                       userName = value;
//                                     });
//                                     _saveUserData();
//                                   }
//                                 ),
//                               ),
//                               const SizedBox(height: 12),
//                               _buildInfoCard(
//                                 icon: Icons.email,
//                                 title: 'Email',
//                                 subtitle: userEmail.isNotEmpty ? userEmail : 'Tap to add your email',
//                                 onTap: () => _showEditDialog(
//                                   context, 
//                                   'Email', 
//                                   userEmail, 
//                                   emailController,
//                                   (value) {
//                                     setState(() {
//                                       userEmail = value;
//                                     });
//                                     _saveUserData();
//                                   }
//                                 ),
//                               ),
//                               const SizedBox(height: 12),
//                               _buildInfoCard(
//                                 icon: Icons.phone,
//                                 title: 'Phone Number',
//                                 subtitle: userPhone.isNotEmpty ? userPhone : 'Tap to add your phone number',
//                                 onTap: () => _showEditDialog(
//                                   context, 
//                                   'Phone', 
//                                   userPhone, 
//                                   phoneController,
//                                   (value) {
//                                     setState(() {
//                                       userPhone = value;
//                                     });
//                                     _saveUserData();
//                                   }
//                                 ),
//                               ),
//                               const SizedBox(height: 12),
//                               _buildInfoCard(
//                                 icon: Icons.location_on,
//                                 title: 'Address',
//                                 subtitle: userAddress.isNotEmpty ? userAddress : 'Tap to add your address',
//                                 onTap: () => _showEditDialog(
//                                   context, 
//                                   'Address', 
//                                   userAddress, 
//                                   addressController,
//                                   (value) {
//                                     setState(() {
//                                       userAddress = value;
//                                     });
//                                     _saveUserData();
//                                   }
//                                 ),
//                               ),
//                               const SizedBox(height: 24),

//                               // Measurements
//                               _buildSectionHeader('My Measurements'),
//                               const SizedBox(height: 12),
//                               _buildMeasurementCard(),
//                               const SizedBox(height: 24),

//                               // Settings
//                               _buildSectionHeader('Settings & Preferences'),
//                               const SizedBox(height: 12),
//                               _buildSettingsOption(
//                                 icon: Icons.notifications,
//                                 title: 'Notifications',
//                                 subtitle: 'Manage notification preferences',
//                                 onTap: () => _showSnackBar(context, 'Notifications settings'),
//                               ),
//                               const SizedBox(height: 12),
//                               _buildSettingsOption(
//                                 icon: Icons.favorite,
//                                 title: 'Favorite Tailors',
//                                 subtitle: 'View your saved tailors',
//                                 onTap: () => _showSnackBar(context, 'Favorite tailors'),
//                               ),
//                               const SizedBox(height: 12),
//                               _buildSettingsOption(
//                                 icon: Icons.history,
//                                 title: 'Order History',
//                                 subtitle: 'View all past orders',
//                                 onTap: () => _showSnackBar(context, 'Order history'),
//                               ),
//                               const SizedBox(height: 12),
//                               _buildSettingsOption(
//                                 icon: Icons.payment,
//                                 title: 'Payment Methods',
//                                 subtitle: 'Manage saved payment options',
//                                 onTap: () => _showSnackBar(context, 'Payment methods'),
//                               ),
//                               const SizedBox(height: 12),
//                               _buildSettingsOption(
//                                 icon: Icons.help_outline,
//                                 title: 'Help & Support',
//                                 subtitle: 'Get help with your orders',
//                                 onTap: () {
//                                   Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomerHelpSupportPage()));
      
//                                 }
//                               ),
//                               const SizedBox(height: 24),

//                               // Logout Button
//                               SizedBox(
//                                 width: double.infinity,
//                                 child: ElevatedButton.icon(
//                                   onPressed: () => _showLogoutDialog(context),
//                                   icon: const Icon(Icons.logout),
//                                   label: const Text(
//                                     'Logout',
//                                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                                   ),
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.red.shade400,
//                                     foregroundColor: Colors.white,
//                                     padding: const EdgeInsets.symmetric(vertical: 16),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(height: 20),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   // ----------------- Image Picker Methods -----------------
//   void _showImagePickerBottomSheet() {
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
//               // Header
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 child: const Text(
//                   'Choose Profile Photo',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//               ),
//               const Divider(height: 1),
//               // Options
//               _buildImagePickerOption(
//                 icon: Icons.photo_library,
//                 title: 'Choose from Gallery',
//                 onTap: () => _pickImageFromGallery(),
//               ),
//               _buildImagePickerOption(
//                 icon: Icons.photo_camera,
//                 title: 'Take Photo',
//                 onTap: () => _pickImageFromCamera(),
//               ),
//               if (_selectedImage != null)
//                 _buildImagePickerOption(
//                   icon: Icons.delete,
//                   title: 'Remove Photo',
//                   onTap: _removeImage,
//                   color: Colors.red,
//                 ),
//               // Cancel Button
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
//       leading: Icon(icon, color: color ?? const Color(0xFF8075FF)),
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

//   Future<void> _pickImageFromGallery() async {
//     try {
//       final XFile? pickedFile = await _imagePicker.pickImage(
//         source: ImageSource.gallery,
//         imageQuality: 80,
//         maxWidth: 512,
//         maxHeight: 512,
//       );

//       if (pickedFile != null) {
//         setState(() {
//           _selectedImage = File(pickedFile.path);
//           _imagePath = pickedFile.path;
//         });
//         await _saveImagePath(pickedFile.path);
//         _showSnackBar(context, 'Profile photo updated');
//       }
//     } catch (e) {
//       _showErrorSnackBar(context, 'Failed to pick image: $e');
//     }
//   }

//   Future<void> _pickImageFromCamera() async {
//     try {
//       final XFile? pickedFile = await _imagePicker.pickImage(
//         source: ImageSource.camera,
//         imageQuality: 80,
//         maxWidth: 512,
//         maxHeight: 512,
//       );

//       if (pickedFile != null) {
//         setState(() {
//           _selectedImage = File(pickedFile.path);
//           _imagePath = pickedFile.path;
//         });
//         await _saveImagePath(pickedFile.path);
//         _showSnackBar(context, 'Profile photo updated');
//       }
//     } catch (e) {
//       _showErrorSnackBar(context, 'Failed to capture image: $e');
//     }
//   }

//   void _removeImage() async {
//     setState(() {
//       _selectedImage = null;
//       _imagePath = null;
//     });
//     await _saveImagePath(null);
//     _showSnackBar(context, 'Profile photo removed');
//   }

//   // ----------------- Helper Widgets -----------------
//   Widget _buildStatCard(String title, String value, IconData icon, Color color) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Icon(icon, size: 32, color: color),
//           const SizedBox(height: 8),
//           Text(
//             value,
//             style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             title,
//             textAlign: TextAlign.center,
//             style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSectionHeader(String title) => Text(
//         title,
//         style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
//       );

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
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 10,
//               offset: const Offset(0, 2)),
//         ],
//       ),
//       child: ListTile(
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         leading: Container(
//           padding: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//               color: const Color(0xFF8075FF).withOpacity(0.1),
//               borderRadius: BorderRadius.circular(10)),
//           child: Icon(icon, color: const Color(0xFF8075FF), size: 22),
//         ),
//         title: Text(
//           title,
//           style: const TextStyle(
//               fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
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

//   Widget _buildMeasurementCard() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 10,
//               offset: const Offset(0, 2)),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 'Saved Measurements',
//                 style: TextStyle(
//                     fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
//               ),
//               TextButton.icon(
//                 onPressed: () => _showSnackBar(context, 'Add measurements'),
//                 icon: const Icon(Icons.add, size: 18),
//                 label: const Text('Add'),
//                 style: TextButton.styleFrom(foregroundColor: const Color(0xFF8075FF)),
//               ),
//             ],
//           ),
//           const Divider(),
//           const SizedBox(height: 8),
//           _buildMeasurementRow('Shirt', 'Chest: 38", Length: 28"'),
//           const SizedBox(height: 8),
//           _buildMeasurementRow('Pant', 'Waist: 32", Length: 40"'),
//           const SizedBox(height: 8),
//           _buildMeasurementRow('Kurta', 'Chest: 40", Length: 42"'),
//         ],
//       ),
//     );
//   }

//   Widget _buildMeasurementRow(String type, String measurements) {
//     return Row(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//               color: const Color(0xFF8075FF).withOpacity(0.1),
//               borderRadius: BorderRadius.circular(8)),
//           child: const Icon(Icons.straighten, color: Color(0xFF8075FF), size: 18),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 type,
//                 style: const TextStyle(
//                     fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
//               ),
//               Text(
//                 measurements,
//                 style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ],
//           ),
//         ),
//         IconButton(
//           icon: Icon(Icons.edit, color: Colors.grey[400], size: 18),
//           onPressed: () => _showSnackBar(context, 'Edit $type measurement'),
//         ),
//       ],
//     );
//   }

//   Widget _buildSettingsOption({
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
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 10,
//               offset: const Offset(0, 2)),
//         ],
//       ),
//       child: ListTile(
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         leading: Container(
//           padding: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//               color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)),
//           child: Icon(icon, color: Colors.grey[700], size: 22),
//         ),
//         title: Text(
//           title,
//           style: const TextStyle(
//               fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87),
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

//   // ----------------- Utility Methods -----------------
//   void _showEditDialog(BuildContext context, String field, String currentValue, TextEditingController controller, Function(String) onSave) {
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
//           maxLines: field == 'Address' ? 3 : 1,
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

//   void _showLogoutDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Logout'),
//         content: const Text('Are you sure you want to logout?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context), 
//             child: const Text('Cancel')
//           ),
//           ElevatedButton(
//             onPressed: () {
//               _clearUserData();
//               Navigator.pop(context);
//               _showSnackBar(context, 'Logged out successfully');
//             },
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             child: const Text('Logout'),
//           ),
//         ],
//       ),
//     );
//   }

//   // Clear user data on logout
//   Future<void> _clearUserData() async {
//     await _prefs.clear();
//     setState(() {
//       userName = "";
//       userEmail = "";
//       userPhone = "";
//       userAddress = "";
//       totalOrders = 0;
//       activeOrders = 0;
//       _selectedImage = null;
//       _imagePath = null;
      
//       // Clear controllers
//       nameController.clear();
//       emailController.clear();
//       phoneController.clear();
//       addressController.clear();
//     });
//   }

//   void _showSnackBar(BuildContext context, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         behavior: SnackBarBehavior.floating,
//         duration: const Duration(seconds: 2),
//         backgroundColor: const Color(0xFF8075FF),
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseauth/TailorSide/view/role_selection.dart';
import 'package:firebaseauth/customerside/components/gradient_scaffold.dart';
import 'package:firebaseauth/customerside/screens/customer_SuppertHelp.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // TextEditingControllers for all fields
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;

  // User data with default values
  String userName = "";
  String userEmail = "";
  String userPhone = "";
  String userAddress = "";
  int totalOrders = 0;
  int activeOrders = 0;
  String userId = "";

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Image picker
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImage;
  String? _imagePath;

  // SharedPreferences instance
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    
    // Initialize controllers
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    addressController = TextEditingController();
    
    _loadUserData();
  }

  @override
  void dispose() {
    // Dispose all controllers
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  // Load user data from Firebase and SharedPreferences
  Future<void> _loadUserData() async {
    _prefs = await SharedPreferences.getInstance();
    
    final User? user = _auth.currentUser;
    
    if (user != null) {
      setState(() {
        userId = user.uid;
      });
      
      try {
        // Fetch user data from Firestore
        DocumentSnapshot userDoc = await _firestore.collection('customers').doc(userId).get();
        
        if (userDoc.exists) {
          Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
          
          setState(() {
            userName = userData['name'] ?? "";
            userEmail = userData['email'] ?? user.email ?? "";
            userPhone = userData['phone'] ?? "";
            userAddress = userData['address'] ?? "";
            totalOrders = userData['totalOrders'] ?? 0;
            activeOrders = userData['activeOrders'] ?? 0;
          });

          // Save to SharedPreferences for offline access
          await _saveUserDataToPrefs();
        } else {
          // If no Firestore data, check SharedPreferences
          _loadUserDataFromPrefs();
        }
      } catch (e) {
        print("Error loading user data: $e");
        // Fallback to SharedPreferences
        _loadUserDataFromPrefs();
      }
    } else {
      // No user logged in, load from SharedPreferences
      _loadUserDataFromPrefs();
    }

    // Set controller values
    nameController.text = userName;
    emailController.text = userEmail;
    phoneController.text = userPhone;
    addressController.text = userAddress;
    
    // Load image if path exists
    if (_imagePath != null && _imagePath!.isNotEmpty) {
      _selectedImage = File(_imagePath!);
    }
  }

  // Load user data from SharedPreferences
  void _loadUserDataFromPrefs() {
    setState(() {
      userName = _prefs.getString('userName') ?? "";
      userEmail = _prefs.getString('userEmail') ?? "";
      userPhone = _prefs.getString('userPhone') ?? "";
      userAddress = _prefs.getString('userAddress') ?? "";
      totalOrders = _prefs.getInt('totalOrders') ?? 0;
      activeOrders = _prefs.getInt('activeOrders') ?? 0;
      _imagePath = _prefs.getString('profileImagePath');
    });
  }

  // Save user data to SharedPreferences
  Future<void> _saveUserDataToPrefs() async {
    await _prefs.setString('userName', userName);
    await _prefs.setString('userEmail', userEmail);
    await _prefs.setString('userPhone', userPhone);
    await _prefs.setString('userAddress', userAddress);
    await _prefs.setInt('totalOrders', totalOrders);
    await _prefs.setInt('activeOrders', activeOrders);
  }

  // Save user data to Firebase
  Future<void> _saveUserDataToFirebase() async {
    if (userId.isNotEmpty) {
      try {
        await _firestore.collection('customers').doc(userId).update({
          'name': userName,
          'email': userEmail,
          'phone': userPhone,
          'address': userAddress,
          'totalOrders': totalOrders,
          'activeOrders': activeOrders,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } catch (e) {
        print("Error saving to Firebase: $e");
      }
    }
  }

  // Save image path to SharedPreferences
  Future<void> _saveImagePath(String? path) async {
    if (path != null) {
      await _prefs.setString('profileImagePath', path);
    } else {
      await _prefs.remove('profileImagePath');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Header - Fixed height
                    Container(
                      height: 220,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFF8075FF),
                            const Color(0xFF8075FF).withOpacity(0.8)
                          ],
                        ),
                      ),
                      child: SafeArea(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Profile Picture
                            GestureDetector(
                              onTap: _showImagePickerBottomSheet,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 3),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 50,
                                      backgroundColor: Colors.white,
                                      backgroundImage: _selectedImage != null
                                          ? FileImage(_selectedImage!)
                                          : null,
                                      child: _selectedImage == null
                                          ? Text(
                                              userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                                              style: TextStyle(
                                                fontSize: 40,
                                                fontWeight: FontWeight.bold,
                                                color: const Color(0xFF8075FF),
                                              ),
                                            )
                                          : null,
                                    ),
                                    // Edit icon overlay
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
                                          color: const Color(0xFF8075FF),
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              userName.isNotEmpty ? userName : 'Your Name',
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              userEmail.isNotEmpty ? userEmail : 'your.email@example.com',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Profile Content - Flexible to take remaining space
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Order Statistics
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildStatCard(
                                      'Total Orders',
                                      totalOrders.toString(),
                                      Icons.shopping_bag,
                                      const Color(0xFF8075FF),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildStatCard(
                                      'Active Orders',
                                      activeOrders.toString(),
                                      Icons.pending_actions,
                                      Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),

                              // Personal Information
                              _buildSectionHeader('Personal Information'),
                              const SizedBox(height: 12),
                              _buildInfoCard(
                                icon: Icons.person,
                                title: 'Name',
                                subtitle: userName.isNotEmpty ? userName : 'Tap to add your name',
                                onTap: () => _showEditDialog(
                                  context, 
                                  'Name', 
                                  userName, 
                                  nameController,
                                  (value) {
                                    setState(() {
                                      userName = value;
                                    });
                                    _saveUserDataToPrefs();
                                    _saveUserDataToFirebase();
                                  }
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildInfoCard(
                                icon: Icons.email,
                                title: 'Email',
                                subtitle: userEmail.isNotEmpty ? userEmail : 'Tap to add your email',
                                onTap: () => _showEditDialog(
                                  context, 
                                  'Email', 
                                  userEmail, 
                                  emailController,
                                  (value) {
                                    setState(() {
                                      userEmail = value;
                                    });
                                    _saveUserDataToPrefs();
                                    _saveUserDataToFirebase();
                                  }
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildInfoCard(
                                icon: Icons.phone,
                                title: 'Phone Number',
                                subtitle: userPhone.isNotEmpty ? userPhone : 'Tap to add your phone number',
                                onTap: () => _showEditDialog(
                                  context, 
                                  'Phone', 
                                  userPhone, 
                                  phoneController,
                                  (value) {
                                    setState(() {
                                      userPhone = value;
                                    });
                                    _saveUserDataToPrefs();
                                    _saveUserDataToFirebase();
                                  }
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildInfoCard(
                                icon: Icons.location_on,
                                title: 'Address',
                                subtitle: userAddress.isNotEmpty ? userAddress : 'Tap to add your address',
                                onTap: () => _showEditDialog(
                                  context, 
                                  'Address', 
                                  userAddress, 
                                  addressController,
                                  (value) {
                                    setState(() {
                                      userAddress = value;
                                    });
                                    _saveUserDataToPrefs();
                                    _saveUserDataToFirebase();
                                  }
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Measurements
                              _buildSectionHeader('My Measurements'),
                              const SizedBox(height: 12),
                              _buildMeasurementCard(),
                              const SizedBox(height: 24),

                              // Settings
                              _buildSectionHeader('Settings & Preferences'),
                              const SizedBox(height: 12),
                              _buildSettingsOption(
                                icon: Icons.notifications,
                                title: 'Notifications',
                                subtitle: 'Manage notification preferences',
                                onTap: () => _showSnackBar(context, 'Notifications settings'),
                              ),
                              const SizedBox(height: 12),
                              _buildSettingsOption(
                                icon: Icons.favorite,
                                title: 'Favorite Tailors',
                                subtitle: 'View your saved tailors',
                                onTap: () => _showSnackBar(context, 'Favorite tailors'),
                              ),
                              const SizedBox(height: 12),
                              _buildSettingsOption(
                                icon: Icons.history,
                                title: 'Order History',
                                subtitle: 'View all past orders',
                                onTap: () => _showSnackBar(context, 'Order history'),
                              ),
                              const SizedBox(height: 12),
                              _buildSettingsOption(
                                icon: Icons.payment,
                                title: 'Payment Methods',
                                subtitle: 'Manage saved payment options',
                                onTap: () => _showSnackBar(context, 'Payment methods'),
                              ),
                              const SizedBox(height: 12),
                              _buildSettingsOption(
                                icon: Icons.help_outline,
                                title: 'Help & Support',
                                subtitle: 'Get help with your orders',
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomerHelpSupportPage()));
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
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ----------------- Image Picker Methods -----------------
  void _showImagePickerBottomSheet() {
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
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                child: const Text(
                  'Choose Profile Photo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const Divider(height: 1),
              // Options
              _buildImagePickerOption(
                icon: Icons.photo_library,
                title: 'Choose from Gallery',
                onTap: () => _pickImageFromGallery(),
              ),
              _buildImagePickerOption(
                icon: Icons.photo_camera,
                title: 'Take Photo',
                onTap: () => _pickImageFromCamera(),
              ),
              if (_selectedImage != null)
                _buildImagePickerOption(
                  icon: Icons.delete,
                  title: 'Remove Photo',
                  onTap: _removeImage,
                  color: Colors.red,
                ),
              // Cancel Button
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
      leading: Icon(icon, color: color ?? const Color(0xFF8075FF)),
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

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 512,
        maxHeight: 512,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
          _imagePath = pickedFile.path;
        });
        await _saveImagePath(pickedFile.path);
        _showSnackBar(context, 'Profile photo updated');
      }
    } catch (e) {
      _showErrorSnackBar(context, 'Failed to pick image: $e');
    }
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 512,
        maxHeight: 512,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
          _imagePath = pickedFile.path;
        });
        await _saveImagePath(pickedFile.path);
        _showSnackBar(context, 'Profile photo updated');
      }
    } catch (e) {
      _showErrorSnackBar(context, 'Failed to capture image: $e');
    }
  }

  void _removeImage() async {
    setState(() {
      _selectedImage = null;
      _imagePath = null;
    });
    await _saveImagePath(null);
    _showSnackBar(context, 'Profile photo removed');
  }

  // ----------------- Helper Widgets -----------------
  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) => Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
      );

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
              offset: const Offset(0, 2)),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: const Color(0xFF8075FF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: const Color(0xFF8075FF), size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
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

  Widget _buildMeasurementCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Saved Measurements',
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              TextButton.icon(
                onPressed: () => _showSnackBar(context, 'Add measurements'),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add'),
                style: TextButton.styleFrom(foregroundColor: const Color(0xFF8075FF)),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 8),
          _buildMeasurementRow('Shirt', 'Chest: 38", Length: 28"'),
          const SizedBox(height: 8),
          _buildMeasurementRow('Pant', 'Waist: 32", Length: 40"'),
          const SizedBox(height: 8),
          _buildMeasurementRow('Kurta', 'Chest: 40", Length: 42"'),
        ],
      ),
    );
  }

  Widget _buildMeasurementRow(String type, String measurements) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: const Color(0xFF8075FF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8)),
          child: const Icon(Icons.straighten, color: Color(0xFF8075FF), size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                type,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
              ),
              Text(
                measurements,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(Icons.edit, color: Colors.grey[400], size: 18),
          onPressed: () => _showSnackBar(context, 'Edit $type measurement'),
        ),
      ],
    );
  }

  Widget _buildSettingsOption({
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
              offset: const Offset(0, 2)),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: Colors.grey[700], size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87),
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

  // ----------------- Utility Methods -----------------
  void _showEditDialog(BuildContext context, String field, String currentValue, TextEditingController controller, Function(String) onSave) {
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
          maxLines: field == 'Address' ? 3 : 1,
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
                _showSnackBar(context, '$field updated successfully');
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
            
            Navigator.pop(context); // Close the dialog
            
            // Navigate to role selection screen and clear all previous routes
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => RoleSelectionScreen(), // Replace with your actual role selection screen
              ),
              (route) => false, // This removes all previous routes
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


  // Clear user data on logout
  Future<void> _clearUserData() async {
    await _prefs.clear();
    setState(() {
      userName = "";
      userEmail = "";
      userPhone = "";
      userAddress = "";
      totalOrders = 0;
      activeOrders = 0;
      _selectedImage = null;
      _imagePath = null;
      
      // Clear controllers
      nameController.clear();
      emailController.clear();
      phoneController.clear();
      addressController.clear();
    });
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF8075FF),
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