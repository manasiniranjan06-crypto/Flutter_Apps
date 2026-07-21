

// import 'package:firebaseauth/login_signupScreen/view/shopkeeper_login_screen.dart';
// import 'package:firebaseauth/login_signupScreen/view/tailor_verificatioscreen.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'dart:math' as math;

// // Initialize Firebase
// Future<void> initializeFirebase() async {
//   await Firebase.initializeApp(
//     options: const FirebaseOptions(
//       apiKey: "AIzaSyDNVLQsAe6ANEEm5oCh3WnwQMYev9w7G5E",
//       appId: "1:87909089095:android:985d9714e2b4437b435662",
//       messagingSenderId: "87909089095",
//       projectId: "flutter-superx-3c3e1",
//     ),
//   );
// }

// // Enhanced controller class with Firebase authentication
// class TailorSignUpController {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController shopNameController = TextEditingController();
//   final TextEditingController addressController = TextEditingController();
//   final TextEditingController gstController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmPasswordController = TextEditingController();
  
//   String? selectedCategory;
//   String? selectedCity;
  
//   String? nameError;
//   String? emailError;
//   String? phoneError;
//   String? shopNameError;
//   String? categoryError;
//   String? cityError;
//   String? addressError;
//   String? passwordError;
//   String? confirmPasswordError;

//   final List<String> categories = [
//     'Traditional Wear',
//     'Western Wear',
//     'Bridal & Wedding',
//     'Custom Tailoring',
//     'Alterations & Repairs',
//     'Uniforms',
//     'Accessories',
//     'Other',
//   ];

//   final List<String> cities = [
//     'Mumbai',
//     'Delhi',
//     'Bangalore',
//     'Hyderabad',
//     'Chennai',
//     'Kolkata',
//     'Pune',
//     'Ahmedabad',
//   ];

//   bool validateInputs() {
//     nameError = null;
//     emailError = null;
//     phoneError = null;
//     shopNameError = null;
//     categoryError = null;
//     cityError = null;
//     addressError = null;
//     passwordError = null;
//     confirmPasswordError = null;

//     bool isValid = true;

//     if (nameController.text.isEmpty) {
//       nameError = 'Please enter your name';
//       isValid = false;
//     }

//     if (emailController.text.isEmpty) {
//       emailError = 'Please enter your email';
//       isValid = false;
//     } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(emailController.text)) {
//       emailError = 'Please enter a valid email';
//       isValid = false;
//     }

//     if (phoneController.text.isEmpty) {
//       phoneError = 'Please enter your phone number';
//       isValid = false;
//     } else if (phoneController.text.length != 10) {
//       phoneError = 'Please enter a valid 10-digit phone number';
//       isValid = false;
//     }

//     if (shopNameController.text.isEmpty) {
//       shopNameError = 'Please enter your shop name';
//       isValid = false;
//     }

//     if (selectedCategory == null) {
//       categoryError = 'Please select a category';
//       isValid = false;
//     }

//     if (selectedCity == null) {
//       cityError = 'Please select a city';
//       isValid = false;
//     }

//     if (addressController.text.isEmpty) {
//       addressError = 'Please enter your shop address';
//       isValid = false;
//     }

//     if (passwordController.text.isEmpty) {
//       passwordError = 'Please enter a password';
//       isValid = false;
//     } else if (passwordController.text.length < 6) {
//       passwordError = 'Password must be at least 6 characters';
//       isValid = false;
//     }

//     if (confirmPasswordController.text.isEmpty) {
//       confirmPasswordError = 'Please confirm your password';
//       isValid = false;
//     } else if (passwordController.text != confirmPasswordController.text) {
//       confirmPasswordError = 'Passwords do not match';
//       isValid = false;
//     }

//     return isValid;
//   }

//   Future<Map<String, dynamic>> signUp() async {
//     try {
//       // Create user with email and password
//       UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: emailController.text.trim(),
//         password: passwordController.text,
//       );

//       // Save user data to Firestore
//       await FirebaseFirestore.instance.collection('tailors').doc(userCredential.user!.uid).set({
//         'name': nameController.text.trim(),
//         'email': emailController.text.trim(),
//         'phone': phoneController.text.trim(),
//         'shopName': shopNameController.text.trim(),
//         'category': selectedCategory,
//         'city': selectedCity,
//         'address': addressController.text.trim(),
//         'gstNumber': gstController.text.trim(),
//         'createdAt': FieldValue.serverTimestamp(),
//         'updatedAt': FieldValue.serverTimestamp(),
//         'userType': 'tailor',
//         'isVerified': false,
//       });

