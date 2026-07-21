import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/Screens/controller/product_provider_controller.dart';
import 'package:grocery_app/Screens/view/payment.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    log("Building Cart Page");

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "My Cart",
          style: GoogleFonts.dmSans(
            fontSize: 25,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          final cartProducts = provider.cartProductget;

          if (cartProducts.isEmpty) {
            return Center(
              child: Text(
                "No Products",
                style: GoogleFonts.dmSans(
                  fontSize: 20,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: cartProducts.length,
                  separatorBuilder: (_, __) => Divider(color: Colors.grey[300]),
                  itemBuilder: (context, index) {
                    final product = cartProducts[index];
                    final quantity = provider.getQuantity(product.id);

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Product Image
                          Image.asset(
                            product.image,
                            height: 80,
                            width: 80,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 15),

                          // Name + unit + quantity
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: GoogleFonts.dmSans(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  product.unit,
                                  style: GoogleFonts.dmSans(
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Quantity Row
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () =>
                                          provider.decreaseQuantity(product.id),
                                      child: Container(
                                        height: 25,
                                        width: 25,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                          color: Colors.white,
                                        ),
                                        child: const Icon(
                                          Icons.remove,
                                          size: 18,
                                          color: Colors.blueGrey,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "$quantity",
                                      style: GoogleFonts.dmSans(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: () =>
                                          provider.increaseQuantity(product.id),
                                      child: Container(
                                        height: 25,
                                        width: 25,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                          color: Colors.white,
                                        ),
                                        child: const Icon(
                                          Icons.add,
                                          size: 18,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Price + remove button
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () =>
                                    provider.removeFromCart(product.id),
                                child: const Icon(
                                  Icons.clear,
                                  color: Colors.grey,
                                  size: 30,
                                ),
                              ),
                              Text(
                                "₹${(product.price * quantity).toStringAsFixed(2)}",
                                style: GoogleFonts.dmSans(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Checkout Button
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: GestureDetector(
                  onTap: () {
                    checkoutBottomSheet();
                  },
                  child: Container(
                    height: 60,
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.green,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Proceed to Checkout",
                      style: GoogleFonts.dmSans(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  //checkout
// Proceed to checkout bottom sheet
void checkoutBottomSheet() {
  final provider = context.read<ProductProvider>();
   final total = provider.cartProductget.fold<double>(
    0.0,
    (sum, product) => sum + product.price * provider.getQuantity(product.id),
  );
  showModalBottomSheet(
    
    isScrollControlled: true,
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: Colors.white,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SizedBox(
            height: 400,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Text(
                      "Checkout",
                      style: GoogleFonts.dmSans(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.clear, size: 32),
                    ),
                  ],
                ),
                 SizedBox(height: 8),
                Image.asset("assets/productpge/line.png"),
                SizedBox(height: 8),
                // Delivery
                Row(
                  children: [
                    Text(
                      "Delivery",
                      style: GoogleFonts.dmSans(
                        fontSize: 20,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Text(
                      "Select Method",
                      style: GoogleFonts.dmSans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.keyboard_arrow_right, size: 32),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Image.asset("assets/productpge/line.png"),
                SizedBox(height: 8),

                // Payment
                Row(
                  children: [
                    Text(
                      "Payment",
                      style: GoogleFonts.dmSans(
                        fontSize: 20,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.keyboard_arrow_right, size: 32),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Image.asset("assets/productpge/line.png"),
                SizedBox(height: 8),
                // Promo Code
                Row(
                  children: [
                    Text(
                      "Promo Code",
                      style: GoogleFonts.dmSans(
                        fontSize: 20,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Text(
                      "Pick Discount",
                      style: GoogleFonts.dmSans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.keyboard_arrow_right, size: 32),
                    ),
                  ],
                ),
               SizedBox(height: 7),
                Image.asset("assets/productpge/line.png"),
                SizedBox(height: 8),
                // Total
                Row(
                  children: [
                    Text(
                      "Total",
                      style: GoogleFonts.dmSans(
                        fontSize: 20,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Text(
                      // "₹500.00", // You can calculate total dynamically
                      total.toStringAsFixed(2),
                      style: GoogleFonts.dmSans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                 SizedBox(height: 8),
                Image.asset("assets/productpge/line.png"),
                SizedBox(height: 8),
                // Terms
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "By placing an order you agree to our",
                      style: GoogleFonts.dmSans(fontSize: 15, color: Colors.grey[700]),
                    ),
                    Text(
                      "Terms and Conditions",
                      style: GoogleFonts.dmSans(fontSize: 15, color: Colors.black),
                    ),
                  ],
                ),
                SizedBox(height: 3),

                // Place Order Button
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return paymentScreen();
                      }));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Place Order",
                      style: GoogleFonts.dmSans(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}
}