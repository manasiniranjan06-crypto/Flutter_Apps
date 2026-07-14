import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/Screens/controller/product_provider_controller.dart';
import 'package:grocery_app/Screens/model/Product_model.dart';
import 'package:grocery_app/Screens/view/product_detail_page.dart';
import 'package:provider/provider.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  TextEditingController searchController = TextEditingController();
  List<ProductModel> displayProduct = List.from(allProducts);

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      context.read<ProductProvider>().searchProduct(searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    log("in homescreen build0");
     final productProvider = context.watch<ProductProvider>();
  final productsToShow = productProvider.products;


    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Location
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset("assets/loginpg.png", height: 40, width: 40),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.location_on, color: Colors.blueGrey),
                          Text(
                            "Pune, Maharashtra",
                            style: GoogleFonts.dmSans(
                              fontSize: 20,
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Search bar
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "Search Store",
                      prefixIcon: Icon(Icons.search, color: Colors.black),
                      suffixIcon: searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.close, color: Colors.black),
                              onPressed: () {
                                searchController.clear();
                                FocusScope.of(context).unfocus();
                               
                                context.read<ProductProvider>().searchProduct('');
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: Color(0xFFDCDCDE),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 0),
                ],
              ),
            ),

            // Search results or main content
            Expanded(
              child: searchController.text.isNotEmpty
                  ? productsToShow.isEmpty
                        ? Center(
                            child: Text(
                              "No Products Found",
                              style: GoogleFonts.dmSans(
                                fontSize: 20,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : GridView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                  childAspectRatio: 0.78,
                                ),
                            itemCount: productsToShow.length,
                            itemBuilder: (context, index) {
                              final product = productsToShow[index];
                              return productCard(product);
                            },
                          )
                  : ListView(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        SizedBox(height: 10),
                        bannerSection(),
                        SizedBox(height: 20),
                        sectionTitle("Exclusive Offer"),
                        SizedBox(height: 10),
                        horizontalProductList(
                          allProducts
                              .where((p) => p.category == "Fruits")
                              .toList(),
                        ),
                        SizedBox(height: 20),
                        sectionTitle("Best Selling"),
                        SizedBox(height: 10),
                        horizontalProductList(
                          allProducts
                              .where((p) => p.category == "Vegetables")
                              .toList(),
                        ),
                        SizedBox(height: 20),
                        sectionTitle("Groceries"),
                        SizedBox(height: 10),
                        pulses(),
                        SizedBox(height: 10),
                        horizontalProductList(
                          allProducts
                              .where(
                                (p) =>
                                    p.category != "Fruits" &&
                                    p.category != "Vegetables",
                              )
                              .toList(),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Section title row
  Widget sectionTitle(String title) {
    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.dmSans(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Spacer(),
        Text(
          "See all",
          style: GoogleFonts.dmSans(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  // Banner section
  Widget bannerSection() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          bannerImage("assets/banner.png"),
          SizedBox(width: 10),
          bannerImage("assets/banner.png"),
        ],
      ),
    );
  }

  Widget bannerImage(String imagePath) {
    return Container(
      height: 100,
      width: 350,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.green,
      ),
      child: Image.asset(imagePath, fit: BoxFit.cover),
    );
  }

  // Horizontal scrollable product list
  Widget horizontalProductList(List<ProductModel> products) {
    return SizedBox(
      height: 220,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        separatorBuilder: (_, __) => SizedBox(width: 10),
        itemBuilder: (context, index) {
          final product = products[index];
          return productCard(product);
        },
      ),
    );
  }

  // Product card widget
  Widget productCard(ProductModel product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailPage(product: product),
          ),
        );
      },
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300),
        ),
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.asset(product.image, height: 80, width: 80)),
            SizedBox(height: 10),
            Text(
              product.name,
              style: GoogleFonts.dmSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              product.unit,
              style: GoogleFonts.dmSans(fontSize: 16, color: Colors.grey),
            ),
            Spacer(),
            Row(
              children: [
                Text(
                  "₹ ${product.price}",
                  style: GoogleFonts.dmSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                Container(
                  height: 34,
                  width: 34,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //pulses
  Widget pulses() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Container(
            height: 80,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              //rgba(248, 164, 76, 1)
              color: const Color.fromARGB(248, 255, 230, 208),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Image.asset("assets/pluses.png", height: 60, width: 60),
                  SizedBox(width: 6),
                  Text(
                    "Pulses",
                    style: GoogleFonts.dmSans(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 10),
          //rice
          Container(
            height: 80,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              //rgba(248, 164, 76, 1)
              color: const Color.fromARGB(255, 211, 252, 213),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Image.asset("assets/rice.png", height: 60, width: 60),
                  SizedBox(width: 6),
                  Text(
                    "Pulses",
                    style: GoogleFonts.dmSans(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
