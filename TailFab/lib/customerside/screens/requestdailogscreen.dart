

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TailorOrderRequestDialog extends StatefulWidget {
  final String tailorId;
  final String tailorName;

  const TailorOrderRequestDialog({
    Key? key,
    required this.tailorId,
    required this.tailorName,
  }) : super(key: key);

  @override
  State<TailorOrderRequestDialog> createState() => _TailorOrderRequestDialogState();
}

class _TailorOrderRequestDialogState extends State<TailorOrderRequestDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _customerPhoneController = TextEditingController();
  final TextEditingController _deliveryDateController = TextEditingController();
  
  // Order items
  final List<OrderItemForm> _orderItems = [];
  
  // Form state
  bool _isSubmitting = false;
  DateTime? _selectedDeliveryDate;

  // Garment and fabric lists
  final List<String> _garmentTypes = [
    'Shirt',
    'Trouser',
    'Blouse',
    'Skirt',
    'Dress',
    'Jacket',
    'Coat',
    'Kurta',
    'Sherwani',
    'Lehenga',
    'Saree Blouse',
    'Waistcoat',
    'Shorts',
    'Jumpsuit',
    'Other'
  ];

  final List<String> _fabricTypes = [
    'Cotton',
    'Linen',
    'Silk',
    'Wool',
    'Polyester',
    'Rayon',
    'Denim',
    'Chiffon',
    'Georgette',
    'Crepe',
    'Velvet',
    'Satin',
    'Organza',
    'Jersey',
    'Twill',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    // Add one initial order item
    _addOrderItem();
    
    // Pre-fill customer name if available
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.displayName != null) {
      _customerNameController.text = user.displayName!;
    }
  }

  void _addOrderItem() {
    setState(() {
      _orderItems.add(OrderItemForm());
    });
  }

  void _removeOrderItem(int index) {
    if (_orderItems.length > 1) {
      setState(() {
        _orderItems.removeAt(index);
      });
    }
  }

  Future<void> _selectDeliveryDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (picked != null) {
      setState(() {
        _selectedDeliveryDate = picked;
        _deliveryDateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  double _calculateTotalAmount() {
    double total = 0;
    for (var item in _orderItems) {
      if (item.priceController.text.isNotEmpty && item.quantityController.text.isNotEmpty) {
        total += double.parse(item.priceController.text) * int.parse(item.quantityController.text);
      }
    }
    return total;
  }

  Future<void> _submitOrder() async {
    if (!_formKey.currentState!.validate()) {
      _showSnackBar('Please fill all required fields correctly', Colors.orange);
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      log("$user");
      if (user != null) {
        await _saveOrderToFirestore(user);
        Navigator.pop(context);
        _showSnackBar('Order request sent to ${widget.tailorName}!', Colors.green);
      }
    } catch (e) {
      print('Error submitting order: $e');
      _showSnackBar('Failed to submit order. Please try again.', Colors.red);
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  Future<void> _saveOrderToFirestore(User user) async {
    log("in save order to firestore");
    final orderItems = _orderItems.map((item) {
      final measurements = <String, String>{};
      for (var entry in item.measurementControllers.entries) {
        if (entry.value.text.isNotEmpty) {
          measurements[entry.key] = entry.value.text;
        }
      }

      return {
        'garmentType': item.selectedGarment,
        'fabric': item.selectedFabric,
        'color': item.colorController.text,
        'quantity': int.parse(item.quantityController.text),
        'price': double.parse(item.priceController.text),
        'measurements': measurements,
        'specialInstructions': item.specialInstructionsController.text,
      };
    }).toList();

    await FirebaseFirestore.instance.collection('tailor_orders').add({
      'customerId': user.uid,
      'customerName': _customerNameController.text,
      'customerPhone': _customerPhoneController.text,
      'customerEmail': user.email,
      'tailorId': widget.tailorId,
      'tailorName': widget.tailorName,
      'items': orderItems,
      'totalAmount': _calculateTotalAmount(),
      'deliveryDate': _selectedDeliveryDate,
      'orderDate': DateTime.now(),
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    log("data added to firebase tailor_orders succesfully");
  }

  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.poppins()),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'New Order Request',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                        ),
                        Text(
                          'To: ${widget.tailorName}',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.grey[600]),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Divider(color: Colors.grey[300]),
              
              // Form Content
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Customer Information
                        _buildSectionHeader('Customer Information'),
                        _buildTextFormField(
                          controller: _customerNameController,
                          label: 'Full Name *',
                          validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
                        ),
                        const SizedBox(height: 12),
                        _buildTextFormField(
                          controller: _customerPhoneController,
                          label: 'Phone Number *',
                          keyboardType: TextInputType.phone,
                          validator: (value) => value!.isEmpty ? 'Please enter your phone number' : null,
                        ),
                        const SizedBox(height: 12),
                        _buildDateField(),

                        const SizedBox(height: 24),
                        
                        // Order Items
                        _buildSectionHeader('Order Items'),
                        ..._orderItems.asMap().entries.map((entry) {
                          final index = entry.key;
                          final item = entry.value;
                          return _buildOrderItemForm(item, index);
                        }).toList(),

                        // Add Item Button
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(top: 12),
                          child: OutlinedButton.icon(
                            onPressed: _addOrderItem,
                            icon: Icon(Icons.add, size: 18),
                            label: Text('Add Another Item'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.blue[800],
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: BorderSide(color: Colors.blue[800]!),
                            ),
                          ),
                        ),

                        // Total Amount
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.green[200]!),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Amount:',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[800],
                                ),
                              ),
                              Text(
                                '\$${_calculateTotalAmount().toStringAsFixed(2)}',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: _isSubmitting ? null : () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey[600],
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey[300]!),
                        ),
                      ),
                      child: Text('Cancel', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitOrder,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8075FF),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.send, size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  'Send Request',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
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

  Widget _buildSectionHeader(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.blue[800],
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF8075FF)),
        ),
      ),
    );
  }

  Widget _buildDropdownFormField({
    required String value,
    required List<String> items,
    required String label,
    required Function(String?) onChanged,
    required String? Function(String?) validator,
  }) {
    return DropdownButtonFormField<String>(
      value: value.isEmpty ? null : value,
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF8075FF)),
        ),
      ),
      icon: Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
    );
  }

  Widget _buildDateField() {
    return TextFormField(
      controller: _deliveryDateController,
      readOnly: true,
      onTap: _selectDeliveryDate,
      validator: (value) => value!.isEmpty ? 'Please select delivery date' : null,
      decoration: InputDecoration(
        labelText: 'Expected Delivery Date *',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF8075FF)),
        ),
        suffixIcon: Icon(Icons.calendar_today, color: Colors.grey[600]),
      ),
    );
  }

  Widget _buildOrderItemForm(OrderItemForm item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Item ${index + 1}',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
              if (_orderItems.length > 1)
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red, size: 20),
                  onPressed: () => _removeOrderItem(index),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildDropdownFormField(
                  value: item.selectedGarment,
                  items: _garmentTypes,
                  label: 'Garment Type *',
                  onChanged: (value) {
                    setState(() {
                      item.selectedGarment = value ?? '';
                    });
                  },
                  validator: (value) => value == null || value.isEmpty ? 'Please select garment type' : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDropdownFormField(
                  value: item.selectedFabric,
                  items: _fabricTypes,
                  label: 'Fabric *',
                  onChanged: (value) {
                    setState(() {
                      item.selectedFabric = value ?? '';
                    });
                  },
                  validator: (value) => value == null || value.isEmpty ? 'Please select fabric' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTextFormField(
                  controller: item.colorController,
                  label: 'Color *',
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextFormField(
                  controller: item.quantityController,
                  label: 'Quantity *',
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextFormField(
                  controller: item.priceController,
                  label: 'Price (\$) *',
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildMeasurementSection(item),
          const SizedBox(height: 12),
          _buildTextFormField(
            controller: item.specialInstructionsController,
            label: 'Special Instructions',
          ),
        ],
      ),
    );
  }

  Widget _buildMeasurementSection(OrderItemForm item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Measurements (in cm):',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: item.measurementControllers.entries.map((entry) {
            return SizedBox(
              width: 120,
              child: TextFormField(
                controller: entry.value,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: entry.key,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    _deliveryDateController.dispose();
    for (var item in _orderItems) {
      item.dispose();
    }
    super.dispose();
  }
}

class OrderItemForm {
  String selectedGarment = '';
  String selectedFabric = '';
  final TextEditingController colorController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController specialInstructionsController = TextEditingController();
  
  final Map<String, TextEditingController> measurementControllers = {
    'Chest': TextEditingController(),
    'Waist': TextEditingController(),
    'Hips': TextEditingController(),
    'Shoulder': TextEditingController(),
    'Arm Length': TextEditingController(),
    'Inseam': TextEditingController(),
    'Neck': TextEditingController(),
  };

  void dispose() {
    colorController.dispose();
    quantityController.dispose();
    priceController.dispose();
    specialInstructionsController.dispose();
    for (var controller in measurementControllers.values) {
      controller.dispose();
    }
  }
}


// import 'dart:developer';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';

// class TailorOrderRequestDialog extends StatefulWidget {
//   final String tailorId;
//   final String tailorName;

//   const TailorOrderRequestDialog({
//     Key? key,
//     required this.tailorId,
//     required this.tailorName,
//   }) : super(key: key);

//   @override
//   State<TailorOrderRequestDialog> createState() => _TailorOrderRequestDialogState();
// }

// class _TailorOrderRequestDialogState extends State<TailorOrderRequestDialog> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _customerNameController = TextEditingController();
//   final TextEditingController _customerPhoneController = TextEditingController();
//   final TextEditingController _deliveryDateController = TextEditingController();
  
//   // Order items
//   final List<OrderItemForm> _orderItems = [];
  
//   // Form state
//   bool _isSubmitting = false;
//   bool _isLoading = true;
//   DateTime? _selectedDeliveryDate;

//   // Firebase references
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   // Item types
//   final List<String> _itemTypes = [
//     'New Garment',
//     'Alteration',
//     'Custom Design',
//     'Repair',
//     'Design Consultation',
//     'Other'
//   ];

//   // Garment and fabric lists (will be fetched from Firebase)
//   List<String> _garmentTypes = [];
//   List<String> _fabricTypes = [];
//   List<String> _measurementTypes = [];

//   // Tailor profile data
//   Map<String, dynamic>? _tailorProfile;

//   @override
//   void initState() {
//     super.initState();
//     _initializeData();
//   }

//   Future<void> _initializeData() async {
//     try {
//       await Future.wait([
//         _loadTailorProfile(),
//         _loadGarmentTypes(),
//         _loadFabricTypes(),
//         _loadMeasurementTypes(),
//         _loadCustomerData(),
//       ]);
      
//       // Add one initial order item after data is loaded
//       _addOrderItem();
      
//       setState(() {
//         _isLoading = false;
//       });
//     } catch (e) {
//       log('Error initializing data: $e');
//       _showSnackBar('Failed to load data: ${e.toString()}', Colors.red);
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> _loadTailorProfile() async {
//     try {
//       final doc = await _firestore.collection('tailors').doc(widget.tailorId).get();
//       if (doc.exists) {
//         setState(() {
//           _tailorProfile = doc.data()!;
//         });
//       }
//     } catch (e) {
//       log('Error loading tailor profile: $e');
//     }
//   }

//   Future<void> _loadGarmentTypes() async {
//     try {
//       final snapshot = await _firestore.collection('app_data').doc('garment_types').get();
//       if (snapshot.exists && snapshot.data() != null) {
//         setState(() {
//           _garmentTypes = List<String>.from(snapshot.data()!['types'] ?? []);
//         });
//       } else {
//         // Fallback to default types
//         _garmentTypes = [
//           'Shirt', 'Trouser', 'Blouse', 'Skirt', 'Dress', 'Jacket', 'Coat',
//           'Kurta', 'Sherwani', 'Lehenga', 'Saree Blouse', 'Waistcoat', 'Shorts', 'Jumpsuit', 'Other'
//         ];
//       }
//     } catch (e) {
//       log('Error loading garment types: $e');
//       _garmentTypes = ['Shirt', 'Trouser', 'Blouse', 'Skirt', 'Dress', 'Other'];
//     }
//   }

//   Future<void> _loadFabricTypes() async {
//     try {
//       final snapshot = await _firestore.collection('app_data').doc('fabric_types').get();
//       if (snapshot.exists && snapshot.data() != null) {
//         setState(() {
//           _fabricTypes = List<String>.from(snapshot.data()!['types'] ?? []);
//         });
//       } else {
//         // Fallback to default types
//         _fabricTypes = [
//           'Cotton', 'Linen', 'Silk', 'Wool', 'Polyester', 'Rayon', 'Denim',
//           'Chiffon', 'Georgette', 'Crepe', 'Velvet', 'Satin', 'Organza', 'Jersey', 'Twill', 'Other'
//         ];
//       }
//     } catch (e) {
//       log('Error loading fabric types: $e');
//       _fabricTypes = ['Cotton', 'Silk', 'Polyester', 'Wool', 'Other'];
//     }
//   }

//   Future<void> _loadMeasurementTypes() async {
//     try {
//       final snapshot = await _firestore.collection('app_data').doc('measurement_types').get();
//       if (snapshot.exists && snapshot.data() != null) {
//         setState(() {
//           _measurementTypes = List<String>.from(snapshot.data()!['types'] ?? []);
//         });
//       } else {
//         // Fallback to default types
//         _measurementTypes = [
//           'Chest', 'Waist', 'Hips', 'Shoulder', 'Arm Length', 'Inseam', 'Neck',
//           'Bust', 'Back Length', 'Front Length', 'Thigh', 'Knee'
//         ];
//       }
//     } catch (e) {
//       log('Error loading measurement types: $e');
//       _measurementTypes = ['Chest', 'Waist', 'Hips', 'Shoulder', 'Arm Length'];
//     }
//   }

//   Future<void> _loadCustomerData() async {
//     try {
//       final user = _auth.currentUser;
//       if (user != null) {
//         // Load customer profile
//         final customerDoc = await _firestore.collection('customers').doc(user.uid).get();
        
//         if (customerDoc.exists) {
//           final customerData = customerDoc.data()!;
//           _customerNameController.text = customerData['name'] ?? user.displayName ?? '';
//           _customerPhoneController.text = customerData['phone'] ?? '';
//         } else {
//           // Fallback to user profile
//           _customerNameController.text = user.displayName ?? '';
          
//           // Create customer profile if it doesn't exist
//           await _createCustomerProfile(user);
//         }
//       }
//     } catch (e) {
//       log('Error loading customer data: $e');
//       final user = _auth.currentUser;
//       if (user != null && user.displayName != null) {
//         _customerNameController.text = user.displayName!;
//       }
//     }
//   }

//   Future<void> _createCustomerProfile(User user) async {
//     try {
//       await _firestore.collection('customers').doc(user.uid).set({
//         'name': user.displayName ?? '',
//         'email': user.email ?? '',
//         'phone': '',
//         'createdAt': FieldValue.serverTimestamp(),
//         'updatedAt': FieldValue.serverTimestamp(),
//       });
//     } catch (e) {
//       log('Error creating customer profile: $e');
//     }
//   }

//   void _addOrderItem() {
//     setState(() {
//       _orderItems.add(OrderItemForm(measurementTypes: _measurementTypes));
//     });
//   }

//   void _removeOrderItem(int index) {
//     if (_orderItems.length > 1) {
//       setState(() {
//         _orderItems.removeAt(index);
//       });
//     }
//   }

//   Future<void> _selectDeliveryDate() async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now().add(const Duration(days: 7)),
//       firstDate: DateTime.now(),
//       lastDate: DateTime.now().add(const Duration(days: 365)),
//     );
    
//     if (picked != null) {
//       setState(() {
//         _selectedDeliveryDate = picked;
//         _deliveryDateController.text = DateFormat('dd/MM/yyyy').format(picked);
//       });
//     }
//   }

//   double _calculateTotalAmount() {
//     double total = 0;
//     for (var item in _orderItems) {
//       if (item.priceController.text.isNotEmpty && item.quantityController.text.isNotEmpty) {
//         total += (double.tryParse(item.priceController.text) ?? 0.0) * 
//                 (int.tryParse(item.quantityController.text) ?? 1);
//       }
//     }
//     return total;
//   }

//   bool _validateOrderData() {
//     if (_customerNameController.text.isEmpty) return false;
//     if (_customerPhoneController.text.isEmpty) return false;
//     if (_selectedDeliveryDate == null) return false;
    
//     for (var item in _orderItems) {
//       if (item.selectedItemType.isEmpty) return false;
//       if (item.quantityController.text.isEmpty) return false;
//       if (item.priceController.text.isEmpty) return false;
      
//       // Additional validation based on item type
//       if (item.selectedItemType == 'New Garment') {
//         if (item.selectedGarment.isEmpty || item.selectedFabric.isEmpty) return false;
//       }
//     }
    
//     return true;
//   }

//   Future<void> _submitOrder() async {
//     if (!_formKey.currentState!.validate()) {
//       _showSnackBar('Please fill all required fields correctly', Colors.orange);
//       return;
//     }

//     if (!_validateOrderData()) {
//       _showSnackBar('Please complete all required fields', Colors.orange);
//       return;
//     }

//     setState(() => _isSubmitting = true);

//     try {
//       final user = _auth.currentUser;
//       if (user != null) {
//         await _saveOrderToFirestore(user);
//         if (mounted) {
//           Navigator.pop(context, true); // Return success
//           _showSnackBar('Order request sent to ${widget.tailorName}!', Colors.green);
//         }
//       } else {
//         _showSnackBar('Please sign in to place an order', Colors.red);
//       }
//     } catch (e) {
//       log('Error submitting order: $e');
//       if (mounted) {
//         _showSnackBar('Failed to submit order: ${e.toString()}', Colors.red);
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _isSubmitting = false);
//       }
//     }
//   }

//   Future<void> _saveOrderToFirestore(User user) async {
//     log("Saving order to Firestore");
    
//     // Convert delivery date to Timestamp
//     final deliveryTimestamp = _selectedDeliveryDate != null 
//         ? Timestamp.fromDate(_selectedDeliveryDate!)
//         : null;

//     final orderItems = _orderItems.map((item) {
//       final measurements = <String, String>{};
//       for (var entry in item.measurementControllers.entries) {
//         if (entry.value.text.isNotEmpty) {
//           measurements[entry.key] = entry.value.text;
//         }
//       }

//       return {
//         'itemType': item.selectedItemType,
//         'garmentType': item.selectedGarment,
//         'fabric': item.selectedFabric,
//         'color': item.colorController.text.trim(),
//         'quantity': int.tryParse(item.quantityController.text) ?? 1,
//         'price': double.tryParse(item.priceController.text) ?? 0.0,
//         'measurements': measurements,
//         'specialInstructions': item.specialInstructionsController.text.trim(),
//         'itemDescription': item.itemDescriptionController.text.trim(),
//         'urgencyLevel': item.selectedUrgency,
//         'hasExistingGarment': item.hasExistingGarment,
//         'existingGarmentCondition': item.existingGarmentConditionController.text.trim(),
//         'createdAt': FieldValue.serverTimestamp(),
//       };
//     }).toList();

//     final orderData = {
//       'customerId': user.uid,
//       'customerName': _customerNameController.text.trim(),
//       'customerPhone': _customerPhoneController.text.trim(),
//       'customerEmail': user.email,
//       'tailorId': widget.tailorId,
//       'tailorName': widget.tailorName,
//       'items': orderItems,
//       'totalAmount': _calculateTotalAmount(),
//       'deliveryDate': deliveryTimestamp,
//       'orderDate': Timestamp.now(),
//       'status': 'pending',
//       'orderType': _getOrderType(),
//       'urgencyLevel': _getOverallUrgencyLevel(),
//       'createdAt': FieldValue.serverTimestamp(),
//       'updatedAt': FieldValue.serverTimestamp(),
//     };

//     try {
//       log("Order Data to save: ${orderData.toString()}");

//       // Use transaction for data consistency
//       await _firestore.runTransaction((transaction) async {
//         final tailorOrderRef = _firestore.collection('tailor_orders').doc();
//         final userOrderRef = _firestore
//             .collection('users')
//             .doc(user.uid)
//             .collection('my_orders')
//             .doc();

//         transaction.set(tailorOrderRef, orderData);
//         transaction.set(userOrderRef, orderData);
        
//         // Update customer profile with latest phone number
//         transaction.update(
//           _firestore.collection('customers').doc(user.uid),
//           {
//             'phone': _customerPhoneController.text.trim(),
//             'updatedAt': FieldValue.serverTimestamp(),
//           }
//         );
        
//         log("Data added to Firebase successfully. Order IDs: ${tailorOrderRef.id}, ${userOrderRef.id}");
//       });

//       // Send notification to tailor
//       await _sendNotificationToTailor(user);
      
//     } catch (e) {
//       log("Error saving to Firestore: $e");
//       rethrow;
//     }
//   }

//   Future<void> _sendNotificationToTailor(User user) async {
//     try {
//       await _firestore.collection('notifications').add({
//         'userId': widget.tailorId,
//         'title': 'New Order Request',
//         'message': '${_customerNameController.text.trim()} sent you a new order request',
//         'type': 'new_order',
//         'orderData': {
//           'customerName': _customerNameController.text.trim(),
//           'totalAmount': _calculateTotalAmount(),
//           'itemCount': _orderItems.length,
//         },
//         'read': false,
//         'createdAt': FieldValue.serverTimestamp(),
//       });
//     } catch (e) {
//       log('Error sending notification: $e');
//       // Don't throw error here as order is already created
//     }
//   }

//   String _getOrderType() {
//     final itemTypes = _orderItems.map((item) => item.selectedItemType).toSet();
//     if (itemTypes.length == 1) return itemTypes.first;
//     return 'Mixed';
//   }

//   String _getOverallUrgencyLevel() {
//     final urgencyLevels = _orderItems.map((item) => item.selectedUrgency).toSet();
//     if (urgencyLevels.contains('High')) return 'High';
//     if (urgencyLevels.contains('Medium')) return 'Medium';
//     return 'Low';
//   }

//   void _showSnackBar(String message, Color backgroundColor) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message, style: GoogleFonts.poppins()),
//         backgroundColor: backgroundColor,
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       backgroundColor: Colors.white,
//       insetPadding: const EdgeInsets.all(20),
//       child: Container(
//         constraints: const BoxConstraints(maxHeight: 700),
//         child: Padding(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'New Order Request',
//                           style: GoogleFonts.poppins(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.blue[800],
//                           ),
//                         ),
//                         Text(
//                           'To: ${widget.tailorName}',
//                           style: GoogleFonts.poppins(
//                             fontSize: 14,
//                             color: Colors.grey[600],
//                           ),
//                         ),
//                         if (_tailorProfile != null) ...[
//                           const SizedBox(height: 4),
//                           Text(
//                             'Specializes in: ${_tailorProfile!['specialization'] ?? 'Various garments'}',
//                             style: GoogleFonts.poppins(
//                               fontSize: 12,
//                               color: Colors.green[600],
//                             ),
//                           ),
//                         ]
//                       ],
//                     ),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.close, color: Colors.grey[600]),
//                     onPressed: () => Navigator.pop(context),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               Divider(color: Colors.grey[300]),
              
//               // Form Content
//               Expanded(
//                 child: _isLoading
//                     ? const Center(child: CircularProgressIndicator())
//                     : SingleChildScrollView(
//                         child: Form(
//                           key: _formKey,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               // Customer Information
//                               _buildSectionHeader('Customer Information'),
//                               _buildTextFormField(
//                                 controller: _customerNameController,
//                                 label: 'Full Name *',
//                                 validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
//                               ),
//                               const SizedBox(height: 12),
//                               _buildTextFormField(
//                                 controller: _customerPhoneController,
//                                 label: 'Phone Number *',
//                                 keyboardType: TextInputType.phone,
//                                 validator: (value) => value!.isEmpty ? 'Please enter your phone number' : null,
//                               ),
//                               const SizedBox(height: 12),
//                               _buildDateField(),

//                               const SizedBox(height: 24),
                              
//                               // Order Items
//                               _buildSectionHeader('Order Items'),
//                               ..._orderItems.asMap().entries.map((entry) {
//                                 final index = entry.key;
//                                 final item = entry.value;
//                                 return _buildOrderItemForm(item, index);
//                               }).toList(),

//                               // Add Item Button
//                               Container(
//                                 width: double.infinity,
//                                 margin: const EdgeInsets.only(top: 12),
//                                 child: OutlinedButton.icon(
//                                   onPressed: _addOrderItem,
//                                   icon: const Icon(Icons.add, size: 18),
//                                   label: const Text('Add Another Item'),
//                                   style: OutlinedButton.styleFrom(
//                                     foregroundColor: Colors.blue[800],
//                                     padding: const EdgeInsets.symmetric(vertical: 12),
//                                     side: BorderSide(color: Colors.blue[800]!),
//                                   ),
//                                 ),
//                               ),

//                               // Total Amount
//                               Container(
//                                 margin: const EdgeInsets.only(top: 20),
//                                 padding: const EdgeInsets.all(16),
//                                 decoration: BoxDecoration(
//                                   color: Colors.green[50],
//                                   borderRadius: BorderRadius.circular(12),
//                                   border: Border.all(color: Colors.green[200]!),
//                                 ),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       'Total Amount:',
//                                       style: GoogleFonts.poppins(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.green[800],
//                                       ),
//                                     ),
//                                     Text(
//                                       '\$${_calculateTotalAmount().toStringAsFixed(2)}',
//                                       style: GoogleFonts.poppins(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.green[800],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//               ),

//               const SizedBox(height: 20),
              
//               // Action Buttons
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextButton(
//                       onPressed: _isSubmitting ? null : () => Navigator.pop(context),
//                       style: TextButton.styleFrom(
//                         foregroundColor: Colors.grey[600],
//                         padding: const EdgeInsets.symmetric(vertical: 15),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           side: BorderSide(color: Colors.grey[300]!),
//                         ),
//                       ),
//                       child: Text('Cancel', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: _isSubmitting ? null : _submitOrder,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF8075FF),
//                         padding: const EdgeInsets.symmetric(vertical: 15),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: _isSubmitting
//                           ? const SizedBox(
//                               height: 20,
//                               width: 20,
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2,
//                                 color: Colors.white,
//                               ),
//                             )
//                           : Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 const Icon(Icons.send, size: 18),
//                                 const SizedBox(width: 8),
//                                 Text(
//                                   'Send Request',
//                                   style: GoogleFonts.poppins(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionHeader(String title) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       child: Text(
//         title,
//         style: GoogleFonts.poppins(
//           fontSize: 16,
//           fontWeight: FontWeight.bold,
//           color: Colors.blue[800],
//         ),
//       ),
//     );
//   }

//   Widget _buildTextFormField({
//     required TextEditingController controller,
//     required String label,
//     TextInputType? keyboardType,
//     String? Function(String?)? validator,
//     int? maxLines,
//   }) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: keyboardType,
//       validator: validator,
//       maxLines: maxLines,
//       decoration: InputDecoration(
//         labelText: label,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.grey.shade300),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Color(0xFF8075FF)),
//         ),
//       ),
//     );
//   }

//   Widget _buildDropdownFormField({
//     required String value,
//     required List<String> items,
//     required String label,
//     required Function(String?) onChanged,
//     required String? Function(String?) validator,
//   }) {
//     return DropdownButtonFormField<String>(
//       value: value.isEmpty ? null : value,
//       items: items.map((String item) {
//         return DropdownMenuItem<String>(
//           value: item,
//           child: Text(item),
//         );
//       }).toList(),
//       onChanged: onChanged,
//       validator: validator,
//       decoration: InputDecoration(
//         labelText: label,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.grey.shade300),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Color(0xFF8075FF)),
//         ),
//       ),
//       icon: Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
//     );
//   }

//   Widget _buildDateField() {
//     return TextFormField(
//       controller: _deliveryDateController,
//       readOnly: true,
//       onTap: _selectDeliveryDate,
//       validator: (value) => value!.isEmpty ? 'Please select delivery date' : null,
//       decoration: InputDecoration(
//         labelText: 'Expected Delivery Date *',
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.grey.shade300),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Color(0xFF8075FF)),
//         ),
//         suffixIcon: Icon(Icons.calendar_today, color: Colors.grey[600]),
//       ),
//     );
//   }

//   Widget _buildOrderItemForm(OrderItemForm item, int index) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 20),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.grey[50],
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey[200]!),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Item ${index + 1}',
//                 style: GoogleFonts.poppins(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.blue[800],
//                 ),
//               ),
//               if (_orderItems.length > 1)
//                 IconButton(
//                   icon: const Icon(Icons.delete, color: Colors.red, size: 20),
//                   onPressed: () => _removeOrderItem(index),
//                 ),
//             ],
//           ),
//           const SizedBox(height: 12),
          
