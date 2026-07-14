import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:grocery_app/Screens/controller/product_provider_controller.dart';
import 'package:grocery_app/Screens/model/Product_model.dart';
import 'package:grocery_app/Screens/view/cart_page.dart';

class Beverages extends StatefulWidget {
  const Beverages({super.key});

  @override
  State<Beverages> createState() => _BeveragesState();
}

class _BeveragesState extends State<Beverages> {
  // Example product list
  final List<ProductModel> beverages = [
    ProductModel(
        id: "1",
        name: "Diet Coke",
        category: "Beverages",
        image: "assets/productpge/coke.png",
        price: 40,
        unit: "355ml"),
    ProductModel(
        id: "2",
        name: "Sprite Can",
        category: "Beverages",
        image: "assets/productpge/sprit.png",
        price: 60,
        unit: "325ml"),
    ProductModel(
        id: "3",
        name: "Apple & Grape Juice",
        category: "Beverages",
        image: "assets/productpge/applejucie.png",
        price: 140,
        unit: "355ml"),
    ProductModel(
        id: "4",
        name: "Orange Juice",
        category: "Beverages",
        image: "assets/productpge/orangeJu.png",
        price: 40,
        unit: "355ml"),
    ProductModel(
        id: "5",
        name: "Coca Cola",
        category: "Beverages",
        image: "assets/productpge/cocacola.png",
        price: 40,
        unit: "355ml"),
    ProductModel(
        id: "6",
        name: "Pepsi",
        category: "Beverages",
        image: "assets/productpge/pepsi.png",
        price: 40,
        unit: "355ml"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(color: Colors.black),
        title: Text(
          "Beverages",
          style: GoogleFonts.dmSans(
            fontSize: 25,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [Image.asset("assets/productpge/range.png"), SizedBox(width: 10)],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.builder(
          itemCount: beverages.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 0.78,
          ),
          itemBuilder: (context, index) {
            final product = beverages[index];
            return BeverageCard(product: product);
          },
        ),
      ),
    );
  }
}

/// ------------------------- Stateful Beverage Card -------------------------
class BeverageCard extends StatefulWidget {
  final ProductModel product;

  const BeverageCard({super.key, required this.product});

  @override
  State<BeverageCard> createState() => _BeverageCardState();
}

class _BeverageCardState extends State<BeverageCard> {
  bool _addedToCart = false;

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ProductProvider>();
    final int qty = provider.getQuantity(widget.product.id);
    final double total = widget.product.price * qty;

    return Container(
      height: 200,
      width: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Image.asset(widget.product.image)),
          const SizedBox(height: 10),
          Text(widget.product.name,
              style: GoogleFonts.dmSans(fontSize: 17, fontWeight: FontWeight.w800)),
          Text(widget.product.unit,
              style: GoogleFonts.dmSans(fontSize: 15, color: Colors.grey, fontWeight: FontWeight.w700)),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("₹$total",
                  style: GoogleFonts.dmSans(fontSize: 22, fontWeight: FontWeight.w900)),
              GestureDetector(
                onTap: () {
                  // Add product to cart
                  provider.addToCart(widget.product.id);

                  // Set initial quantity if not already
                  if (provider.getQuantity(widget.product.id) == 1) {
                    provider.increaseQuantity(widget.product.id);
                  }

                  // Show tick
                  setState(() => _addedToCart = true);

                  // Reset tick after 0.5 seconds
                  Future.delayed(const Duration(milliseconds: 500), () {
                    if (mounted) setState(() => _addedToCart = false);
                  });

               
                },
                child: Container(
                  height: 30,
                  width: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.green),
                  child: _addedToCart
                      ? const Icon(Icons.check, color: Colors.white, size: 18)
                      : const Icon(Icons.add, color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
