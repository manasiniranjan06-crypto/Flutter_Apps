import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/Screens/model/Product_model.dart';
import 'package:grocery_app/Screens/view/Breverages.dart';

class ExploreProduct extends StatefulWidget {
  const ExploreProduct({super.key});

  @override
  State<ExploreProduct> createState() => _ExploreProductState();
}

class _ExploreProductState extends State<ExploreProduct> {
  final TextEditingController searchController = TextEditingController();
  bool isSelected = false;
  bool _isfilterApplied = false;
  Set<String> selectedCategories = {};
  Set<String> selectedBrands = {};

  List<ProductModel> displayProduct = List.from(allProducts);

  @override
  void initState() {
    super.initState();
  }

  void searchFilter() {
    final query = searchController.text.trim().toLowerCase();

    setState(() {
      displayProduct = allProducts.where((p) {
        // ---- CATEGORY FILTER (OR logic) ----
        final matchesCategory =
            selectedCategories.isEmpty ||
            selectedCategories.any(
              (cat) => p.category.toLowerCase().contains(cat.toLowerCase()),
            );

        // ---- BRAND FILTER (null-safe OR logic) ----
        final matchesBrand =
            selectedBrands.isEmpty ||
            selectedBrands.any(
              (brnd) =>
                  (p.brand ?? '').toLowerCase().contains(brnd.toLowerCase()),
            );

        // ---- SEARCH FILTER ----
        final matchesSearch =
            query.isEmpty || p.name.toLowerCase().contains(query);

        // Product is visible if ALL applied filters match
        return matchesCategory && matchesBrand && matchesSearch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productToShow = (_isfilterApplied || searchController.text.isNotEmpty)
        ? displayProduct
        : allProducts;

    return WillPopScope(
      onWillPop: () async {
        if (_isfilterApplied || searchController.text.isNotEmpty) {
          setState(() {
            _isfilterApplied = false;
            searchController.clear();
            selectedBrands.clear();
            selectedCategories.clear();
            displayProduct = List.from(allProducts);
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "Find Products",
            style: GoogleFonts.dmSans(
              fontSize: 25,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                searchByFilters();
              },
              child: Image.asset("assets/productpge/range.png"),
            ),
            SizedBox(width: 15),
          ],
          centerTitle: true,
          shadowColor: Colors.white,
        ),

        backgroundColor: Colors.white,

        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              /// SEARCH BAR
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  fillColor: const Color.fromARGB(255, 219, 219, 219),
                  filled: true,
                  hintText: "Search Store",
                  prefixIcon: const Icon(Icons.search, color: Colors.black),

                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close, color: Colors.black),
                          onPressed: () {
                            searchController.clear();
                            FocusScope.of(context).unfocus();

                            setState(() {
                              _isfilterApplied = false;
                              selectedBrands.clear();
                              selectedCategories.clear();
                              displayProduct = List.from(allProducts);
                            });
                          },
                        )
                      : null,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (_) => searchFilter(),
              ),

              const SizedBox(height: 20),

              /// SHOW CATEGORIES
              if (!_isfilterApplied && searchController.text.isEmpty) ...[
                categoriesSection(),
                const SizedBox(height: 20),
              ]
              ///
              else ...[
                productGrid(productToShow),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // CATEGORY SECTION

  Widget categoriesSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ProductCategory(
              Colors.green.withOpacity(0.1),
              Colors.green,
              productImg: "assets/productpge/fruit&vege.png",
              productName: "Fresh Fruits \n& Vegetable",
            ),
            ProductCategory(
              Colors.orange.withOpacity(0.1),
              Colors.orange,
              productImg: "assets/productpge/oil.png",
              productName: "Cooking Oil \n& Ghee",
            ),
          ],
        ),

        const SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ProductCategory(
              Colors.red.withOpacity(0.1),
              Colors.red,
              productImg: "assets/productpge/meat.png",
              productName: "Meat & Fish",
            ),
            ProductCategory(
              Colors.purple.withOpacity(0.1),
              Colors.purple,
              productImg: "assets/productpge/backery.png",
              productName: "Bakery & Snacks",
            ),
          ],
        ),

        const SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ProductCategory(
              Colors.yellow.withOpacity(0.1),
              Colors.yellow,
              productImg: "assets/productpge/oil.png",
              productName: "Dairy & Eggs",
            ),

            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const Beverages()),
                );
              },
              child: ProductCategory(
                Colors.blue.withOpacity(0.1),
                Colors.blue,
                productImg: "assets/productpge/breverages.png",
                productName: "Beverages",
              ),
            ),
          ],
        ),
      ],
    );
  }

  //  GRID VIEW

  Widget productGrid(List<ProductModel> list) {
    if (list.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Text(
          "No Products Found",
          style: GoogleFonts.dmSans(fontSize: 20, color: Colors.grey),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),

      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.78,
      ),

      itemCount: list.length,
      itemBuilder: (context, index) => searchProductCard(list[index]),
    );
  }

  //  CATEGORY CARD

  Widget ProductCategory(
    Color boxColor,
    Color borderColor, {
    required String productImg,
    required String productName,
  }) {
    return Container(
      height: 200,
      width: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: boxColor,
        border: Border.all(color: borderColor),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(productImg),
          const SizedBox(height: 20),
          Text(
            productName,
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  //search product

  Widget searchProductCard(ProductModel p) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFC9C9C9)),
      ),
      padding: const EdgeInsets.all(10),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.asset(
              p.image,
              height: 100,
              width: 100,
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(height: 20),

          Text(
            p.name,
            style: GoogleFonts.dmSans(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(
            p.unit,
            style: GoogleFonts.dmSans(fontSize: 14, color: Colors.grey),
          ),

          const Spacer(),

          Row(
            children: [
              Text(
                "₹ ${p.price}",
                style: GoogleFonts.dmSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Spacer(),

              Container(
                height: 34,
                width: 34,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //search product by  applying filter
  void searchByFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ///  HEADER
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.close, color: Colors.black),
                      ),
                      const Spacer(),
                      Text(
                        "Filters",
                        style: GoogleFonts.dmSans(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// - FILTER BODY
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 240, 240, 240),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.all(16),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// - CATEGORIES -
                        Text(
                          "Categories",
                          style: GoogleFonts.dmSans(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 16),

                        filterOption("Eggs", isCategory: true),
                        const SizedBox(height: 12),

                        filterOption("Noodles & Pasta", isCategory: true),
                        const SizedBox(height: 12),

                        filterOption("Chips & Crisps", isCategory: true),
                        const SizedBox(height: 12),

                        filterOption("Fast Food", isCategory: true),

                        const SizedBox(height: 28),

                        /// -------- BRANDS --------
                        Text(
                          "Brand",
                          style: GoogleFonts.dmSans(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 16),

                        filterOption("Individual Collection"),
                        const SizedBox(height: 12),

                        filterOption("Coco Cola"),
                        const SizedBox(height: 12),

                        filterOption("Ifad"),
                        const SizedBox(height: 12),

                        filterOption("Kazi Farmas"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  ///  APPLY BUTTON
                  GestureDetector(
                    onTap: () {
                      _isfilterApplied = true;
                      searchFilter();
                      Navigator.pop(context);
                    },

                    child: Container(
                      height: 55,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Center(
                        child: Text(
                          "Apply Filter",
                          style: GoogleFonts.dmSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget filterOption(String label, {bool isCategory = false}) {
    final bool isChecked = isCategory
        ? selectedCategories.contains(label)
        : selectedBrands.contains(label);

    return Row(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              if (isCategory) {
                isChecked
                    ? selectedCategories.remove(label)
                    : selectedCategories.add(label);
              } else {
                isChecked
                    ? selectedBrands.remove(label)
                    : selectedBrands.add(label);
              }
            });
          },
          child: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey),
              color: isChecked ? Colors.green : Colors.transparent,
            ),
            child: isChecked
                ? const Icon(Icons.check, color: Colors.white, size: 18)
                : null,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: isChecked ? Colors.green : Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
