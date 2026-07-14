import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import '../components/gradient_scaffold.dart';
import 'mens_screen.dart';
import 'womens_page.dart';
import 'kids_screen.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  String selectedFilter = 'All';
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<String> filters = ['All', 'Men', 'Women', 'Kids', 'Accessories'];

  final List<Map<String, dynamic>> categories = [
    {'name': 'Men\'s Fashion', 'icon': '👔', 'color': Color(0xFF667EEA), 'items': 245, 'subcategories': ['Shirts', 'Pants', 'Kurtas', 'Suits', 'Blazers', 'T-Shirts'], 'filter': 'Men'},
    {'name': 'Women\'s Fashion', 'icon': '👗', 'color': Color(0xFFEC4899), 'items': 389, 'subcategories': ['Sarees', 'Kurtis', 'Lehengas', 'Dresses', 'Tops', 'Gowns'], 'filter': 'Women'},
    {'name': 'Kids Wear', 'icon': '🧸', 'color': Color(0xFFFF9800), 'items': 167, 'subcategories': ['Boys', 'Girls', 'Ethnic', 'Party Wear', 'Casual', 'School Uniform'], 'filter': 'Kids'},
    {'name': 'Traditional Wear', 'icon': '🎎', 'color': Color(0xFF8B5CF6), 'items': 198, 'subcategories': ['Kurta Pajama', 'Sherwani', 'Dhoti', 'Traditional Dress', 'Ethnic Gowns'], 'filter': 'All'},
    {'name': 'Formal Wear', 'icon': '🤵', 'color': Color(0xFF059669), 'items': 156, 'subcategories': ['Business Suits', 'Formal Shirts', 'Blazers', 'Trousers', 'Waistcoats'], 'filter': 'Men'},
    {'name': 'Party & Wedding', 'icon': '💍', 'color': Color(0xFFDC2626), 'items': 234, 'subcategories': ['Wedding Dress', 'Party Gowns', 'Cocktail Dress', 'Designer Wear'], 'filter': 'Women'},
    {'name': 'Casual Wear', 'icon': '👕', 'color': Color(0xFF0EA5E9), 'items': 312, 'subcategories': ['T-Shirts', 'Jeans', 'Casual Shirts', 'Shorts', 'Casual Dress'], 'filter': 'All'},
    {'name': 'Sports & Active', 'icon': '⚽', 'color': Color(0xFFF59E0B), 'items': 89, 'subcategories': ['Sports Wear', 'Gym Wear', 'Track Pants', 'Sports T-Shirts', 'Jerseys'], 'filter': 'All'},
    {'name': 'Ethnic Wear', 'icon': '🪔', 'color': Color(0xFFDB2777), 'items': 267, 'subcategories': ['Salwar Kameez', 'Anarkali', 'Palazzo', 'Dupatta', 'Ethnic Sets'], 'filter': 'Women'},
    {'name': 'Winter Collection', 'icon': '🧥', 'color': Color(0xFF6366F1), 'items': 145, 'subcategories': ['Jackets', 'Sweaters', 'Hoodies', 'Coats', 'Shawls', 'Mufflers'], 'filter': 'All'},
    {'name': 'Summer Collection', 'icon': '🌞', 'color': Color(0xFFFBBF24), 'items': 201, 'subcategories': ['Cotton Wear', 'Linen Shirts', 'Summer Dress', 'Shorts', 'Tank Tops'], 'filter': 'All'},
    {'name': 'Accessories', 'icon': '👜', 'color': Color(0xFF10B981), 'items': 178, 'subcategories': ['Bags', 'Belts', 'Scarves', 'Ties', 'Bow Ties', 'Pocket Squares'], 'filter': 'Accessories'},
    {'name': 'Fabric Collection', 'icon': '🧵', 'color': Color(0xFF14B8A6), 'items': 423, 'subcategories': ['Cotton', 'Silk', 'Linen', 'Wool', 'Polyester', 'Denim'], 'filter': 'All'},
    {'name': 'Designer Wear', 'icon': '✨', 'color': Color(0xFFA855F7), 'items': 98, 'subcategories': ['Designer Sarees', 'Designer Suits', 'Designer Gowns', 'Custom Design'], 'filter': 'Women'},
    {'name': 'Festive Collection', 'icon': '🎊', 'color': Color(0xFFEF4444), 'items': 189, 'subcategories': ['Diwali Special', 'Eid Collection', 'Christmas Wear', 'New Year'], 'filter': 'All'},
    {'name': 'Office Wear', 'icon': '💼', 'color': Color(0xFF64748B), 'items': 134, 'subcategories': ['Formal Shirts', 'Formal Pants', 'Office Sarees', 'Formal Suits'], 'filter': 'All'},
  ];

  List<Map<String, dynamic>> get filteredCategories {
    if (selectedFilter == 'All') return categories;
    return categories.where((c) => c['filter'] == selectedFilter || c['filter'] == 'All').toList();
  }

  List<Map<String, dynamic>> get searchedCategories {
    if (_searchQuery.isEmpty) return filteredCategories;
    return filteredCategories.where((category) =>
        category['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
        (category['subcategories'] as List).any((sub) => sub.toLowerCase().contains(_searchQuery.toLowerCase()))
    ).toList();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 3))..repeat();
    _searchQuery = '';
    _searchController.clear();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        title: Text('Categories', style: GoogleFonts.poppins(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: Icon(Icons.search, color: Colors.white), onPressed: _showSearchBottomSheet),
          IconButton(icon: Icon(Icons.filter_list, color: Colors.white), onPressed: _showFilterBottomSheet),
        ],
      ),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: SizedBox(height: 40)),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(children: filters.map((filter) => _buildFilterChip(filter)).toList()),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
               childAspectRatio: 0.85, crossAxisSpacing: 12, mainAxisSpacing: 12),
              delegate: SliverChildBuilderDelegate((context, index) => _buildCategoryCard(searchedCategories[index], index),
               childCount: searchedCategories.length),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String filter) {
    bool isSelected = selectedFilter == filter;
    return GestureDetector(
      onTap: () => setState(() => selectedFilter = filter),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        margin: EdgeInsets.only(right: 8),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF667EEA) : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected ? [BoxShadow(color: Color(0xFF667EEA).withOpacity(0.3),
          blurRadius: 8, offset: Offset(0, 4))] : [],
        ),
        child: Text(filter, style: GoogleFonts.poppins(color: isSelected ? Colors.white : Colors.black54, 
        fontWeight: FontWeight.w600,  fontSize: 14)),
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category, int index) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, math.sin(_animationController.value * 2 * math.pi + index * 0.5) * 2),
          child: GestureDetector(
            onTap: () => _showCategoryDetails(category),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: category['color'].withOpacity(0.15), blurRadius: 15, offset: Offset(0, 8))],
              ),
              child: Stack(
                children: [
                  Align(alignment: Alignment.centerRight, child: Container(width: 100, height: 100, 
                  decoration: BoxDecoration(shape: BoxShape.circle, color: category['color'].withOpacity(0.1)))),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 60, height: 60,
                          decoration: BoxDecoration(color: category['color'].withOpacity(0.15), borderRadius: BorderRadius.circular(15)),
                          child: Center(child: Text(category['icon'], style: TextStyle(fontSize: 32))),
                        ),
                        SizedBox(height: 12),
                        Text(category['name'], style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87), maxLines: 2, overflow: TextOverflow.ellipsis),
                        SizedBox(height: 6),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: category['color'].withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                          child: Text('${category['items']} items', style: GoogleFonts.poppins(fontSize: 12, 
                          fontWeight: FontWeight.w600, color: category['color'])),
                        ),
                        Spacer(),
                        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(color: category['color'], borderRadius: BorderRadius.circular(10)),
                            child: Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                          ),
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showCategoryDetails(Map<String, dynamic> category) {
    showModalBottomSheet(
      context: context, backgroundColor: Colors.transparent, isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(25),
         topRight: Radius.circular(25))),
        child: Column(
          children: [
            Container(margin: EdgeInsets.only(top: 12, bottom: 8), width: 40, height: 4, 
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  IconButton(icon: Icon(Icons.arrow_back, color: Colors.black87), onPressed: () => Navigator.pop(context)),
                  SizedBox(width: 8),
                  Container(
                    width: 60, height: 60,
                    decoration: BoxDecoration(color: category['color'].withOpacity(0.15), borderRadius: BorderRadius.circular(15)),
                    child: Center(child: Text(category['icon'], style: TextStyle(fontSize: 32))),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(category['name'], style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                        Text('${category['items']} items available', style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600])),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(20),
                itemCount: category['subcategories'].length,
                itemBuilder: (context, index) {
                  final subcategory = category['subcategories'][index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(12), 
                    border: Border.all(color: Colors.grey[200]!)),
                    child: ListTile(
                      leading: Container(padding: EdgeInsets.all(8), decoration: BoxDecoration(color: category['color'].withOpacity(0.1),
                       borderRadius: BorderRadius.circular(8)), child: Icon(Icons.category, color: category['color'], size: 20)),
                      title: Text(subcategory, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, 
                      color: Colors.black87)),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
                      onTap: () {
                        Navigator.pop(context);
                        _navigateToSubcategoryProducts(category, subcategory);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToSubcategoryProducts(Map<String, dynamic> category, String subcategory) {
    switch (category['filter']) {
      case 'Men': Navigator.push(context, MaterialPageRoute(builder: (context) => MensPage(initialCategory: category['name'], 
      initialSubcategory: subcategory))); break;
      case 'Women': Navigator.push(context, MaterialPageRoute(builder: (context) => WomensPage(initialCategory: category['name'], 
      initialSubcategory: subcategory))); break;
      case 'Kids': Navigator.push(context, MaterialPageRoute(builder: (context) => KidsPage(initialCategory: category['name'],
       initialSubcategory: subcategory))); break;
      default: _showSnackBar('Opening $subcategory from ${category['name']}'); break;
    }
  }

  void _showSearchBottomSheet() {
    showModalBottomSheet(
      context: context, backgroundColor: Colors.transparent, isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(25), 
          topRight: Radius.circular(25))),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], 
                borderRadius: BorderRadius.circular(2))),
                SizedBox(height: 20),
                Row(
                  children: [
                    IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
                    Expanded(
                      child: TextField(
                        controller: _searchController, autofocus: true,
                        onChanged: (value) => setState(() => _searchQuery = value),
                        decoration: InputDecoration(
                          hintText: 'Search categories...', prefixIcon: Icon(Icons.search),
                          suffixIcon: _searchQuery.isNotEmpty ? IconButton(icon: Icon(Icons.clear), 
                          onPressed: () { _searchController.clear(); setState(() => _searchQuery = ''); }) : null,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)), filled: true, 
                          fillColor: Colors.grey[50],
                        ),
                      ),
                    ),
                  ],
                ),
                if (_searchQuery.isNotEmpty) ...[
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true, itemCount: searchedCategories.length,
                      itemBuilder: (context, index) {
                        final category = searchedCategories[index];
                        return ListTile(leading: Text(category['icon']), title: Text(category['name']), 
                        onTap: () { Navigator.pop(context); _showCategoryDetails(category); });
                      },
                    ),
                  ),
                ],
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context, backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(25),
         topRight: Radius.circular(25))),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], 
              borderRadius: BorderRadius.circular(2))),
              SizedBox(height: 20),
              Row(children: [IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)), 
              Text('Filter Categories', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold))]),
              SizedBox(height: 20),
              ...filters.map((filter) => _buildFilterOption(filter)).toList(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterOption(String filter) {
    bool isSelected = selectedFilter == filter;
    return GestureDetector(
      onTap: () { setState(() => selectedFilter = filter); Navigator.pop(context); },
      child: Container(
        margin: EdgeInsets.only(bottom: 12), padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF667EEA).withOpacity(0.1) : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? Color(0xFF667EEA) : Colors.grey[200]!, width: 2),
        ),
        child: Row(
          children: [
            Icon(isSelected ? Icons.check_circle : Icons.circle_outlined, color: isSelected ? Color(0xFF667EEA) : Colors.grey[400]),
            SizedBox(width: 12),
            Text(filter, style: GoogleFonts.poppins(fontSize: 16, 
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500, color: isSelected ? Color(0xFF667EEA) : Colors.black87)),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), behavior: SnackBarBehavior.floating, 
    duration: Duration(seconds: 2), backgroundColor: Color(0xFF667EEA)));
  }
}