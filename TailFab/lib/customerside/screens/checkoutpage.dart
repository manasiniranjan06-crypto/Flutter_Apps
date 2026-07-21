import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckoutPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double subtotal;
  final double discount;
  final double deliveryFee;
  final double tax;
  final double total;

  const CheckoutPage({
    Key? key,
    required this.cartItems,
    required this.subtotal,
    required this.discount,
    required this.deliveryFee,
    required this.tax,
    required this.total, required Null Function() onOrderSuccess,
  }) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int currentStep = 0;
  
  // Delivery Information
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  
  // Selected options
  String selectedAddressType = 'Home';
  String selectedPaymentMethod = 'COD';
  bool saveAddress = true;
  
  // Saved addresses
  List<Map<String, dynamic>> savedAddresses = [
    {
      'type': 'Home',
      'name': 'John Doe',
      'phone': '+91 9876543210',
      'address': '123, MG Road, Near City Mall',
      'city': 'Mumbai',
      'state': 'Maharashtra',
      'pincode': '400001',
    },
    {
      'type': 'Work',
      'name': 'John Doe',
      'phone': '+91 9876543210',
      'address': '456, BKC, Bandra East',
      'city': 'Mumbai',
      'state': 'Maharashtra',
      'pincode': '400051',
    },
  ];
  
  int? selectedAddressIndex;
  
  final _formKey = GlobalKey<FormState>();
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill with first saved address if available
    if (savedAddresses.isNotEmpty) {
      selectedAddressIndex = 0;
      _loadAddress(savedAddresses[0]);
    }
  }

  void _loadAddress(Map<String, dynamic> address) {
    nameController.text = address['name'];
    phoneController.text = address['phone'];
    addressController.text = address['address'];
    cityController.text = address['city'];
    stateController.text = address['state'];
    pincodeController.text = address['pincode'];
    selectedAddressType = address['type'];
  }

  void _continueToNext() {
    if (currentStep == 0) {
      // Validate address form
      if (_formKey.currentState!.validate()) {
        setState(() => currentStep = 1);
      }
    } else if (currentStep == 1) {
      setState(() => currentStep = 2);
    }
  }

  void _goBack() {
    if (currentStep > 0) {
      setState(() => currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _placeOrder() async {
    setState(() => isProcessing = true);
    
    // Simulate order processing
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() => isProcessing = false);
    
    // Navigate to order confirmation
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => OrderConfirmationPage(
          orderNumber: 'ORD${DateTime.now().millisecondsSinceEpoch}',
          total: widget.total,
          deliveryAddress: {
            'name': nameController.text,
            'phone': phoneController.text,
            'address': addressController.text,
            'city': cityController.text,
            'state': stateController.text,
            'pincode': pincodeController.text,
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Checkout',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF667EEA),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildStepIndicator(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (currentStep == 0) _buildDeliveryStep(),
                  if (currentStep == 1) _buildPaymentStep(),
                  if (currentStep == 2) _buildReviewStep(),
                ],
              ),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      color: Colors.white,
      child: Row(
        children: [
          _buildStepCircle(0, 'Address', Icons.location_on),
          _buildStepLine(0),
          _buildStepCircle(1, 'Payment', Icons.payment),
          _buildStepLine(1),
          _buildStepCircle(2, 'Review', Icons.check_circle),
        ],
      ),
    );
  }

  Widget _buildStepCircle(int step, String label, IconData icon) {
    bool isActive = currentStep >= step;
    bool isCurrent = currentStep == step;
    
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFF667EEA) : Colors.grey[300],
              shape: BoxShape.circle,
              border: isCurrent
                  ? Border.all(color: const Color(0xFF667EEA), width: 3)
                  : null,
            ),
            child: Icon(
              icon,
              color: isActive ? Colors.white : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
              color: isActive ? const Color(0xFF667EEA) : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepLine(int step) {
    bool isActive = currentStep > step;
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 30),
        color: isActive ? const Color(0xFF667EEA) : Colors.grey[300],
      ),
    );
  }

  Widget _buildDeliveryStep() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Delivery Address',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Saved Addresses
            if (savedAddresses.isNotEmpty) ...[
              Text(
                'Saved Addresses',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              ...savedAddresses.asMap().entries.map((entry) {
                int idx = entry.key;
                Map<String, dynamic> address = entry.value;
                return _buildSavedAddressCard(address, idx);
              }).toList(),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
            ],
            
            // Address Form
            Text(
              savedAddresses.isEmpty ? 'Delivery Details' : 'Or Enter New Address',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            
            // Address Type
            Row(
              children: ['Home', 'Work', 'Other'].map((type) {
                bool isSelected = selectedAddressType == type;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: SizedBox(
                        width: double.infinity,
                        child: Text(
                          type,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() => selectedAddressType = type);
                      },
                      selectedColor: const Color(0xFF667EEA),
                      backgroundColor: Colors.grey[200],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            
            _buildTextField(
              controller: nameController,
              label: 'Full Name',
              icon: Icons.person,
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            
            _buildTextField(
              controller: phoneController,
              label: 'Phone Number',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Required';
                if (value!.length < 10) return 'Invalid phone number';
                return null;
              },
            ),
            const SizedBox(height: 12),
            
            _buildTextField(
              controller: emailController,
              label: 'Email (Optional)',
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            
            _buildTextField(
              controller: addressController,
              label: 'Address',
              icon: Icons.location_on,
              maxLines: 3,
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: cityController,
                    label: 'City',
                    icon: Icons.location_city,
                    validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    controller: stateController,
                    label: 'State',
                    icon: Icons.map,
                    validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            _buildTextField(
              controller: pincodeController,
              label: 'Pincode',
              icon: Icons.pin_drop,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Required';
                if (value!.length != 6) return 'Invalid pincode';
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            CheckboxListTile(
              value: saveAddress,
              onChanged: (value) => setState(() => saveAddress = value!),
              title: Text(
                'Save this address for future orders',
                style: GoogleFonts.poppins(fontSize: 14),
              ),
              activeColor: const Color(0xFF667EEA),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavedAddressCard(Map<String, dynamic> address, int index) {
    bool isSelected = selectedAddressIndex == index;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? const Color(0xFF667EEA) : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            selectedAddressIndex = index;
            _loadAddress(address);
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Radio<int>(
                value: index,
                groupValue: selectedAddressIndex,
                onChanged: (value) {
                  setState(() {
                    selectedAddressIndex = value;
                    _loadAddress(address);
                  });
                },
                activeColor: const Color(0xFF667EEA),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF667EEA).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            address['type'],
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF667EEA),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          address['name'],
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      address['phone'],
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${address['address']}, ${address['city']}, ${address['state']} - ${address['pincode']}',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(),
        prefixIcon: Icon(icon, color: const Color(0xFF667EEA)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF667EEA), width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      style: GoogleFonts.poppins(),
    );
  }

  Widget _buildPaymentStep() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Method',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          _buildPaymentOption(
            'Cash on Delivery',
            'COD',
            Icons.money,
            'Pay with cash upon delivery',
          ),
          const SizedBox(height: 12),
          
          _buildPaymentOption(
            'UPI Payment',
            'UPI',
            Icons.account_balance_wallet,
            'Pay using UPI apps like GPay, PhonePe',
          ),
          const SizedBox(height: 12),
          
          _buildPaymentOption(
            'Credit/Debit Card',
            'Card',
            Icons.credit_card,
            'Pay securely with your card',
          ),
          const SizedBox(height: 12),
          
          _buildPaymentOption(
            'Net Banking',
            'NetBanking',
            Icons.account_balance,
            'Pay through your bank account',
          ),
          const SizedBox(height: 24),
          
          if (selectedPaymentMethod == 'Card') _buildCardForm(),
          if (selectedPaymentMethod == 'UPI') _buildUPIForm(),
          if (selectedPaymentMethod == 'NetBanking') _buildNetBankingForm(),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(
    String title,
    String value,
    IconData icon,
    String subtitle,
  ) {
    bool isSelected = selectedPaymentMethod == value;
    
    return Card(
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? const Color(0xFF667EEA) : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () => setState(() => selectedPaymentMethod = value),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Radio<String>(
                value: value,
                groupValue: selectedPaymentMethod,
                onChanged: (val) => setState(() => selectedPaymentMethod = val!),
                activeColor: const Color(0xFF667EEA),
              ),
              Icon(icon, color: const Color(0xFF667EEA), size: 28),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
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
        ),
      ),
    );
  }

  Widget _buildCardForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Card Number',
                labelStyle: GoogleFonts.poppins(),
                prefixIcon: const Icon(Icons.credit_card),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: 'Cardholder Name',
                labelStyle: GoogleFonts.poppins(),
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Expiry (MM/YY)',
                      labelStyle: GoogleFonts.poppins(),
                      prefixIcon: const Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'CVV',
                      labelStyle: GoogleFonts.poppins(),
                      prefixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    obscureText: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUPIForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'UPI ID',
                labelStyle: GoogleFonts.poppins(),
                hintText: 'example@upi',
                hintStyle: GoogleFonts.poppins(),
                prefixIcon: const Icon(Icons.alternate_email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildUPIApp('GPay', 'assets/gpay.png'),
                _buildUPIApp('PhonePe', 'assets/phonepe.png'),
                _buildUPIApp('Paytm', 'assets/paytm.png'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUPIApp(String name, String asset) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.payment, size: 30, color: Colors.grey[600]),
        ),
        const SizedBox(height: 4),
        Text(name, style: GoogleFonts.poppins(fontSize: 12)),
      ],
    );
  }

  Widget _buildNetBankingForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Your Bank',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            ...['SBI', 'HDFC', 'ICICI', 'Axis Bank', 'Other Banks'].map(
              (bank) => RadioListTile<String>(
                title: Text(bank, style: GoogleFonts.poppins()),
                value: bank,
                groupValue: null,
                onChanged: (value) {},
                activeColor: const Color(0xFF667EEA),
              ),
            ).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewStep() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Delivery Address Summary
          _buildSummaryCard(
            'Delivery Address',
            Icons.location_on,
            '${nameController.text}\n${phoneController.text}\n${addressController.text}, ${cityController.text}, ${stateController.text} - ${pincodeController.text}',
            () => setState(() => currentStep = 0),
          ),
          const SizedBox(height: 12),
          
          // Payment Method Summary
          _buildSummaryCard(
            'Payment Method',
            Icons.payment,
            selectedPaymentMethod == 'COD'
                ? 'Cash on Delivery'
                : selectedPaymentMethod,
            () => setState(() => currentStep = 1),
          ),
          const SizedBox(height: 16),
          
          // Order Items
          Text(
            'Order Items (${widget.cartItems.length})',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          
          ...widget.cartItems.map((item) => _buildOrderItemCard(item)).toList(),
          
          const SizedBox(height: 16),
          
          // Price Summary
          _buildPriceSummaryCard(),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    IconData icon,
    String content,
    VoidCallback onEdit,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(icon, color: const Color(0xFF667EEA)),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: onEdit,
                  child: Text('Edit', style: GoogleFonts.poppins()),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: GoogleFonts.poppins(
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItemCard(Map<String, dynamic> item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item['image'],
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'],
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Qty: ${item['quantity']} | ${item['meters']}m',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '₹${(item['price'] * item['quantity']).toStringAsFixed(2)}',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF667EEA),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceSummaryCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildPriceRow('Subtotal', widget.subtotal),
            if (widget.discount > 0)
              _buildPriceRow('Discount', -widget.discount, isDiscount: true),
            _buildPriceRow('Delivery Fee', widget.deliveryFee),
            _buildPriceRow('Tax (18% GST)', widget.tax),
            const Divider(height: 24),
            _buildPriceRow('Total Amount', widget.total, isTotal: true),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount,
      {bool isTotal = false, bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.black : Colors.grey[700],
            ),
          ),
          Text(
            '₹${amount.toStringAsFixed(2)}',
            style: GoogleFonts.poppins(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              color: isDiscount
                  ? Colors.green
                  : (isTotal ? const Color(0xFF667EEA) : Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _goBack,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Color(0xFF667EEA)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Back',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF667EEA),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          if (currentStep > 0) const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: isProcessing
                  ? null
                  : (currentStep == 2 ? _placeOrder : _continueToNext),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF667EEA),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                disabledBackgroundColor: Colors.grey[400],
              ),
              child: isProcessing
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      currentStep == 2 ? 'Place Order' : 'Continue',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    cityController.dispose();
    stateController.dispose();
    pincodeController.dispose();
    super.dispose();
  }
}

// Order Confirmation Page
class OrderConfirmationPage extends StatelessWidget {
  final String orderNumber;
  final double total;
  final Map<String, String> deliveryAddress;

  const OrderConfirmationPage({
    Key? key,
    required this.orderNumber,
    required this.total,
    required this.deliveryAddress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  size: 80,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Order Placed Successfully!',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Your order has been confirmed',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Order Number',
                          style: GoogleFonts.poppins(color: Colors.grey[600]),
                        ),
                        Text(
                          orderNumber,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Amount',
                          style: GoogleFonts.poppins(color: Colors.grey[600]),
                        ),
                        Text(
                          '₹${total.toStringAsFixed(2)}',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF667EEA),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Estimated Delivery',
                          style: GoogleFonts.poppins(color: Colors.grey[600]),
                        ),
                        Text(
                          '3-5 Business Days',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to order tracking
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF667EEA),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Track Order',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Color(0xFF667EEA)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Continue Shopping',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF667EEA),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class CheckoutPage extends StatefulWidget {
//   final List<Map<String, dynamic>> cartItems;
//   final Function onOrderSuccess;

//   const CheckoutPage({
//     Key? key,
//     required this.cartItems,
//     required this.onOrderSuccess,
//   }) : super(key: key);

//   @override
//   State<CheckoutPage> createState() => _CheckoutPageState();
// }

// class _CheckoutPageState extends State<CheckoutPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _addressController = TextEditingController();
//   final _cityController = TextEditingController();
//   final _pincodeController = TextEditingController();

//   String _selectedPaymentMethod = 'Credit Card';

//   double get totalPrice {
//     return widget.cartItems.fold(0, (total, item) {
//       return total + (item['price'] * (item['quantity'] ?? 1));
//     });
//   }

//   void _placeOrder() {
//     if (_formKey.currentState!.validate()) {
//       // Simulate order processing
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text('Order Confirmed'),
//           content: Text('Your order has been placed successfully!'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context); // Close dialog
//                 widget.onOrderSuccess();
//                 Navigator.popUntil(context, (route) => route.isFirst);
//               },
//               child: Text('OK'),
//             ),
//           ],
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Checkout',
//           style: GoogleFonts.poppins(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: const Color(0xFF667EEA),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               // Order Summary
//               _buildOrderSummary(),
//               SizedBox(height: 20),
              
//               // Shipping Information
//               _buildShippingForm(),
//               SizedBox(height: 20),
              
//               // Payment Method
//               _buildPaymentMethod(),
//               SizedBox(height: 30),
              
//               // Place Order Button
//               _buildPlaceOrderButton(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildOrderSummary() {
//     return Card(
//       elevation: 2,
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Order Summary',
//               style: GoogleFonts.poppins(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 12),
//             ...widget.cartItems.map((item) => Padding(
//               padding: const EdgeInsets.symmetric(vertical: 4),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     '${item['name']} (x${item['quantity'] ?? 1})',
//                     style: GoogleFonts.poppins(fontSize: 14),
//                   ),
//                   Text(
//                     '₹${(item['price'] * (item['quantity'] ?? 1)).toStringAsFixed(2)}',
//                     style: GoogleFonts.poppins(
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//             )).toList(),
//             Divider(),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Total:',
//                   style: GoogleFonts.poppins(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   '₹${totalPrice.toStringAsFixed(2)}',
//                   style: GoogleFonts.poppins(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF667EEA),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildShippingForm() {
//     return Card(
//       elevation: 2,
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Shipping Information',
//               style: GoogleFonts.poppins(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 12),
//             TextFormField(
//               controller: _nameController,
//               decoration: InputDecoration(
//                 labelText: 'Full Name',
//                 border: OutlineInputBorder(),
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter your name';
//                 }
//                 return null;
//               },
//             ),
//             SizedBox(height: 12),
//             TextFormField(
//               controller: _emailController,
//               decoration: InputDecoration(
//                 labelText: 'Email',
//                 border: OutlineInputBorder(),
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter your email';
//                 }
//                 return null;
//               },
//             ),
//             SizedBox(height: 12),
//             TextFormField(
//               controller: _phoneController,
//               decoration: InputDecoration(
//                 labelText: 'Phone Number',
//                 border: OutlineInputBorder(),
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter your phone number';
//                 }
//                 return null;
//               },
//             ),
//             SizedBox(height: 12),
//             TextFormField(
//               controller: _addressController,
//               maxLines: 2,
//               decoration: InputDecoration(
//                 labelText: 'Address',
//                 border: OutlineInputBorder(),
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter your address';
//                 }
//                 return null;
//               },
//             ),
//             SizedBox(height: 12),
//             Row(
//               children: [
//                 Expanded(
//                   child: TextFormField(
//                     controller: _cityController,
//                     decoration: InputDecoration(
//                       labelText: 'City',
//                       border: OutlineInputBorder(),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your city';
//                       }
//                       return null;
//                     },
//                   ),
//                 ),
//                 SizedBox(width: 12),
//                 Expanded(
//                   child: TextFormField(
//                     controller: _pincodeController,
//                     decoration: InputDecoration(
//                       labelText: 'Pincode',
//                       border: OutlineInputBorder(),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter pincode';
//                       }
//                       return null;
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPaymentMethod() {
//     return Card(
//       elevation: 2,
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Payment Method',
//               style: GoogleFonts.poppins(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 12),
//             ...['Credit Card', 'Debit Card', 'UPI', 'Cash on Delivery'].map((method) => RadioListTile(
//               title: Text(method),
//               value: method,
//               groupValue: _selectedPaymentMethod,
//               onChanged: (value) {
//                 setState(() {
//                   _selectedPaymentMethod = value.toString();
//                 });
//               },
//             )).toList(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPlaceOrderButton() {
//     return ElevatedButton(
//       onPressed: _placeOrder,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Color(0xFF667EEA),
//         padding: EdgeInsets.symmetric(vertical: 16),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//       ),
//       child: Text(
//         'Place Order - ₹${totalPrice.toStringAsFixed(2)}',
//         style: GoogleFonts.poppins(
//           color: Colors.white,
//           fontWeight: FontWeight.w600,
//           fontSize: 16,
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     _addressController.dispose();
//     _cityController.dispose();
//     _pincodeController.dispose();
//     super.dispose();
//   }
// }