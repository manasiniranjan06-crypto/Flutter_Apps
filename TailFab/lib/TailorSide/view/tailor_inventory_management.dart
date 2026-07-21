// inventory_management_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InventoryManagementScreen extends StatefulWidget {
  const InventoryManagementScreen({Key? key}) : super(key: key);

  @override
  State<InventoryManagementScreen> createState() => _InventoryManagementScreenState();
}

class _InventoryManagementScreenState extends State<InventoryManagementScreen> {
  final List<InventoryItem> _inventoryItems = [
    InventoryItem(
      id: '1',
      name: 'Cotton White Fabric',
      category: 'Fabric',
      quantity: 25.5,
      unit: 'meters',
      minStock: 10.0,
      price: 120.0,
      supplier: 'Textile Mart',
      lastUpdated: DateTime.now().subtract(const Duration(days: 2)),
    ),
    InventoryItem(
      id: '2',
      name: 'Silk Red Fabric',
      category: 'Fabric',
      quantity: 8.0,
      unit: 'meters',
      minStock: 5.0,
      price: 450.0,
      supplier: 'Premium Silks',
      lastUpdated: DateTime.now().subtract(const Duration(days: 5)),
    ),
    InventoryItem(
      id: '3',
      name: 'Thread - White',
      category: 'Thread',
      quantity: 15.0,
      unit: 'spools',
      minStock: 20.0,
      price: 25.0,
      supplier: 'Sewing Supplies',
      lastUpdated: DateTime.now().subtract(const Duration(days: 1)),
    ),
    InventoryItem(
      id: '4',
      name: 'Buttons - Medium',
      category: 'Accessories',
      quantity: 200.0,
      unit: 'pieces',
      minStock: 100.0,
      price: 2.5,
      supplier: 'Button World',
      lastUpdated: DateTime.now().subtract(const Duration(days: 7)),
    ),
    InventoryItem(
      id: '5',
      name: 'Zippers - 12 inch',
      category: 'Accessories',
      quantity: 35.0,
      unit: 'pieces',
      minStock: 25.0,
      price: 15.0,
      supplier: 'Zip It',
      lastUpdated: DateTime.now().subtract(const Duration(days: 3)),
    ),
    InventoryItem(
      id: '6',
      name: 'Lining Fabric',
      category: 'Fabric',
      quantity: 12.0,
      unit: 'meters',
      minStock: 8.0,
      price: 85.0,
      supplier: 'Textile Mart',
      lastUpdated: DateTime.now().subtract(const Duration(days: 10)),
    ),
  ];

  final List<String> _categories = ['All', 'Fabric', 'Thread', 'Accessories', 'Tools', 'Other'];
  String _selectedCategory = 'All';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredItems = _getFilteredItems();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Inventory Management',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF6A5ACD),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => _showAddItemDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.analytics, color: Colors.white),
            onPressed: () => _showInventoryAnalytics(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Section
          _buildSearchFilterSection(),
          
          // Inventory Summary Cards
          _buildInventorySummary(),
          
          // Inventory List
          Expanded(
            child: _buildInventoryList(filteredItems),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddItemDialog(context),
        backgroundColor: const Color(0xFF6A5ACD),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSearchFilterSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          // Search Bar
          TextField(
            decoration: InputDecoration(
              hintText: 'Search inventory...',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
          const SizedBox(height: 12),
          
          // Category Filter Chips
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(category),
                    selected: _selectedCategory == category,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = selected ? category : 'All';
                      });
                    },
                    backgroundColor: Colors.grey[200],
                    selectedColor: const Color(0xFF6A5ACD).withOpacity(0.2),
                    checkmarkColor: const Color(0xFF6A5ACD),
                    labelStyle: TextStyle(
                      color: _selectedCategory == category 
                          ? const Color(0xFF6A5ACD) 
                          : Colors.grey[700],
                      fontWeight: _selectedCategory == category 
                          ? FontWeight.bold 
                          : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInventorySummary() {
    final lowStockItems = _inventoryItems.where((item) => item.quantity <= item.minStock).length;
    final totalItems = _inventoryItems.length;
    final totalValue = _inventoryItems.fold(0.0, (sum, item) => sum + (item.quantity * item.price));

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.transparent,
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              'Total Items',
              totalItems.toString(),
              Icons.inventory_2,
              const Color(0xFF6A5ACD),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              'Low Stock',
              lowStockItems.toString(),
              Icons.warning,
              Colors.orange,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              'Total Value',
              '₹${totalValue.toStringAsFixed(0)}',
              Icons.attach_money,
              Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryList(List<InventoryItem> items) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 80,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              'No items found',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _selectedCategory == 'All' 
                  ? 'Add some items to your inventory'
                  : 'No items in selectedCategory category',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildInventoryItemCard(item);
      },
    );
  }