//           // Item Type Selection
//           _buildDropdownFormField(
//             value: item.selectedItemType,
//             items: _itemTypes,
//             label: 'Service Type *',
//             onChanged: (value) {
//               setState(() {
//                 item.selectedItemType = value ?? 'New Garment';
//                 // Reset fields when item type changes
//                 if (value != 'New Garment') {
//                   item.selectedGarment = '';
//                   item.selectedFabric = '';
//                 }
//               });
//             },
//             validator: (value) => value == null || value.isEmpty ? 'Please select service type' : null,
//           ),
          
//           const SizedBox(height: 12),
          
//           // Conditional fields based on item type
//           if (item.selectedItemType == 'New Garment')
//             _buildNewGarmentFields(item)
//           else if (item.selectedItemType == 'Alteration' || item.selectedItemType == 'Repair')
//             _buildAlterationRepairFields(item)
//           else if (item.selectedItemType == 'Custom Design')
//             _buildCustomDesignFields(item)
//           else
//             _buildOtherServiceFields(item),
          
//           const SizedBox(height: 12),
          
//           // Common fields for all item types
//           Row(
//             children: [
//               Expanded(
//                 child: _buildTextFormField(
//                   controller: item.quantityController,
//                   label: 'Quantity *',
//                   keyboardType: TextInputType.number,
//                   validator: (value) {
//                     if (value!.isEmpty) return 'Required';
//                     if (int.tryParse(value) == null) return 'Enter valid number';
//                     if (int.parse(value) <= 0) return 'Must be greater than 0';
//                     return null;
//                   },
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: _buildTextFormField(
//                   controller: item.priceController,
//                   label: 'Price (\$) *',
//                   keyboardType: TextInputType.number,
//                   validator: (value) {
//                     if (value!.isEmpty) return 'Required';
//                     if (double.tryParse(value) == null) return 'Enter valid number';
//                     if (double.parse(value) <= 0) return 'Must be greater than 0';
//                     return null;
//                   },
//                 ),
//               ),
//             ],
//           ),
          
//           const SizedBox(height: 12),
          
//           // Urgency Level
//           _buildDropdownFormField(
//             value: item.selectedUrgency,
//             items: ['Low', 'Medium', 'High'],
//             label: 'Urgency Level *',
//             onChanged: (value) {
//               setState(() {
//                 item.selectedUrgency = value ?? 'Medium';
//               });
//             },
//             validator: (value) => value == null || value.isEmpty ? 'Please select urgency level' : null,
//           ),
          
//           const SizedBox(height: 12),
//           _buildTextFormField(
//             controller: item.specialInstructionsController,
//             label: 'Special Instructions',
//             maxLines: 2,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNewGarmentFields(OrderItemForm item) {
//     return Column(
//       children: [
//         Row(
//           children: [
//             Expanded(
//               child: _buildDropdownFormField(
//                 value: item.selectedGarment,
//                 items: _garmentTypes,
//                 label: 'Garment Type *',
//                 onChanged: (value) {
//                   setState(() {
//                     item.selectedGarment = value ?? '';
//                   });
//                 },
//                 validator: (value) => value == null || value.isEmpty ? 'Please select garment type' : null,
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: _buildDropdownFormField(
//                 value: item.selectedFabric,
//                 items: _fabricTypes,
//                 label: 'Fabric *',
//                 onChanged: (value) {
//                   setState(() {
//                     item.selectedFabric = value ?? '';
//                   });
//                 },
//                 validator: (value) => value == null || value.isEmpty ? 'Please select fabric' : null,
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 12),
//         _buildTextFormField(
//           controller: item.colorController,
//           label: 'Color *',
//           validator: (value) => value!.isEmpty ? 'Required' : null,
//         ),
//         const SizedBox(height: 12),
//         _buildMeasurementSection(item),
//       ],
//     );
//   }

//   Widget _buildAlterationRepairFields(OrderItemForm item) {
//     return Column(
//       children: [
//         _buildTextFormField(
//           controller: item.itemDescriptionController,
//           label: 'Describe what needs to be ${item.selectedItemType == 'Alteration' ? 'altered' : 'repaired'} *',
//           maxLines: 2,
//           validator: (value) => value!.isEmpty ? 'Please describe the work needed' : null,
//         ),
//         const SizedBox(height: 12),
//         Row(
//           children: [
//             Expanded(
//               child: _buildTextFormField(
//                 controller: item.colorController,
//                 label: 'Garment Color',
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: _buildDropdownFormField(
//                 value: item.selectedGarment,
//                 items: _garmentTypes,
//                 label: 'Garment Type',
//                 onChanged: (value) {
//                   setState(() {
//                     item.selectedGarment = value ?? '';
//                   });
//                 },
//                 validator: (value) => null, // Optional for alterations/repairs
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 12),
//         Row(
//           children: [
//             Expanded(
//               child: SwitchListTile(
//                 title: Text('Bringing existing garment', style: GoogleFonts.poppins(fontSize: 14)),
//                 value: item.hasExistingGarment,
//                 onChanged: (value) {
//                   setState(() {
//                     item.hasExistingGarment = value;
//                   });
//                 },
//               ),
//             ),
//           ],
//         ),
//         if (item.hasExistingGarment) ...[
//           const SizedBox(height: 8),
//           _buildTextFormField(
//             controller: item.existingGarmentConditionController,
//             label: 'Current condition of garment',
//             maxLines: 2,
//           ),
//         ],
//       ],
//     );
//   }

//   Widget _buildCustomDesignFields(OrderItemForm item) {
//     return Column(
//       children: [
//         _buildTextFormField(
//           controller: item.itemDescriptionController,
//           label: 'Design Description & Requirements *',
//           maxLines: 3,
//           validator: (value) => value!.isEmpty ? 'Please describe your design' : null,
//         ),
//         const SizedBox(height: 12),
//         Row(
//           children: [
//             Expanded(
//               child: _buildDropdownFormField(
//                 value: item.selectedGarment,
//                 items: _garmentTypes,
//                 label: 'Garment Type *',
//                 onChanged: (value) {
//                   setState(() {
//                     item.selectedGarment = value ?? '';
//                   });
//                 },
//                 validator: (value) => value == null || value.isEmpty ? 'Please select garment type' : null,
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: _buildDropdownFormField(
//                 value: item.selectedFabric,
//                 items: _fabricTypes,
//                 label: 'Preferred Fabric',
//                 onChanged: (value) {
//                   setState(() {
//                     item.selectedFabric = value ?? '';
//                   });
//                 },
//                 validator: (value) => null,
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 12),
//         _buildTextFormField(
//           controller: item.colorController,
//           label: 'Preferred Colors',
//         ),
//         const SizedBox(height: 12),
//         _buildMeasurementSection(item),
//       ],
//     );
//   }

//   Widget _buildOtherServiceFields(OrderItemForm item) {
//     return Column(
//       children: [
//         _buildTextFormField(
//           controller: item.itemDescriptionController,
//           label: 'Service Description *',
//           maxLines: 3,
//           validator: (value) => value!.isEmpty ? 'Please describe the service needed' : null,
//         ),
//         const SizedBox(height: 12),
//         Row(
//           children: [
//             Expanded(
//               child: _buildTextFormField(
//                 controller: item.colorController,
//                 label: 'Color Preferences',
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: _buildDropdownFormField(
//                 value: item.selectedGarment,
//                 items: _garmentTypes,
//                 label: 'Related Garment',
//                 onChanged: (value) {
//                   setState(() {
//                     item.selectedGarment = value ?? '';
//                   });
//                 },
//                 validator: (value) => null,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildMeasurementSection(OrderItemForm item) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Measurements (in cm):',
//           style: GoogleFonts.poppins(
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//             color: Colors.grey[700],
//           ),
//         ),
//         const SizedBox(height: 8),
//         Wrap(
//           spacing: 12,
//           runSpacing: 12,
//           children: item.measurementControllers.entries.map((entry) {
//             return SizedBox(
//               width: 120,
//               child: TextFormField(
//                 controller: entry.value,
//                 keyboardType: TextInputType.number,
//                 decoration: InputDecoration(
//                   labelText: entry.key,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                     borderSide: BorderSide(color: Colors.grey.shade300),
//                   ),
//                   contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                 ),
//               ),
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }

//   @override
//   void dispose() {
//     _customerNameController.dispose();
//     _customerPhoneController.dispose();
//     _deliveryDateController.dispose();
//     for (var item in _orderItems) {
//       item.dispose();
//     }
//     super.dispose();
//   }
// }

// class OrderItemForm {
//   String selectedItemType = 'New Garment';
//   String selectedGarment = '';
//   String selectedFabric = '';
//   String selectedUrgency = 'Medium';
//   bool hasExistingGarment = false;
  
//   final TextEditingController colorController = TextEditingController();
//   final TextEditingController quantityController = TextEditingController();
//   final TextEditingController priceController = TextEditingController();
//   final TextEditingController specialInstructionsController = TextEditingController();
//   final TextEditingController itemDescriptionController = TextEditingController();
//   final TextEditingController existingGarmentConditionController = TextEditingController();
  
//   final Map<String, TextEditingController> measurementControllers;

//   OrderItemForm({required List<String> measurementTypes}) 
//       : measurementControllers = {
//           for (var type in measurementTypes) type: TextEditingController()
//         };

//   void dispose() {
//     colorController.dispose();
//     quantityController.dispose();
//     priceController.dispose();
//     specialInstructionsController.dispose();
//     itemDescriptionController.dispose();
//     existingGarmentConditionController.dispose();
//     for (var controller in measurementControllers.values) {
//       controller.dispose();
//     }
//   }
// }