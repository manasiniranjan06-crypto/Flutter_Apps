import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/Screens/controller/product_provider_controller.dart';
import 'package:grocery_app/Screens/model/Product_model.dart';
import 'package:grocery_app/Screens/view/cart_page.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductModel product;
  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  PageController controller = PageController();
  int _quantity = 1;
  bool _showInfo = false;
  bool _addtoCart = false;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Top image section with PageView
              Container(
                height: 400,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  color: const Color.fromARGB(255, 233, 233, 233),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 234, 234, 234),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.black,
                            ),
                          ),
                          Icon(Icons.ios_share_outlined, color: Colors.black),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 300,
                      child: PageView(
                        controller: controller,
                        children: (product.images ?? [product.image])
                            .map((img) => Image.asset(img, fit: BoxFit.contain))
                            .toList(),
                      ),
                    ),

                    SizedBox(height: 10),
                    SmoothPageIndicator(
                      controller: controller,
                      count: 3,
                      effect: ExpandingDotsEffect(
                        dotColor: Colors.green.shade100,
                        activeDotColor: Colors.green,
                        dotHeight: 4,
                        dotWidth: 4,
                      ),
                    ),
                  ],
                ),
              ),

              // Product info section
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name, unit, favorite
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: GoogleFonts.dmSans(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              product.unit,
                              style: GoogleFonts.dmSans(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            final provider = context.read<ProductProvider>();
                            provider.toggleFavoriteScreen(
                              product.id,
                            ); //toggle fav
                          },
                          child: Consumer<ProductProvider>(
                            builder: (context, value, child) {
                              final isFav = value.isFavorite(product.id);
                              return Icon(
                                isFav
                                    ? Icons.favorite
                                    : Icons.favorite_border_outlined,
                                color: isFav ? Colors.red : Colors.black,
                                size: 30,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Quantity selector & total price
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (_quantity > 1) {
                              setState(() => _quantity--);
                            }
                          },
                          child: Icon(
                            Icons.remove_outlined,
                            color: Colors.blueGrey,
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          height: 30,
                          width: 30,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Text(
                            _quantity.toString(),
                            style: GoogleFonts.dmSans(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        GestureDetector(
                          onTap: () => setState(() => _quantity++),
                          child: Icon(Icons.add, color: Colors.green),
                        ),
                        Spacer(),
                        Text(
                          "₹${(product.price * _quantity).toStringAsFixed(2)}",
                          style: GoogleFonts.dmSans(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Divider(color: Colors.grey[300]),

                    // Product Details (Expandable)
                    GestureDetector(
                      onTap: () => setState(() => _showInfo = !_showInfo),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Product Detail",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            _showInfo
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                          ),
                        ],
                      ),
                    ),
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 200),
                      child: _showInfo
                          ? Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                product.description ??
                                    "No description available for this product.",
                                style: GoogleFonts.dmSans(
                                  fontSize: 17,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          : SizedBox(),
                    ),
                    SizedBox(height: 20),
                    Divider(color: Colors.grey[300]),

                    // Nutritions
                    Row(
                      children: [
                        Text(
                          "Nutritions",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        Container(
                          height: 20,
                          width: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            "100gr",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        Icon(Icons.keyboard_arrow_down),
                      ],
                    ),
                    SizedBox(height: 20),
                    Divider(color: Colors.grey[300]),

                    // Reviews
                    Row(
                      children: [
                        Text(
                          "Review",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        Row(
                          children: List.generate(
                            5,
                            (index) => Icon(Icons.star, color: Colors.orange),
                          ),
                        ),
                        SizedBox(width: 5),
                        Icon(Icons.keyboard_arrow_down),
                      ],
                    ),
                    SizedBox(height: 30),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          final provider = context.read<ProductProvider>();
                          provider.addToCart(product.id);
                          provider.increaseQuantity(product.id);

                          setState(() => _addtoCart = true);

                          Future.delayed(Duration(milliseconds: 500), () {
                            setState(() => _addtoCart = false);
                          });
                        },
                        child: Container(
                          height: 70,
                          width: double.infinity,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: _addtoCart
                              ? Icon(Icons.check, color: Colors.white, size: 32)
                              : Text(
                                  "Add To Cart",
                                  style: GoogleFonts.dmSans(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
