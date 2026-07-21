import 'package:firebaseauth/customerside/components/gradient_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CartScreen extends StatefulWidget {
  final List<Map<String, dynamic>>? initialItems;

  const CartScreen({Key? key, this.initialItems}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> cartItems = [];
  String promoCode = '';
  double promoDiscount = 0.0;
  bool isPromoApplied = false;

  @override
  void initState() {
    super.initState();
    // Initialize with initial items if provided, otherwise with default items
    cartItems = widget.initialItems ?? [
      {
        'id': '1',
        'itemName': 'Custom Suit',
        'tailorName': 'Fashion Hub',
        'tailorImage': 'https://images.unsplash.com/photo-1556906781-9a412961c28c?w=500',
        'itemImage': 'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?w=500',
        'price': 2499,
        'quantity': 1,
        'size': 'L',
        'color': 'Navy Blue',
        'customization': 'Monogram on pocket',
      },
      {
        'id': '2',
        'itemName': 'Designer Kurta',
        'tailorName': 'Style Studio',
        'tailorImage': 'https://images.unsplash.com/photo-1558769132-cb1aea3c1eff?w=500',
        'itemImage': 'https://images.unsplash.com/photo-1583743814966-8936f5b7be1a?w=500',
        'price': 1899,
        'quantity': 2,
        'size': 'M',
        'color': 'Cream',
        'customization': 'Embroidery design',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return GradientScaffold(
      appBar: AppBar(
        title: Text(
          'My Cart',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (cartItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.white),
              onPressed: _showClearCartDialog,
              tooltip: 'Clear Cart',
            ),
        ],
      ),
      child: cartItems.isEmpty ? _buildEmptyCart() : _buildCartContent(isTablet),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8075FF).withOpacity(0.2),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(
                Icons.shopping_cart_outlined,
                size: 100,
                color: Colors.grey[300],
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Your Cart is Empty',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Add items to your cart to see them here',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8075FF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
              ),
              child: Text(
                'Continue Shopping',
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

  Widget _buildCartContent(bool isTablet) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(isTablet ? 24 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCartHeader(),
                const SizedBox(height: 20),
                ...cartItems.map((item) => _buildCartItem(item, isTablet)).toList(),
                const SizedBox(height: 20),
                _buildPromoCodeSection(),
                const SizedBox(height: 20),
                _buildPriceSummary(isTablet),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
        _buildCheckoutButton(),
      ],
    );
  }

  Widget _buildCartHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF8075FF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.shopping_bag,
              color: Color(0xFF8075FF),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${cartItems.length} ${cartItems.length == 1 ? 'Item' : 'Items'} in Cart',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  '${_getTotalQuantity()} ${_getTotalQuantity() == 1 ? 'piece' : 'pieces'} total',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          // Save for later button
          if (cartItems.isNotEmpty)
            TextButton.icon(
              onPressed: _saveCartForLater,
              icon: const Icon(Icons.bookmark_border, size: 18),
              label: Text(
                'Save',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF8075FF),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCartItem(Map<String, dynamic> item, bool isTablet) {
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
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Item Image with badge
                Stack(
                  children: [
                    Container(
                      width: isTablet ? 120 : 90,
                      height: isTablet ? 120 : 90,
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
                          item['itemImage'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stack) => Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.image, color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    // Quantity badge
                    Positioned(
                      top: -5,
                      right: -5,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8075FF),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${item['quantity']}',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                
                // Item Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item['itemName'],
                              style: GoogleFonts.poppins(
                                fontSize: isTablet ? 18 : 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'remove') {
                                _removeItem(item['id']);
                              } else if (value == 'save') {
                                _saveItemForLater(item);
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'save',
                                child: Row(
                                  children: [
                                    Icon(Icons.bookmark, size: 18, color: Colors.blue),
                                    SizedBox(width: 8),
                                    Text('Save for Later'),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'remove',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete, size: 18, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text('Remove'),
                                  ],
                                ),
                              ),
                            ],
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.more_vert, size: 18, color: Colors.grey[600]),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      
                      // Tailor Info
                      Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF8075FF).withOpacity(0.3),
                                width: 1.5,
                              ),
                            ),
                            child: ClipOval(
                              child: Image.network(
                                item['tailorImage'],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stack) => Icon(
                                  Icons.store,
                                  size: 14,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            item['tailorName'],
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const Spacer(),
                          // Delivery time
                          Row(
                            children: [
                              Icon(Icons.schedule, size: 12, color: Colors.green),
                              SizedBox(width: 4),
                              Text(
                                '5-7 days',
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      
                      // Size and Color
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          _buildInfoChip('Size: ${item['size']}', Icons.straighten),
                          _buildInfoChip(item['color'], Icons.palette),
                        ],
                      ),
                      const SizedBox(height: 8),
                      
                      // Customization
                      if (item['customization'] != null && item['customization'].isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF8075FF).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.design_services, size: 12, color: Color(0xFF8075FF)),
                              SizedBox(width: 4),
                              Text(
                                item['customization'],
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: const Color(0xFF8075FF),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Fabric details if available
                      if (item['fabricDetails'] != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            'Fabric: ${item['fabricDetails']['name']}',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            
            // Price and Quantity Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '₹${(item['price'] * item['quantity']).toStringAsFixed(0)}',
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 20 : 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF8075FF),
                      ),
                    ),
                    if (item['quantity'] > 1)
                      Text(
                        '₹${item['price']} each',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                  ],
                ),
                _buildQuantityControl(item),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityControl(Map<String, dynamic> item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove, size: 18),
            onPressed: item['quantity'] > 1
                ? () => _updateQuantity(item['id'], item['quantity'] - 1)
                : null,
            color: item['quantity'] > 1 ? const Color(0xFF8075FF) : Colors.grey[400],
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            padding: EdgeInsets.zero,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            constraints: const BoxConstraints(minWidth: 20),
            child: Text(
              '${item['quantity']}',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, size: 18),
            onPressed: () => _updateQuantity(item['id'], item['quantity'] + 1),
            color: const Color(0xFF8075FF),
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildPromoCodeSection() {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.local_offer,
                color: const Color(0xFF8075FF),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Apply Promo Code',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (value) => promoCode = value,
                  enabled: !isPromoApplied,
                  decoration: InputDecoration(
                    hintText: 'Enter promo code',
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[400],
                    ),
                    filled: true,
                    fillColor: isPromoApplied ? Colors.green.withOpacity(0.1) : Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    suffixIcon: isPromoApplied
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : null,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: isPromoApplied ? _removePromo : _applyPromo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isPromoApplied ? Colors.red : const Color(0xFF8075FF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  isPromoApplied ? 'Remove' : 'Apply',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (isPromoApplied)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                '✓ Promo code applied! You saved ₹${promoDiscount.toStringAsFixed(0)}',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          const SizedBox(height: 8),
          // Available promo codes
          Wrap(
            spacing: 8,
            children: [
              _buildPromoChip('TAILFAB10', '10% off'),
              _buildPromoChip('WELCOME15', '15% off'),
              _buildPromoChip('FREESHIP', 'Free delivery'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPromoChip(String code, String description) {
    return GestureDetector(
      onTap: () {
        setState(() {
          promoCode = code;
        });
        if (!isPromoApplied) {
          _applyPromo();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF8075FF).withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF8075FF).withOpacity(0.3)),
        ),
        child: Text(
          code,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: const Color(0xFF8075FF),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildPriceSummary(bool isTablet) {
    double subtotal = _calculateSubtotal();
    double tax = subtotal * 0.18; // 18% GST
    double deliveryFee = _calculateDeliveryFee();
    double total = subtotal + tax + deliveryFee - promoDiscount;

    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Price Summary',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _buildPriceRow('Subtotal', subtotal),
          const SizedBox(height: 8),
          _buildPriceRow('Tax (18% GST)', tax),
          const SizedBox(height: 8),
          _buildPriceRow('Delivery Fee', deliveryFee),
          if (isPromoApplied)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: _buildPriceRow('Discount', -promoDiscount, isDiscount: true),
            ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, thickness: 1.5),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Amount',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'Inclusive of all taxes',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              Text(
                '₹${total.toStringAsFixed(0)}',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF8075FF),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Delivery estimate
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.schedule, size: 16, color: Colors.green),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Expected delivery: 5-7 business days',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: isDiscount ? Colors.green : Colors.grey[600],
          ),
        ),
        Text(
          isDiscount ? '-₹${amount.abs().toStringAsFixed(0)}' : '₹${amount.toStringAsFixed(0)}',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDiscount ? Colors.green : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckoutButton() {
    double total = _calculateTotal();
    
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
      child: SafeArea(
        child: Column(
          children: [
            // Secure payment info
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock, size: 14, color: Colors.green),
                SizedBox(width: 4),
                Text(
                  'Secure payment • 100% Safe & Secure',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _proceedToCheckout,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8075FF),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Proceed to Checkout',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '₹${total.toStringAsFixed(0)}',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, size: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Methods
  int _getTotalQuantity() {
    return cartItems.fold(0, (sum, item) => sum + (item['quantity'] as int));
  }

  double _calculateSubtotal() {
    return cartItems.fold(0, (sum, item) => sum + (item['price'] * item['quantity']));
  }

  double _calculateDeliveryFee() {
    // Free delivery for orders above 2000
    double subtotal = _calculateSubtotal();
    return subtotal > 2000 ? 0.0 : 50.0;
  }

  double _calculateTotal() {
    double subtotal = _calculateSubtotal();
    double tax = subtotal * 0.18;
    double deliveryFee = _calculateDeliveryFee();
    return subtotal + tax + deliveryFee - promoDiscount;
  }

  void _updateQuantity(String id, int newQuantity) {
    setState(() {
      final index = cartItems.indexWhere((item) => item['id'] == id);
      if (index != -1) {
        cartItems[index]['quantity'] = newQuantity;
        _showSnackBar('Quantity updated');
      }
    });
  }

  void _removeItem(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Remove Item?',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF8075FF),
          ),
        ),
        content: Text(
          'Are you sure you want to remove this item from cart?',
          style: GoogleFonts.poppins(),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                cartItems.removeWhere((item) => item['id'] == id);
              });
              Navigator.pop(context);
              _showSnackBar('Item removed from cart');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Remove',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearCartDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Clear Cart?',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        content: Text(
          'Are you sure you want to remove all items from cart?',
          style: GoogleFonts.poppins(),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                cartItems.clear();
                isPromoApplied = false;
                promoDiscount = 0.0;
              });
              Navigator.pop(context);
              _showSnackBar('Cart cleared');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Clear All',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _applyPromo() {
    if (promoCode.trim().isEmpty) {
      _showSnackBar('Please enter a promo code', isError: true);
      return;
    }

    // Mock promo code validation
    Map<String, double> validPromos = {
      'TAILFAB10': 0.10, // 10% discount
      'WELCOME15': 0.15, // 15% discount
      'FREESHIP': 0.0,   // Free shipping (handled separately)
    };

    if (validPromos.containsKey(promoCode.toUpperCase())) {
      double discountRate = validPromos[promoCode.toUpperCase()]!;
      
      if (promoCode.toUpperCase() == 'FREESHIP') {
        setState(() {
          promoDiscount = _calculateDeliveryFee();
          isPromoApplied = true;
        });
        _showSnackBar('Free shipping applied!');
      } else {
        setState(() {
          promoDiscount = _calculateSubtotal() * discountRate;
          isPromoApplied = true;
        });
        _showSnackBar('Promo code applied successfully!');
      }
    } else {
      _showSnackBar('Invalid promo code', isError: true);
    }
  }

  void _removePromo() {
    setState(() {
      promoDiscount = 0.0;
      isPromoApplied = false;
      promoCode = '';
    });
    _showSnackBar('Promo code removed');
  }

  void _saveCartForLater() {
    _showSnackBar('Cart saved for later');
    // Implement save cart functionality
  }

  void _saveItemForLater(Map<String, dynamic> item) {
    _showSnackBar('${item['itemName']} saved for later');
    // Implement save item functionality
  }

  void _proceedToCheckout() {
    if (cartItems.isEmpty) {
      _showSnackBar('Your cart is empty', isError: true);
      return;
    }

    _showSnackBar('Proceeding to checkout...');
    // Navigator.push(context, MaterialPageRoute(builder: (context) => CheckoutScreen()));
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.poppins(),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? Colors.red : const Color(0xFF8075FF),
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}