//       return {'success': true, 'user': userCredential.user};
//     } on FirebaseAuthException catch (e) {
//       String errorMessage = 'Signup failed. Please try again.';
//       if (e.code == 'weak-password') {
//         errorMessage = 'The password provided is too weak.';
//       } else if (e.code == 'email-already-in-use') {
//         errorMessage = 'An account already exists for that email.';
//       } else if (e.code == 'invalid-email') {
//         errorMessage = 'The email address is not valid.';
//       }
//       return {'success': false, 'error': errorMessage};
//     } catch (e) {
//       return {'success': false, 'error': 'An unexpected error occurred. Please try again.'};
//     }
//   }

//   Future<Map<String, dynamic>> signInWithGoogle() async {
//     try {
//       // Trigger the authentication flow
//       final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

//       if (googleUser == null) {
//         return {'success': false, 'error': 'Google sign in was cancelled'};
//       }

//       // Obtain the auth details from the request
//       final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

//       // Create a new credential
//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       // Once signed in, return the UserCredential
//       UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

//       // Check if this is a new user
//       final userDoc = await FirebaseFirestore.instance.collection('tailors').doc(userCredential.user!.uid).get();
      
//       if (!userDoc.exists) {
//         // New user - save their data
//         await FirebaseFirestore.instance.collection('tailors').doc(userCredential.user!.uid).set({
//           'name': userCredential.user!.displayName ?? nameController.text.trim(),
//           'email': userCredential.user!.email!,
//           'phone': phoneController.text.trim(),
//           'shopName': shopNameController.text.trim().isNotEmpty ? shopNameController.text.trim() : '${userCredential.user!.displayName ?? "Tailor"}\'s Shop',
//           'category': selectedCategory,
//           'city': selectedCity,
//           'address': addressController.text.trim(),
//           'gstNumber': gstController.text.trim(),
//           'createdAt': FieldValue.serverTimestamp(),
//           'updatedAt': FieldValue.serverTimestamp(),
//           'userType': 'tailor',
//           'isVerified': false,
//           'photoURL': userCredential.user!.photoURL,
//         });
//       }

//       return {'success': true, 'user': userCredential.user};
//     } on FirebaseAuthException catch (e) {
//       return {'success': false, 'error': 'Google sign in failed: ${e.message}'};
//     } catch (e) {
//       return {'success': false, 'error': 'An unexpected error occurred during Google sign in.'};
//     }
//   }

//   void dispose() {
//     nameController.dispose();
//     emailController.dispose();
//     phoneController.dispose();
//     shopNameController.dispose();
//     addressController.dispose();
//     gstController.dispose();
//     passwordController.dispose();
//     confirmPasswordController.dispose();
//   }
// }

// class TailorSignUpScreen extends StatefulWidget {
//   const TailorSignUpScreen({super.key});

//   @override
//   State<TailorSignUpScreen> createState() => _TailorSignUpScreenState();
// }

// class _TailorSignUpScreenState extends State<TailorSignUpScreen> with TickerProviderStateMixin {
  
//   final TailorSignUpController _controller = TailorSignUpController();
//   bool _isLoading = false;
//   bool _isPasswordVisible = false;
//   bool _isConfirmPasswordVisible = false;
//   late AnimationController _animationController;
//   late AnimationController _tailorAnimationController;
//   late AnimationController _scissorsAnimationController;
//   late AnimationController _needleAnimationController;
//   late AnimationController _floatingController;
  
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;
//   late Animation<double> _tailorScaleAnimation;
//   late Animation<double> _scissorsRotation;
//   late Animation<double> _needleAnimation;
//   late Animation<double> _floatingAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _initializeApp();
    
//     // Main animation controller
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 1200),
//       vsync: this,
//     );

//     _fadeAnimation = CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeIn,
//     );

//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.3),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeOutCubic,
//     ));

//     // Tailor character animation
//     _tailorAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 1500),
//       vsync: this,
//     );

//     _tailorScaleAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _tailorAnimationController,
//       curve: Curves.elasticOut,
//     ));

//     // Scissors cutting animation
//     _scissorsAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     )..repeat(reverse: true);

//     _scissorsRotation = Tween<double>(
//       begin: -0.1,
//       end: 0.1,
//     ).animate(CurvedAnimation(
//       parent: _scissorsAnimationController,
//       curve: Curves.easeInOut,
//     ));

//     // Needle threading animation
//     _needleAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 2000),
//       vsync: this,
//     )..repeat();

//     _needleAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(_needleAnimationController);

//     // Floating animation for elements
//     _floatingController = AnimationController(
//       duration: const Duration(milliseconds: 3000),
//       vsync: this,
//     )..repeat(reverse: true);

//     _floatingAnimation = Tween<double>(
//       begin: -10.0,
//       end: 10.0,
//     ).animate(CurvedAnimation(
//       parent: _floatingController,
//       curve: Curves.easeInOut,
//     ));

//     _animationController.forward();
//     _tailorAnimationController.forward();
//   }