  Widget _buildInventoryItemCard(InventoryItem item) {
    final isLowStock = item.quantity <= item.minStock;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: _getCategoryColor(item.category).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getCategoryIcon(item.category),
            color: _getCategoryColor(item.category),
            size: 24,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                item.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            if (isLowStock)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: Text(
                  'Low Stock',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.orange[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                _buildInfoChip(item.category, Icons.category),
                const SizedBox(width: 6),
                _buildInfoChip('${item.quantity} ${item.unit}', Icons.scale),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '₹${item.price.toStringAsFixed(2)}/${item.unit}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
                Text(
                  'Min: ${item.minStock}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Supplier: ${item.supplier}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.grey),
          onSelected: (value) => _handleItemAction(value, item),
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'edit', child: Text('Edit Item')),
            const PopupMenuItem(value: 'update_stock', child: Text('Update Stock')),
            const PopupMenuItem(value: 'delete', child: Text('Delete Item')),
          ],
        ),
        onTap: () => _showItemDetails(context, item),
      ),
    );
  }

  Widget _buildInfoChip(String text, IconData icon) {
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
            text,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  List<InventoryItem> _getFilteredItems() {
    var filtered = _inventoryItems;

    // Filter by category
    if (_selectedCategory != 'All') {
      filtered = filtered.where((item) => item.category == _selectedCategory).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((item) =>
          item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.category.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.supplier.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }

    return filtered;
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'fabric':
        return const Color(0xFF6A5ACD);
      case 'thread':
        return Colors.blue;
      case 'accessories':
        return Colors.green;
      case 'tools':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'fabric':
        return Icons.bolt;
      case 'thread':
        return Icons.linear_scale;
      case 'accessories':
        return Icons.settings;
      case 'tools':
        return Icons.build;
      default:
        return Icons.inventory_2;
    }
  }

  void _handleItemAction(String action, InventoryItem item) {
    switch (action) {
      case 'edit':
        _showEditItemDialog(context, item);
        break;
      case 'update_stock':
        _showUpdateStockDialog(context, item);
        break;
      case 'delete':
        _showDeleteConfirmation(context, item);
        break;
    }
  }

  // Dialog Methods
  void _showAddItemDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => InventoryItemDialog(
        onSave: (item) {
          // Add to inventory
          setState(() {
            _inventoryItems.add(item);
          });
          _showSnackBar(context, 'Item added successfully');
        },
      ),
    );
  }

  void _showEditItemDialog(BuildContext context, InventoryItem item) {
    showDialog(
      context: context,
      builder: (context) => InventoryItemDialog(
        item: item,
        onSave: (updatedItem) {
          // Update item
          setState(() {
            final index = _inventoryItems.indexWhere((i) => i.id == item.id);
            if (index != -1) {
              _inventoryItems[index] = updatedItem;
            }
          });
          _showSnackBar(context, 'Item updated successfully');
        },
      ),
    );
  }

  void _showUpdateStockDialog(BuildContext context, InventoryItem item) {
    final quantityController = TextEditingController(text: item.quantity.toString());
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Stock'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              item.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: quantityController,
              decoration: InputDecoration(
                labelText: 'Quantity (${item.unit})',
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newQuantity = double.tryParse(quantityController.text);
              if (newQuantity != null && newQuantity >= 0) {
                setState(() {
                  final index = _inventoryItems.indexWhere((i) => i.id == item.id);
                  if (index != -1) {
                    _inventoryItems[index] = item.copyWith(quantity: newQuantity);
                  }
                });
                Navigator.pop(context);
                _showSnackBar(context, 'Stock updated successfully');
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, InventoryItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: Text('Are you sure you want to delete "${item.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _inventoryItems.removeWhere((i) => i.id == item.id);
              });
              Navigator.pop(context);
              _showSnackBar(context, 'Item deleted successfully');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showItemDetails(BuildContext context, InventoryItem item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 60,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(item.category).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getCategoryIcon(item.category),
                    color: _getCategoryColor(item.category),
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        item.category,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildDetailRow('Quantity', '${item.quantity} ${item.unit}'),
            _buildDetailRow('Minimum Stock', '${item.minStock} ${item.unit}'),
            _buildDetailRow('Price', '₹${item.price}/${item.unit}'),
            _buildDetailRow('Supplier', item.supplier),
            _buildDetailRow('Last Updated', 
              '${item.lastUpdated.day}/${item.lastUpdated.month}/${item.lastUpdated.year}'),
            const SizedBox(height: 24),
            if (item.quantity <= item.minStock)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange[700]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Low stock alert! Reorder soon.',
                        style: TextStyle(
                          color: Colors.orange[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showUpdateStockDialog(context, item);
                    },
                    child: const Text('Update Stock'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showEditItemDialog(context, item);
                    },
                    child: const Text('Edit Item'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showInventoryAnalytics(BuildContext context) {
    // Implement analytics screen
    _showSnackBar(context, 'Inventory Analytics');
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF6A5ACD),
      ),
    );
  }
}

// Inventory Item Dialog
class InventoryItemDialog extends StatefulWidget {
  final InventoryItem? item;
  final Function(InventoryItem) onSave;

  const InventoryItemDialog({
    Key? key,
    this.item,
    required this.onSave,
  }) : super(key: key);

  @override
  State<InventoryItemDialog> createState() => _InventoryItemDialogState();
}

class _InventoryItemDialogState extends State<InventoryItemDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _quantityController = TextEditingController();
  final _unitController = TextEditingController();
  final _minStockController = TextEditingController();
  final _priceController = TextEditingController();
  final _supplierController = TextEditingController();

  final List<String> _categories = ['Fabric', 'Thread', 'Accessories', 'Tools', 'Other'];
  final List<String> _units = ['meters', 'pieces', 'spools', 'rolls', 'kg', 'packs'];

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _nameController.text = widget.item!.name;
      _categoryController.text = widget.item!.category;
      _quantityController.text = widget.item!.quantity.toString();
      _unitController.text = widget.item!.unit;
      _minStockController.text = widget.item!.minStock.toString();
      _priceController.text = widget.item!.price.toString();
      _supplierController.text = widget.item!.supplier;
    } else {
      _unitController.text = 'meters';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.item == null ? 'Add New Item' : 'Edit Item'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Item Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter item name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _categoryController.text.isEmpty ? null : _categoryController.text,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _categoryController.text = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select category';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _quantityController,
                      decoration: const InputDecoration(
                        labelText: 'Quantity',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter quantity';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Enter valid number';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      value: _unitController.text,
                      decoration: const InputDecoration(
                        labelText: 'Unit',
                        border: OutlineInputBorder(),
                      ),
                      items: _units.map((unit) {
                        return DropdownMenuItem(
                          value: unit,
                          child: Text(unit),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _unitController.text = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _minStockController,
                decoration: const InputDecoration(
                  labelText: 'Minimum Stock',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter minimum stock';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Enter valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Price per Unit',
                  prefixText: '₹',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Enter valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _supplierController,
                decoration: const InputDecoration(
                  labelText: 'Supplier',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter supplier';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveItem,
          child: const Text('Save'),
        ),
      ],
    );
  }

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      final item = InventoryItem(
        id: widget.item?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        category: _categoryController.text,
        quantity: double.parse(_quantityController.text),
        unit: _unitController.text,
        minStock: double.parse(_minStockController.text),
        price: double.parse(_priceController.text),
        supplier: _supplierController.text,
        lastUpdated: DateTime.now(),
      );

      widget.onSave(item);
      Navigator.pop(context);
    }
  }
}

// Inventory Item Model
class InventoryItem {
  final String id;
  final String name;
  final String category;
  final double quantity;
  final String unit;
  final double minStock;
  final double price;
  final String supplier;
  final DateTime lastUpdated;

  InventoryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.unit,
    required this.minStock,
    required this.price,
    required this.supplier,
    required this.lastUpdated,
  });

  InventoryItem copyWith({
    String? name,
    String? category,
    double? quantity,
    String? unit,
    double? minStock,
    double? price,
    String? supplier,
  }) {
    return InventoryItem(
      id: id,
      name: name ?? this.name,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      minStock: minStock ?? this.minStock,
      price: price ?? this.price,
      supplier: supplier ?? this.supplier,
      lastUpdated: DateTime.now(),
    );
  }
}