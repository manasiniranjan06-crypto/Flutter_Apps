// lib/database/order_tracking_database.dart
import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class OrderTrackingDatabase {
  static final OrderTrackingDatabase _instance = OrderTrackingDatabase._internal();
  factory OrderTrackingDatabase() => _instance;
  OrderTrackingDatabase._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'order_tracking.db');
    log('📁 Order Tracking Database Path: $path');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    log('🔄 Creating order_tracking database tables...');
    
    await db.execute('''
      CREATE TABLE order_tracking(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        orderId TEXT NOT NULL UNIQUE,
        currentStep INTEGER NOT NULL DEFAULT 0,
        progress REAL NOT NULL DEFAULT 0,
        lastUpdated TEXT NOT NULL,
        trackingData TEXT NOT NULL
      )
    ''');
    
    log('✅ Order tracking database created successfully');
  }

  // Insert or update order tracking
  Future<int> upsertOrderTracking(Map<String, dynamic> tracking) async {
    final db = await database;
    
    // Check if order already exists
    final existing = await db.query(
      'order_tracking',
      where: 'orderId = ?',
      whereArgs: [tracking['orderId']],
    );
    
    if (existing.isEmpty) {
      log('📝 Inserting new order tracking for: ${tracking['orderId']}');
      final result = await db.insert('order_tracking', tracking);
      log('✅ New order tracking inserted with ID: $result');
      return result;
    } else {
      log('🔄 Updating existing order tracking for: ${tracking['orderId']}');
      final result = await db.update(
        'order_tracking',
        tracking,
        where: 'orderId = ?',
        whereArgs: [tracking['orderId']],
      );
      log('✅ Order tracking updated, affected rows: $result');
      return result;
    }
  }

  // Get order tracking by order ID
  Future<Map<String, dynamic>?> getOrderTracking(String orderId) async {
    final db = await database;
    log('🔍 Fetching order tracking for: $orderId');
    
    final result = await db.query(
      'order_tracking',
      where: 'orderId = ?',
      whereArgs: [orderId],
    );
    
    if (result.isNotEmpty) {
      log('✅ Found order tracking data');
      return result.first;
    } else {
      log('❌ No tracking data found for order: $orderId');
      return null;
    }
  }

  // Update order progress
  Future<int> updateOrderProgress(String orderId, double progress, int currentStep) async {
    final db = await database;
    log('🔄 Updating progress for $orderId: $progress%, step: $currentStep');
    
    final result = await db.update(
      'order_tracking',
      {
        'progress': progress,
        'currentStep': currentStep,
        'lastUpdated': DateTime.now().toIso8601String(),
      },
      where: 'orderId = ?',
      whereArgs: [orderId],
    );
    
    log('✅ Progress updated, affected rows: $result');
    return result;
  }

  // Update current step
  Future<int> updateCurrentStep(String orderId, int currentStep) async {
    final db = await database;
    log('🔄 Updating current step for $orderId: $currentStep');
    
    final result = await db.update(
      'order_tracking',
      {
        'currentStep': currentStep,
        'lastUpdated': DateTime.now().toIso8601String(),
      },
      where: 'orderId = ?',
      whereArgs: [orderId],
    );
    
    log('✅ Current step updated, affected rows: $result');
    return result;
  }

  // Get all order trackings
  Future<List<Map<String, dynamic>>> getAllOrderTrackings() async {
    final db = await database;
    log('🔍 Fetching all order trackings...');
    
    final result = await db.query('order_tracking', orderBy: 'lastUpdated DESC');
    log('✅ Found ${result.length} order trackings');
    
    return result;
  }

  // Delete order tracking
  Future<int> deleteOrderTracking(String orderId) async {
    final db = await database;
    log('🗑️ Deleting order tracking for: $orderId');
    
    final result = await db.delete(
      'order_tracking',
      where: 'orderId = ?',
      whereArgs: [orderId],
    );
    
    log('✅ Order tracking deleted, affected rows: $result');
    return result;
  }

  // Initialize with sample tracking data
  Future<void> initializeSampleTrackingData() async {
    final db = await database;
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM order_tracking')
    );
    
    if (count == 0) {
      log('📝 Initializing sample tracking data...');
      
      final sampleTrackings = [
        {
          'orderId': 'ORD-2024-1234',
          'currentStep': 2,
          'progress': 0.6,
          'lastUpdated': DateTime.now().toIso8601String(),
          'trackingData': _getDefaultTrackingData(0.6),
        },
        {
          'orderId': 'ORD-2024-1233',
          'currentStep': 1,
          'progress': 0.2,
          'lastUpdated': DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
          'trackingData': _getDefaultTrackingData(0.2),
        },
        {
          'orderId': 'ORD-2024-1232',
          'currentStep': 5,
          'progress': 1.0,
          'lastUpdated': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
          'trackingData': _getDefaultTrackingData(1.0),
        },
      ];

      for (var tracking in sampleTrackings) {
        await db.insert('order_tracking', tracking);
      }
      
      log('✅ Sample tracking data initialized with ${sampleTrackings.length} records');
    } else {
      log('ℹ️ Sample tracking data already exists with $count records');
    }
  }

  String _getDefaultTrackingData(double progress) {
    return '''
    {
      "steps": [
        {
          "title": "Order Accepted",
          "subtitle": "Your order has been accepted by the tailor",
          "icon": "check_circle",
          "completed": true,
          "active": ${progress < 0.25},
          "description": "Tailor has reviewed and accepted your order requirements."
        },
        {
          "title": "Fabric Cut & Prepared",
          "subtitle": "Fabric cutting and preparation in progress",
          "icon": "content_cut",
          "completed": ${progress >= 0.25},
          "active": ${progress >= 0.25 && progress < 0.5},
          "description": "Fabric is being cut according to your measurements."
        },
        {
          "title": "Stitching Started",
          "subtitle": "Tailor has started stitching your garment",
          "icon": "carpenter",
          "completed": ${progress >= 0.5},
          "active": ${progress >= 0.5 && progress < 0.7},
          "description": "Main stitching work is in progress with attention to detail."
        },
        {
          "title": "Final Finishing",
          "subtitle": "Quality check and finishing touches",
          "icon": "auto_fix_high",
          "completed": ${progress >= 0.7},
          "active": ${progress >= 0.7 && progress < 0.9},
          "description": "Final touches, button work, and quality inspection."
        },
        {
          "title": "Ready for Delivery",
          "subtitle": "Your order is ready for pickup/delivery",
          "icon": "inventory_2",
          "completed": ${progress >= 0.9},
          "active": ${progress >= 0.9 && progress < 1.0},
          "description": "Your garment is ready! You can pick it up or we will deliver."
        },
        {
          "title": "Delivered",
          "subtitle": "Order successfully delivered",
          "icon": "home",
          "completed": ${progress >= 1.0},
          "active": false,
          "description": "Order has been delivered successfully. Thank you!"
        }
      ]
    }
    ''';
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
    log('🔒 Order tracking database closed');
  }
}