//   Future<void> _initializeApp() async {
//     await initializeFirebase();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     _tailorAnimationController.dispose();
//     _scissorsAnimationController.dispose();
//     _needleAnimationController.dispose();
//     _floatingController.dispose();
//     _controller.dispose();
//     super.dispose();
//   }

//   void _showPicker(BuildContext context, List<String> items, String? currentValue, Function(String?) onSelected) {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return Container(
//           height: 300,
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               Container(
//                 width: 40,
//                 height: 4,
//                 margin: const EdgeInsets.only(bottom: 20),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: items.length,
//                   itemBuilder: (context, index) {
//                     final item = items[index];
//                     final isSelected = item == currentValue;
//                     return ListTile(
//                       title: Text(
//                         item,
//                         style: TextStyle(
//                           fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//                           color: isSelected ? Theme.of(context).primaryColor : Colors.black87,
//                         ),
//                       ),
//                       trailing: isSelected ? const Icon(Icons.check, color: Colors.blue) : null,
//                       onTap: () {
//                         onSelected(item);
//                         Navigator.pop(context);
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _handleSignUp() async {
//     if (_controller.validateInputs()) {
//       setState(() => _isLoading = true);
      
//       final result = await _controller.signUp();
      
//       setState(() => _isLoading = false);

//       if (result['success'] == true) {
//         _showMessage('Sign Up Successful!', true);
//         // Navigate to next screen
//         // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => TailorDashboard()));
//       } else {
//         _showMessage(result['error'] ?? 'Sign Up Failed. Please try again.', false);
//       }
//     } else {
//       setState(() {});
//     }
//   }

//   void _handleGoogleSignUp() async {
//     setState(() => _isLoading = true);
//     final result = await _controller.signInWithGoogle();
//     setState(() => _isLoading = false);
    
//     if (result['success'] == true) {
//       _showMessage('Google Sign Up Successful!', true);
//       // Navigate to next screen
//       // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => TailorDashboard()));
//     } else {
//       _showMessage(result['error'] ?? 'Google Sign Up Failed', false);
//     }
//   }

//   void _showMessage(String message, bool isSuccess) {
//     if (!mounted) return;

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: isSuccess ? const Color(0xFFD4145A) : Colors.red,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//               //  _buildHeader(),
//                 const SizedBox(height: 30),
//                 FadeTransition(
//                   opacity: _fadeAnimation,
//                   child: SlideTransition(
//                     position: _slideAnimation,
//                     child: _buildSignUpCard(),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // ... (Keep all the existing UI builder methods: _buildHeader, _buildTailorCharacter, etc.)

//   Widget _buildSignUpCard() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20),
//       padding: const EdgeInsets.only(top: 20, right: 30, left: 30, bottom: 40),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(30),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 20,
//             offset: const Offset(0, 10),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Text(
//                 'Tailor Sign Up',
//                 style: GoogleFonts.poppins(
//                   fontSize: 32,
//                   fontWeight: FontWeight.bold,
//                   color: const Color.fromARGB(255, 5, 86, 208),
//                 ),
//               ),
//               const SizedBox(width: 10),
//               TweenAnimationBuilder<double>(
//                 duration: const Duration(milliseconds: 2000),
//                 tween: Tween(begin: 0.0, end: 1.0),
//                 builder: (context, value, child) {
//                   return Transform.rotate(
//                     angle: value * 2 * math.pi,
//                     child: const Icon(
//                       Icons.content_cut,
//                       color: Color.fromARGB(255, 5, 86, 208),
//                       size: 24,
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//           const SizedBox(height: 30),

//           // Owner Name
//           _buildTextField(
//             controller: _controller.nameController,
//             label: 'Owner Name',
//             icon: Icons.person_outline,
//             errorText: _controller.nameError,
//             keyboardType: TextInputType.name,
//           ),
//           const SizedBox(height: 20),

//           // Email
//           _buildTextField(
//             controller: _controller.emailController,
//             label: 'Email',
//             icon: Icons.email_outlined,
//             errorText: _controller.emailError,
//             keyboardType: TextInputType.emailAddress,
//           ),
//           const SizedBox(height: 20),

//           // Phone Number
//           _buildTextField(
//             controller: _controller.phoneController,
//             label: 'Phone Number',
//             icon: Icons.phone_outlined,
//             errorText: _controller.phoneError,
//             keyboardType: TextInputType.phone,
//             maxLength: 10,
//           ),
//           const SizedBox(height: 20),

//           // Shop Name
//           _buildTextField(
//             controller: _controller.shopNameController,
//             label: 'Shop Name',
//             icon: Icons.store_outlined,
//             errorText: _controller.shopNameError,
//             keyboardType: TextInputType.text,
//           ),
//           const SizedBox(height: 20),

//           // Password
//           _buildPasswordField(
//             controller: _controller.passwordController,
//             label: 'Password',
//             errorText: _controller.passwordError,
//             isPassword: true,
//             obscureText: !_isPasswordVisible,
//             onToggleVisibility: () {
//               setState(() => _isPasswordVisible = !_isPasswordVisible);
//             },
//           ),
//           const SizedBox(height: 20),

//           // Confirm Password
//           _buildPasswordField(
//             controller: _controller.confirmPasswordController,
//             label: 'Confirm Password',
//             errorText: _controller.confirmPasswordError,
//             isPassword: true,
//             obscureText: !_isConfirmPasswordVisible,
//             onToggleVisibility: () {
//               setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible);
//             },
//           ),
//           const SizedBox(height: 20),

//           // Shop Category Picker
//           _buildCategoryPicker(),
//           if (_controller.categoryError != null) _buildErrorText(_controller.categoryError!),
//           const SizedBox(height: 20),

//           // City Picker
//           _buildCityPicker(),
//           if (_controller.cityError != null) _buildErrorText(_controller.cityError!),
//           const SizedBox(height: 20),

//           // Address
//           _buildTextField(
//             controller: _controller.addressController,
//             label: 'Shop Address',
//             icon: Icons.location_on_outlined,
//             errorText: _controller.addressError,
//             keyboardType: TextInputType.multiline,
//             maxLines: 3,
//           ),
//           const SizedBox(height: 20),

//           // GST Number (Optional)
//           _buildTextField(
//             controller: _controller.gstController,
//             label: 'GST Number (Optional)',
//             icon: Icons.receipt_outlined,
//             errorText: null,
//             keyboardType: TextInputType.text,
//           ),

//           const SizedBox(height: 30),

//           // Sign Up Button
// SizedBox(
//   width: double.infinity,
//   height: 55,
//   child: ElevatedButton(
//     onPressed: () {
      
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => VerificationScreen(phoneNumber: '',)),
//       );
//     },
//     style: ElevatedButton.styleFrom(
//       backgroundColor: const Color(0xFFD4145A),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15),
//       ),
//       elevation: 5,
//     ),
//     child: _isLoading
//         ? const SizedBox(
//             height: 20,
//             width: 20,
//             child: CircularProgressIndicator(
//               color: Colors.white,
//               strokeWidth: 2,
//             ),
//           )
//         : Text(
//             'Sign Up',
//             style: GoogleFonts.poppins(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               color: Colors.white,
//             ),
//           ),
//   ),
// ),

//           const SizedBox(height: 25),

//           Row(
//             children: [
//               Expanded(child: Divider(color: Colors.grey[300])),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 15),
//                 child: Text(
//                   'Or sign up with',
//                   style: GoogleFonts.poppins(
//                     color: Colors.grey,
//                     fontSize: 12,
//                   ),
//                 ),
//               ),
//               Expanded(child: Divider(color: Colors.grey[300])),
//             ],
//           ),

//           const SizedBox(height: 25),

//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               _buildSocialButton(Icons.mail, Colors.red, 'Google', _handleGoogleSignUp),
//             ],
//           ),

//           const SizedBox(height: 25),

//           Center(
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   "Already have an account? ",
//                   style: GoogleFonts.poppins(
//                     color: Colors.grey[600],
//                     fontSize: 13,
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     // Navigate to login screen
//                      Navigator.push(context, MaterialPageRoute(builder: (_) => ShopkeeperLoginScreen()));
//                   },
//                   child: Text(
//                     'Login',
//                     style: GoogleFonts.poppins(
//                       color: const Color(0xFFD4145A),
//                       fontSize: 13,
//                       fontWeight: FontWeight.bold,
//                       decoration: TextDecoration.underline,
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     String? errorText,
//     TextInputType? keyboardType,
//     int maxLines = 1,
//     int? maxLength,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.grey[100],
//             borderRadius: BorderRadius.circular(15),
//             border: Border.all(
//               color: errorText != null ? Colors.red : Colors.transparent,
//             ),
//           ),
//           child: TextField(
//             controller: controller,
//             keyboardType: keyboardType,
//             maxLines: maxLines,
//             maxLength: maxLength,
//             style: GoogleFonts.poppins(),
//             decoration: InputDecoration(
//               prefixIcon: Icon(icon, color: Colors.grey),
//               hintText: label,
//               hintStyle: GoogleFonts.poppins(color: Colors.grey),
//               border: InputBorder.none,
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 20,
//                 vertical: 18,
//               ),
//               counterText: '',
//             ),
//           ),
//         ),
//         if (errorText != null) _buildErrorText(errorText),
//       ],
//     );
//   }

//   Widget _buildPasswordField({
//     required TextEditingController controller,
//     required String label,
//     required String? errorText,
//     required bool isPassword,
//     required bool obscureText,
//     required VoidCallback onToggleVisibility,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.grey[100],
//             borderRadius: BorderRadius.circular(15),
//             border: Border.all(
//               color: errorText != null ? Colors.red : Colors.transparent,
//             ),
//           ),
//           child: TextField(
//             controller: controller,
//             obscureText: obscureText,
//             style: GoogleFonts.poppins(),
//             decoration: InputDecoration(
//               prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
//               suffixIcon: IconButton(
//                 icon: Icon(
//                   obscureText ? Icons.visibility : Icons.visibility_off,
//                   color: Colors.grey,
//                 ),
//                 onPressed: onToggleVisibility,
//               ),
//               hintText: label,
//               hintStyle: GoogleFonts.poppins(color: Colors.grey),
//               border: InputBorder.none,
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 20,
//                 vertical: 18,
//               ),
//             ),
//           ),
//         ),
//         if (errorText != null) _buildErrorText(errorText),
//       ],
//     );
//   }

//   Widget _buildCategoryPicker() {
//     return GestureDetector(
//       onTap: () => _showPicker(
//         context,
//         _controller.categories,
//         _controller.selectedCategory,
//         (value) => setState(() => _controller.selectedCategory = value),
//       ),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
//         decoration: BoxDecoration(
//           color: Colors.grey[100],
//           borderRadius: BorderRadius.circular(15),
//           border: Border.all(
//             color: _controller.categoryError != null ? Colors.red : Colors.transparent,
//           ),
//         ),
//         child: Row(
//           children: [
//             const Icon(Icons.category_outlined, color: Colors.grey),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 _controller.selectedCategory ?? 'Select Shop Category',
//                 style: GoogleFonts.poppins(
//                   color: _controller.selectedCategory != null ? Colors.black87 : Colors.grey,
//                 ),
//               ),
//             ),
//             const Icon(Icons.arrow_drop_down, color: Colors.grey),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCityPicker() {
//     return GestureDetector(
//       onTap: () => _showPicker(
//         context,
//         _controller.cities,
//         _controller.selectedCity,
//         (value) => setState(() => _controller.selectedCity = value),
//       ),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
//         decoration: BoxDecoration(
//           color: Colors.grey[100],
//           borderRadius: BorderRadius.circular(15),
//           border: Border.all(
//             color: _controller.cityError != null ? Colors.red : Colors.transparent,
//           ),
//         ),
//         child: Row(
//           children: [
//             const Icon(Icons.location_city_outlined, color: Colors.grey),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 _controller.selectedCity ?? 'Select City',
//                 style: GoogleFonts.poppins(
//                   color: _controller.selectedCity != null ? Colors.black87 : Colors.grey,
//                 ),
//               ),
//             ),
//             const Icon(Icons.arrow_drop_down, color: Colors.grey),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildErrorText(String errorText) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 15, top: 5),
//       child: Text(
//         errorText,
//         style: GoogleFonts.poppins(
//           color: Colors.red,
//           fontSize: 11,
//         ),
//       ),
//     );
//   }

//   Widget _buildSocialButton(IconData icon, Color color, String provider, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: TweenAnimationBuilder<double>(
//         duration: const Duration(milliseconds: 200),
//         tween: Tween(begin: 1.0, end: 1.0),
//         builder: (context, value, child) {
//           return Transform.scale(
//             scale: value,
//             child: Container(
//               width: 55,
//               height: 55,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 shape: BoxShape.circle,
//                 border: Border.all(color: Colors.grey[300]!),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.05),
//                     blurRadius: 10,
//                     offset: const Offset(0, 5),
//                   ),
//                 ],
//               ),
//               child: Icon(icon, color: color, size: 28),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// // Custom painter for animated thread
// class ThreadPainter extends CustomPainter {
//   final double progress;

//   ThreadPainter(this.progress);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.white.withOpacity(0.8)
//       ..strokeWidth = 2
//       ..style = PaintingStyle.stroke;

//     final path = Path();
//     path.moveTo(0, size.height / 2);
    
//     for (double i = 0; i < size.width; i++) {
//       final y = size.height / 2 + math.sin((i / size.width * 2 * math.pi) + (progress * 2 * math.pi)) * 3;
//       path.lineTo(i, y);
//     }

//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(ThreadPainter oldDelegate) => oldDelegate.progress != progress;
// }

import 'package:firebaseauth/TailorSide/view/tailor_ProfileScreen.dart';
import 'package:firebaseauth/login_signupScreen/view/shopkeeper_login_screen.dart';
import 'package:firebaseauth/login_signupScreen/view/tailor_verificatioscreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:math' as math;

// Initialize Firebase
Future<void> initializeFirebase() async {
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDNVLQsAe6ANEEm5oCh3WnwQMYev9w7G5E",
      appId: "1:87909089095:android:985d9714e2b4437b435662",
      messagingSenderId: "87909089095",
      projectId: "flutter-superx-3c3e1",
    ),
  );
}

