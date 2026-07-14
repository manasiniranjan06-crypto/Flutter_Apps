import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/Screens/controller/product_provider_controller.dart';
import 'package:grocery_app/Screens/model/Product_model.dart';
import 'package:grocery_app/Screens/view/product_detail_page.dart';
import 'package:provider/provider.dart';

class Favscreen extends StatefulWidget {
  const Favscreen({super.key});

  @override
  State<Favscreen> createState() => _FavscreenState();
}

class _FavscreenState extends State<Favscreen> {
  bool addedToCart = false; // Tracks bottom button state

  @override
  Widget build(BuildContext context) {
    log("in fav screen build");

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Favorite",
          style: GoogleFonts.dmSans(
            fontSize: 25,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          final favProducts = provider.favProductScreenList;

          if (favProducts.isEmpty) {
            return Center(
              child: Text(
                "NO Favorite Product",
                style: GoogleFonts.dmSans(
                  fontSize: 20,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            separatorBuilder: (_, __) => Divider(color: Colors.grey[300]),
            itemCount: favProducts.length,
            itemBuilder: (context, index) {
              final product = favProducts[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailPage(product: product),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Image.asset(
                      product.image,
                      height: 80,
                      width: 80,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: GoogleFonts.dmSans(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          product.unit,
                          style: GoogleFonts.dmSans(
                            fontSize: 16,
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      "₹${product.price.toStringAsFixed(2)}",
                      style: GoogleFonts.dmSans(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.keyboard_arrow_right),
                  ],
                ),
              );
            },
          );
        },
      ),

      // Bottom "Add All To Cart" button (separate)
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: GestureDetector(
          onTap: () {
            final provider = context.read<ProductProvider>();

            // Add all favorite products to cart
            for (var product in provider.favProductScreenList) {
              provider.addToCart(product.id);
              provider.increaseQuantity(product.id);
            }

            // Show tick icon
            setState(() {
              addedToCart = true;
            });

            // Reset tick after 0.5 seconds
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) {
                setState(() {
                  addedToCart = false;
                });
              }
            });
          },
          child: Container(
            height: 60,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(20),
            ),
            child: addedToCart
                ? const Icon(Icons.check, color: Colors.white, size: 32)
                : Text(
                    "Add All To Cart",
                    style: GoogleFonts.dmSans(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

}
