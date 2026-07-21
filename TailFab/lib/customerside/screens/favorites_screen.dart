import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/gradient_scaffold.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  final List<Map<String, dynamic>> favoriteTailors = [
    {
      'name': 'Fashion Hub', 'rating': 4.8, 'reviews': 245, 'image': 'https://images.unsplash.com/photo-1556906781-9a412961c28c?w=500',
      'category': 'Fashion', 'distance': '2.5 km', 'isOpen': true,
    },
    {
      'name': 'Style Studio', 'rating': 4.7, 'reviews': 189, 'image': 'https://images.unsplash.com/photo-1558769132-cb1aea3c1eff?w=500',
      'category': 'Lifestyle', 'distance': '3.2 km', 'isOpen': true,
    },
    {
      'name': 'Elite Boutique', 'rating': 4.9, 'reviews': 312, 'image': 'https://images.unsplash.com/photo-1567401893414-76b7b1e5a7a5?w=500',
      'category': 'Luxury', 'distance': '4.1 km', 'isOpen': false,
    },
  ];

  final List<Map<String, dynamic>> favoriteFabrics = [
    {
      'name': 'Premium Cotton Shirt', 'price': 899, 'image': 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=500',
      'category': 'Men', 'material': 'Cotton', 'inStock': true,
    },
    {
      'name': 'Silk Kurta Material', 'price': 1599, 'image': 'https://images.unsplash.com/photo-1583743814966-8936f5b7be1a?w=500',
      'category': 'Men', 'material': 'Silk', 'inStock': true,
    },
    {
      'name': 'Girls Frock Material', 'price': 699, 'image': 'https://images.unsplash.com/photo-1518831959646-742c3a14ebf7?w=500',
      'category': 'Kids', 'material': 'Cotton Blend', 'inStock': false,
    },
    {
      'name': 'Designer Saree Fabric', 'price': 2499, 'image': 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=500',
      'category': 'Women', 'material': 'Silk', 'inStock': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        title: Text('My Favorites', style: GoogleFonts.poppins(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            color: Colors.transparent,
            child: TabBar(
              controller: _tabController,
              labelColor: const Color.fromARGB(255, 253, 253, 255),
              unselectedLabelColor: Colors.grey[300],
              indicatorColor: const Color(0xFF8075FF),
              indicatorWeight: 3,
              labelStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
              unselectedLabelStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
              tabs: const [Tab(text: 'Tailors'), Tab(text: 'Fabrics')],
            ),
          ),
        ),
      ),
      child: TabBarView(
        controller: _tabController,
        children: [_buildTailorsTab(), _buildFabricsTab()],
      ),
    );
  }

  Widget _buildTailorsTab() {
    if (favoriteTailors.isEmpty) return _buildEmptyState(icon: Icons.store_outlined, title: 'No Favorite Tailors', subtitle: 'Start adding tailors to your favorites');
    return ListView.builder(padding: const EdgeInsets.all(16), itemCount: favoriteTailors.length, itemBuilder: (context, index) => _buildTailorCard(favoriteTailors[index], index));
  }

  Widget _buildTailorCard(Map<String, dynamic> tailor, int index) {
    return Dismissible(
      key: Key('tailor_$index'),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) { setState(() => favoriteTailors.removeAt(index)); _showSnackBar('${tailor['name']} removed from favorites'); },
      background: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(16)),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white, size: 28),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 15, offset: const Offset(0, 4))],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => _showSnackBar('Opening ${tailor['name']}'),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF667EEA).withOpacity(0.2), width: 2),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        tailor['image'], fit: BoxFit.cover,
                        errorBuilder: (context, error, stack) => Container(color: Colors.grey[200], child: const Icon(Icons.store, color: Colors.grey, size: 30)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text(tailor['name'], style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87), maxLines: 1, overflow: TextOverflow.ellipsis)),
                            IconButton(
                              icon: const Icon(Icons.favorite, color: Colors.red, size: 24),
                              onPressed: () { setState(() => favoriteTailors.removeAt(index)); _showSnackBar('${tailor['name']} removed from favorites'); },
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: Colors.amber.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                              child: Row(children: [const Icon(Icons.star, color: Colors.amber, size: 14), const SizedBox(width: 4), Text('${tailor['rating']}', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.amber.shade800))]),
                            ),
                            const SizedBox(width: 8),
                            Text('${tailor['reviews']} reviews', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(color: const Color(0xFF667EEA).withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                              child: Text(tailor['category'], style: GoogleFonts.poppins(fontSize: 10, color: const Color(0xFF667EEA), fontWeight: FontWeight.w500)),
                            ),
                            const Spacer(),
                            Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(tailor['distance'], style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[600])),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(width: 8, height: 8, decoration: BoxDecoration(color: tailor['isOpen'] ? Colors.green : Colors.red, shape: BoxShape.circle)),
                            const SizedBox(width: 6),
                            Text(tailor['isOpen'] ? 'Open now' : 'Closed', style: GoogleFonts.poppins(fontSize: 12, color: tailor['isOpen'] ? Colors.green.shade600 : Colors.red.shade600, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFabricsTab() {
    if (favoriteFabrics.isEmpty) return _buildEmptyState(icon: Icons.checkroom_outlined, title: 'No Favorite Fabrics', subtitle: 'Start adding fabrics to your favorites');
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.72,
       crossAxisSpacing: 12, 
      mainAxisSpacing: 12),
      itemCount: favoriteFabrics.length,
      itemBuilder: (context, index) => _buildFabricCard(favoriteFabrics[index], index),
    );
  }

  Widget _buildFabricCard(Map<String, dynamic> fabric, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  fabric['image'], height: 140, width: double.infinity, fit: BoxFit.cover,
                  errorBuilder: (context, error, stack) => Container(height: 140, color: Colors.grey[200], 
                  child: const Icon(Icons.image, size: 40, color: Colors.grey)),
                ),
              ),
              Container(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () { setState(() => favoriteFabrics.removeAt(index)); _showSnackBar('${fabric['name']} removed from favorites'); },
                    child: Container(padding: const EdgeInsets.all(6), decoration: const BoxDecoration(color: Colors.white,
                     shape: BoxShape.circle), child: const Icon(Icons.favorite, size: 18, color: Colors.red)),
                  ),
                ),
              ),
              if (!fabric['inStock'])
                Container(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(8)),
                      child: Text('Out of Stock', style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600,
                       color: Colors.white)),
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(fabric['name'], style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                 maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(fabric['material'], style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
                    const SizedBox(width: 4), Text('•', style: TextStyle(color: Colors.grey[400])), const SizedBox(width: 4),
                    Text(fabric['category'], style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('₹${fabric['price']}', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, 
                    color: const Color(0xFF667EEA))),
                    GestureDetector(
                      onTap: () => _showSnackBar(fabric['inStock'] ? 'Added to cart: ${fabric['name']}' : 'Item out of stock'),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: fabric['inStock'] ? const Color(0xFF667EEA).withOpacity(0.1) : Colors.grey.withOpacity(0.1), 
                        borderRadius: BorderRadius.circular(8)),
                        child: Icon(Icons.shopping_bag_outlined, size: 18, color: fabric['inStock'] ? const Color(0xFF667EEA) : Colors.grey),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({required IconData icon, required String title, required String subtitle}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 100, color: Colors.grey[300]),
          const SizedBox(height: 20),
          Text(title, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey[600])),
          const SizedBox(height: 8),
          Text(subtitle, style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[500])),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), behavior: SnackBarBehavior.floating, 
    duration: const Duration(seconds: 2), backgroundColor: const Color(0xFF667EEA)));
  }
}