// Enhanced controller class with Firebase authentication
class TailorSignUpController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController shopNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController gstController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  
  String? selectedCategory;
  String? selectedCity;
  
  String? nameError;
  String? emailError;
  String? phoneError;
  String? shopNameError;
  String? categoryError;
  String? cityError;
  String? addressError;
  String? passwordError;
  String? confirmPasswordError;

  final List<String> categories = [
    'Traditional Wear',
    'Western Wear',
    'Bridal & Wedding',
    'Custom Tailoring',
    'Alterations & Repairs',
    'Uniforms',
    'Accessories',
    'Other',
  ];

  final List<String> cities = [
    'Mumbai',
    'Delhi',
    'Bangalore',
    'Hyderabad',
    'Chennai',
    'Kolkata',
    'Pune',
    'Ahmedabad',
  ];

  bool validateInputs() {
    nameError = null;
    emailError = null;
    phoneError = null;
    shopNameError = null;
    categoryError = null;
    cityError = null;
    addressError = null;
    passwordError = null;
    confirmPasswordError = null;

    bool isValid = true;

    if (nameController.text.isEmpty) {
      nameError = 'Please enter your name';
      isValid = false;
    }

    if (emailController.text.isEmpty) {
      emailError = 'Please enter your email';
      isValid = false;
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(emailController.text)) {
      emailError = 'Please enter a valid email';
      isValid = false;
    }

    if (phoneController.text.isEmpty) {
      phoneError = 'Please enter your phone number';
      isValid = false;
    } else if (phoneController.text.length != 10) {
      phoneError = 'Please enter a valid 10-digit phone number';
      isValid = false;
    }

    if (shopNameController.text.isEmpty) {
      shopNameError = 'Please enter your shop name';
      isValid = false;
    }

    if (selectedCategory == null) {
      categoryError = 'Please select a category';
      isValid = false;
    }

    if (selectedCity == null) {
      cityError = 'Please select a city';
      isValid = false;
    }

    if (addressController.text.isEmpty) {
      addressError = 'Please enter your shop address';
      isValid = false;
    }

    if (passwordController.text.isEmpty) {
      passwordError = 'Please enter a password';
      isValid = false;
    } else if (passwordController.text.length < 6) {
      passwordError = 'Password must be at least 6 characters';
      isValid = false;
    }

    if (confirmPasswordController.text.isEmpty) {
      confirmPasswordError = 'Please confirm your password';
      isValid = false;
    } else if (passwordController.text != confirmPasswordController.text) {
      confirmPasswordError = 'Passwords do not match';
      isValid = false;
    }

    return isValid;
  }

  Future<Map<String, dynamic>> signUp() async {
    try {
      // Create user with email and password
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      // Save user data to Firestore
      await FirebaseFirestore.instance.collection('tailors').doc(userCredential.user!.uid).set({
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'shopName': shopNameController.text.trim(),
        'category': selectedCategory,
        'city': selectedCity,
        'address': addressController.text.trim(),
        'gstNumber': gstController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'userType': 'tailor',
        'isVerified': false,
        'experience': '', // Initialize empty fields for profile
        'specialization': '',
        'description': '',
        'workingHours': '9:00 AM - 7:00 PM',
        'rating': 0.0,
        'totalOrders': 0,
        'pendingOrders': 0,
        'completedOrders': 0,
        'isShopOpen': true,
      });

      return {'success': true, 'user': userCredential.user};
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Signup failed. Please try again.';
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'An account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is not valid.';
      }
      return {'success': false, 'error': errorMessage};
    } catch (e) {
      return {'success': false, 'error': 'An unexpected error occurred. Please try again.'};
    }
  }

  Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        return {'success': false, 'error': 'Google sign in was cancelled'};
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      // Check if this is a new user
      final userDoc = await FirebaseFirestore.instance.collection('tailors').doc(userCredential.user!.uid).get();
      
      if (!userDoc.exists) {
        // New user - save their data
        await FirebaseFirestore.instance.collection('tailors').doc(userCredential.user!.uid).set({
          'name': userCredential.user!.displayName ?? nameController.text.trim(),
          'email': userCredential.user!.email!,
          'phone': phoneController.text.trim(),
          'shopName': shopNameController.text.trim().isNotEmpty ? shopNameController.text.trim() : '${userCredential.user!.displayName ?? "Tailor"}\'s Shop',
          'category': selectedCategory,
          'city': selectedCity,
          'address': addressController.text.trim(),
          'gstNumber': gstController.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
          'userType': 'tailor',
          'isVerified': false,
          'photoURL': userCredential.user!.photoURL,
          'experience': '',
          'specialization': '',
          'description': '',
          'workingHours': '9:00 AM - 7:00 PM',
          'rating': 0.0,
          'totalOrders': 0,
          'pendingOrders': 0,
          'completedOrders': 0,
          'isShopOpen': true,
        });
      }

      return {'success': true, 'user': userCredential.user};
    } on FirebaseAuthException catch (e) {
      return {'success': false, 'error': 'Google sign in failed: ${e.message}'};
    } catch (e) {
      return {'success': false, 'error': 'An unexpected error occurred during Google sign in.'};
    }
  }

  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    shopNameController.dispose();
    addressController.dispose();
    gstController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }
}

