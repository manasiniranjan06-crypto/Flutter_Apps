// lib/database/order_database.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';


class OrderDatabase {
  static final OrderDatabase _instance = OrderDatabase._internal();
  factory OrderDatabase() => _instance;
  OrderDatabase._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'orders.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE orders(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        orderId TEXT NOT NULL UNIQUE,
        tailorName TEXT NOT NULL,
        tailorImage TEXT NOT NULL,
        itemName TEXT NOT NULL,
        itemImage TEXT NOT NULL,
        status TEXT NOT NULL,
        orderDate TEXT NOT NULL,
        deliveryDate TEXT,
        cancelDate TEXT,
        price REAL NOT NULL,
        quantity INTEGER NOT NULL,
        measurements INTEGER NOT NULL DEFAULT 0,
        progress REAL DEFAULT 0,
        rated INTEGER DEFAULT 0,
        rating REAL DEFAULT 0,
        reason TEXT,
        createdAt TEXT NOT NULL
      )
    ''');
  }

  // Insert an order
  Future<int> insertOrder(Map<String, dynamic> order) async {
    final db = await database;
    return await db.insert('orders', order);
  }

  // Get orders by status
  Future<List<Map<String, dynamic>>> getOrdersByStatus(String status) async {
    final db = await database;
    return await db.query(
      'orders',
      where: 'status = ?',
      whereArgs: [status],
      orderBy: 'id DESC',
    );
  }

  // Get all active orders (Pending, In Progress, Ready)
  Future<List<Map<String, dynamic>>> getActiveOrders() async {
    final db = await database;
    return await db.rawQuery('''
      SELECT * FROM orders 
      WHERE status IN ('Pending', 'In Progress', 'Ready')
      ORDER BY id DESC
    ''');
  }

  // Get all completed orders
  Future<List<Map<String, dynamic>>> getCompletedOrders() async {
    final db = await database;
    return await db.query(
      'orders',
      where: 'status = ?',
      whereArgs: ['Delivered'],
      orderBy: 'id DESC',
    );
  }

  // Get all cancelled orders
  Future<List<Map<String, dynamic>>> getCancelledOrders() async {
    final db = await database;
    return await db.query(
      'orders',
      where: 'status = ?',
      whereArgs: ['Cancelled'],
      orderBy: 'id DESC',
    );
  }

  // Update order status
  Future<int> updateOrderStatus(String orderId, String status) async {
    final db = await database;
    return await db.update(
      'orders',
      {'status': status},
      where: 'orderId = ?',
      whereArgs: [orderId],
    );
  }

  // Cancel order
  Future<int> cancelOrder(String orderId, String reason) async {
    final db = await database;
    return await db.update(
      'orders',
      {
        'status': 'Cancelled',
        'cancelDate': DateTime.now().toIso8601String(),
        'reason': reason,
      },
      where: 'orderId = ?',
      whereArgs: [orderId],
    );
  }

  // Rate order
  Future<int> rateOrder(String orderId, double rating) async {
    final db = await database;
    return await db.update(
      'orders',
      {
        'rated': 1,
        'rating': rating,
      },
      where: 'orderId = ?',
      whereArgs: [orderId],
    );
  }

  // Update order progress
  Future<int> updateOrderProgress(String orderId, double progress) async {
    final db = await database;
    return await db.update(
      'orders',
      {'progress': progress},
      where: 'orderId = ?',
      whereArgs: [orderId],
    );
  }

  // Search orders
  Future<List<Map<String, dynamic>>> searchOrders(String query) async {
    final db = await database;
    return await db.rawQuery('''
      SELECT * FROM orders 
      WHERE orderId LIKE ? OR itemName LIKE ? OR tailorName LIKE ?
      ORDER BY id DESC
    ''', ['%$query%', '%$query%', '%$query%']);
  }

  // Delete order
  Future<int> deleteOrder(String orderId) async {
    final db = await database;
    return await db.delete(
      'orders',
      where: 'orderId = ?',
      whereArgs: [orderId],
    );
  }

  // Initialize with sample data
  Future<void> initializeSampleData() async {
    final db = await database;
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM orders')
    );
    
    if (count == 0) {
      final sampleOrders = [
        {
          'orderId': 'ORD-2024-1234',
          'tailorName': 'Fashion Hub',
          'tailorImage': 'https://images.unsplash.com/photo-1556906781-9a412961c28c?w=500',
          'itemName': 'Custom Suit',
          'itemImage': 'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?w=500',
          'status': 'In Progress',
          'orderDate': '10 Oct 2024',
          'deliveryDate': '20 Oct 2024',
          'price': 2499.0,
          'quantity': 1,
          'measurements': 1,
          'progress': 0.6,
          'rated': 0,
          'createdAt': DateTime.now().toIso8601String(),
        },
        {
          'orderId': 'ORD-2024-1233',
          'tailorName': 'Style Studio',
          'tailorImage': 'https://images.unsplash.com/photo-1558769132-cb1aea3c1eff?w=500',
          'itemName': 'Designer Kurta',
          'itemImage': 'https://images.unsplash.com/photo-1583743814966-8936f5b7be1a?w=500',
          'status': 'Pending',
          'orderDate': '09 Oct 2024',
          'deliveryDate': '19 Oct 2024',
          'price': 1899.0,
          'quantity': 2,
          'measurements': 1,
          'progress': 0.2,
          'rated': 0,
          'createdAt': DateTime.now().subtract(const Duration(hours: 1)).toIso8601String(),
        },
        {
          'orderId': 'ORD-2024-1232',
          'tailorName': 'Elite Boutique',
          'tailorImage': 'https://images.unsplash.com/photo-1567401893414-76b7b1e5a7a5?w=500',
          'itemName': 'Wedding Dress',
          'itemImage': 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=500',
          'status': 'Ready',
          'orderDate': '05 Oct 2024',
          'deliveryDate': '11 Oct 2024',
          'price': 4999.0,
          'quantity': 1,
          'measurements': 1,
          'progress': 1.0,
          'rated': 0,
          'createdAt': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
        },
        {
          'orderId': 'ORD-2024-1231',
          'tailorName': 'Fashion Hub',
          'tailorImage': 'https://images.unsplash.com/photo-1556906781-9a412961c28c?w=500',
          'itemName': 'Cotton Shirt',
          'itemImage': 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=500',
          'status': 'Delivered',
          'orderDate': '25 Sep 2024',
          'deliveryDate': '05 Oct 2024',
          'price': 899.0,
          'quantity': 3,
          'measurements': 1,
          'rated': 1,
          'rating': 4.5,
          'createdAt': DateTime.now().subtract(const Duration(days: 5)).toIso8601String(),
        },
        {
          'orderId': 'ORD-2024-1230',
          'tailorName': 'Style Studio',
          'tailorImage': 'https://images.unsplash.com/photo-1558769132-cb1aea3c1eff?w=500',
          'itemName': 'Party Gown',
          'itemImage': 'https://images.unsplash.com/photo-1566174053879-31528523f8ae?w=500',
          'status': 'Delivered',
          'orderDate': '15 Sep 2024',
          'deliveryDate': '28 Sep 2024',
          'price': 3499.0,
          'quantity': 1,
          'measurements': 1,
          'rated': 0,
          'createdAt': DateTime.now().subtract(const Duration(days: 10)).toIso8601String(),
        },
        {
          'orderId': 'ORD-2024-1229',
          'tailorName': 'Trend Setters',
          'tailorImage': 'https://images.unsplash.com/photo-1441984904996-e0b6ba687e04?w=500',
          'itemName': 'Denim Jacket',
          'itemImage': 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=500',
          'status': 'Cancelled',
          'orderDate': '20 Sep 2024',
          'cancelDate': '22 Sep 2024',
          'price': 1599.0,
          'quantity': 1,
          'measurements': 1,
          'reason': 'Changed mind',
          'createdAt': DateTime.now().subtract(const Duration(days: 8)).toIso8601String(),
        },
      ];

      for (var order in sampleOrders) {
        await db.insert('orders', order);
      }
    }
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}