class TailorSignUpScreen extends StatefulWidget {
  const TailorSignUpScreen({super.key});

  @override
  State<TailorSignUpScreen> createState() => _TailorSignUpScreenState();
}

class _TailorSignUpScreenState extends State<TailorSignUpScreen> with TickerProviderStateMixin {
  
  final TailorSignUpController _controller = TailorSignUpController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  late AnimationController _animationController;
  late AnimationController _tailorAnimationController;
  late AnimationController _scissorsAnimationController;
  late AnimationController _needleAnimationController;
  late AnimationController _floatingController;
  
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _tailorScaleAnimation;
  late Animation<double> _scissorsRotation;
  late Animation<double> _needleAnimation;
  late Animation<double> _floatingAnimation;

  @override
  void initState() {
    super.initState();
    _initializeApp();
    
    // Main animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    // Tailor character animation
    _tailorAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _tailorScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _tailorAnimationController,
      curve: Curves.elasticOut,
    ));

    // Scissors cutting animation
    _scissorsAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _scissorsRotation = Tween<double>(
      begin: -0.1,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _scissorsAnimationController,
      curve: Curves.easeInOut,
    ));

    // Needle threading animation
    _needleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _needleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_needleAnimationController);

    // Floating animation for elements
    _floatingController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);

    _floatingAnimation = Tween<double>(
      begin: -10.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
    _tailorAnimationController.forward();
  }

  Future<void> _initializeApp() async {
    await initializeFirebase();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _tailorAnimationController.dispose();
    _scissorsAnimationController.dispose();
    _needleAnimationController.dispose();
    _floatingController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _showPicker(BuildContext context, List<String> items, String? currentValue, Function(String?) onSelected) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          height: 300,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final isSelected = item == currentValue;
                    return ListTile(
                      title: Text(
                        item,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Theme.of(context).primaryColor : Colors.black87,
                        ),
                      ),
                      trailing: isSelected ? const Icon(Icons.check, color: Colors.blue) : null,
                      onTap: () {
                        onSelected(item);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleSignUp() async {
    if (_controller.validateInputs()) {
      setState(() => _isLoading = true);
      
      final result = await _controller.signUp();
      
      setState(() => _isLoading = false);

      if (result['success'] == true) {
        _showMessage('Sign Up Successful!', true);
        // Navigate to verification screen with phone number
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => VerificationScreen(
              phoneNumber: _controller.phoneController.text.trim(),
            ),
          ),
        );
      } else {
        _showMessage(result['error'] ?? 'Sign Up Failed. Please try again.', false);
      }
    } else {
      setState(() {});
    }
  }

  void _handleGoogleSignUp() async {
    setState(() => _isLoading = true);
    final result = await _controller.signInWithGoogle();
    setState(() => _isLoading = false);
    
    if (result['success'] == true) {
      _showMessage('Google Sign Up Successful!', true);
      // Navigate to profile screen after successful signup
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TailorProfileScreen(),
        ),
      );
    } else {
      _showMessage(result['error'] ?? 'Google Sign Up Failed', false);
    }
  }

  void _showMessage(String message, bool isSuccess) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? const Color(0xFFD4145A) : Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: _buildSignUpCard(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.only(top: 20, right: 30, left: 30, bottom: 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Tailor Sign Up',
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 5, 86, 208),
                ),
              ),
              const SizedBox(width: 10),
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 2000),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Transform.rotate(
                    angle: value * 2 * math.pi,
                    child: const Icon(
                      Icons.content_cut,
                      color: Color.fromARGB(255, 5, 86, 208),
                      size: 24,
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Owner Name
          _buildTextField(
            controller: _controller.nameController,
            label: 'Owner Name',
            icon: Icons.person_outline,
            errorText: _controller.nameError,
            keyboardType: TextInputType.name,
          ),
          const SizedBox(height: 20),

          // Email
          _buildTextField(
            controller: _controller.emailController,
            label: 'Email',
            icon: Icons.email_outlined,
            errorText: _controller.emailError,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),

          // Phone Number
          _buildTextField(
            controller: _controller.phoneController,
            label: 'Phone Number',
            icon: Icons.phone_outlined,
            errorText: _controller.phoneError,
            keyboardType: TextInputType.phone,
            maxLength: 10,
          ),
          const SizedBox(height: 20),

          // Shop Name
          _buildTextField(
            controller: _controller.shopNameController,
            label: 'Shop Name',
            icon: Icons.store_outlined,
            errorText: _controller.shopNameError,
            keyboardType: TextInputType.text,
          ),
          const SizedBox(height: 20),

          // Password
          _buildPasswordField(
            controller: _controller.passwordController,
            label: 'Password',
            errorText: _controller.passwordError,
            isPassword: true,
            obscureText: !_isPasswordVisible,
            onToggleVisibility: () {
              setState(() => _isPasswordVisible = !_isPasswordVisible);
            },
          ),
          const SizedBox(height: 20),

          // Confirm Password
          _buildPasswordField(
            controller: _controller.confirmPasswordController,
            label: 'Confirm Password',
            errorText: _controller.confirmPasswordError,
            isPassword: true,
            obscureText: !_isConfirmPasswordVisible,
            onToggleVisibility: () {
              setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible);
            },
          ),
          const SizedBox(height: 20),

          // Shop Category Picker
          _buildCategoryPicker(),
          if (_controller.categoryError != null) _buildErrorText(_controller.categoryError!),
          const SizedBox(height: 20),

          // City Picker
          _buildCityPicker(),
          if (_controller.cityError != null) _buildErrorText(_controller.cityError!),
          const SizedBox(height: 20),

          // Address
          _buildTextField(
            controller: _controller.addressController,
            label: 'Shop Address',
            icon: Icons.location_on_outlined,
            errorText: _controller.addressError,
            keyboardType: TextInputType.multiline,
            maxLines: 3,
          ),
          const SizedBox(height: 20),

          // GST Number (Optional)
          _buildTextField(
            controller: _controller.gstController,
            label: 'GST Number (Optional)',
            icon: Icons.receipt_outlined,
            errorText: null,
            keyboardType: TextInputType.text,
          ),

          const SizedBox(height: 30),

          // Sign Up Button
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleSignUp,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4145A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'Sign Up',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 25),

          Row(
            children: [
              Expanded(child: Divider(color: Colors.grey[300])),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  'Or sign up with',
                  style: GoogleFonts.poppins(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ),
              Expanded(child: Divider(color: Colors.grey[300])),
            ],
          ),

          const SizedBox(height: 25),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialButton(Icons.mail, Colors.red, 'Google', _handleGoogleSignUp),
            ],
          ),

          const SizedBox(height: 25),

          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Already have an account? ",
                  style: GoogleFonts.poppins(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => ShopkeeperLoginScreen()));
                  },
                  child: Text(
                    'Login',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFFD4145A),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? errorText,
    TextInputType? keyboardType,
    int maxLines = 1,
    int? maxLength,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: errorText != null ? Colors.red : Colors.transparent,
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            maxLength: maxLength,
            style: GoogleFonts.poppins(),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.grey),
              hintText: label,
              hintStyle: GoogleFonts.poppins(color: Colors.grey),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
              counterText: '',
            ),
          ),
        ),
        if (errorText != null) _buildErrorText(errorText),
      ],
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String? errorText,
    required bool isPassword,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: errorText != null ? Colors.red : Colors.transparent,
            ),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            style: GoogleFonts.poppins(),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
              suffixIcon: IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: onToggleVisibility,
              ),
              hintText: label,
              hintStyle: GoogleFonts.poppins(color: Colors.grey),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
            ),
          ),
        ),
        if (errorText != null) _buildErrorText(errorText),
      ],
    );
  }

  Widget _buildCategoryPicker() {
    return GestureDetector(
      onTap: () => _showPicker(
        context,
        _controller.categories,
        _controller.selectedCategory,
        (value) => setState(() => _controller.selectedCategory = value),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: _controller.categoryError != null ? Colors.red : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.category_outlined, color: Colors.grey),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _controller.selectedCategory ?? 'Select Shop Category',
                style: GoogleFonts.poppins(
                  color: _controller.selectedCategory != null ? Colors.black87 : Colors.grey,
                ),
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildCityPicker() {
    return GestureDetector(
      onTap: () => _showPicker(
        context,
        _controller.cities,
        _controller.selectedCity,
        (value) => setState(() => _controller.selectedCity = value),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: _controller.cityError != null ? Colors.red : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.location_city_outlined, color: Colors.grey),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _controller.selectedCity ?? 'Select City',
                style: GoogleFonts.poppins(
                  color: _controller.selectedCity != null ? Colors.black87 : Colors.grey,
                ),
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorText(String errorText) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 5),
      child: Text(
        errorText,
        style: GoogleFonts.poppins(
          color: Colors.red,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, Color color, String provider, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 200),
        tween: Tween(begin: 1.0, end: 1.0),
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey[300]!),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Icon(icon, color: color, size: 28),
            ),
          );
        },
      ),
    );
  }
}