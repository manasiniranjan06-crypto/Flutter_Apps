// lib/database/notification_database.dart
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NotificationDatabase {
  static final NotificationDatabase _instance = NotificationDatabase._internal();
  factory NotificationDatabase() => _instance;
  NotificationDatabase._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'notifications.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notifications(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        message TEXT NOT NULL,
        time TEXT NOT NULL,
        icon INTEGER NOT NULL,
        color INTEGER NOT NULL,
        isRead INTEGER NOT NULL DEFAULT 0,
        createdAt TEXT NOT NULL
      )
    ''');
  }

  // Insert a notification
  Future<int> insertNotification(Map<String, dynamic> notification) async {
    final db = await database;
    return await db.insert('notifications', notification);
  }

  // Get all notifications
  Future<List<Map<String, dynamic>>> getNotifications() async {
    final db = await database;
    return await db.query('notifications', orderBy: 'id DESC');
  }

  // Mark notification as read
  Future<int> markAsRead(int id) async {
    final db = await database;
    return await db.update(
      'notifications',
      {'isRead': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Mark all notifications as read
  Future<int> markAllAsRead() async {
    final db = await database;
    return await db.update(
      'notifications',
      {'isRead': 1},
    );
  }

  // Delete a notification
  Future<int> deleteNotification(int id) async {
    final db = await database;
    return await db.delete(
      'notifications',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Get unread notifications count
  Future<int> getUnreadCount() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM notifications WHERE isRead = 0'
    );
    return result.first['count'] as int;
  }

  // Initialize with sample data
  Future<void> initializeSampleData() async {
    final db = await database;
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM notifications')
    );
    
    if (count == 0) {
      final sampleNotifications = [
        {
          'title': 'Order Ready for Pickup',
          'message': 'Your order #1234 is ready for pickup from Fashion Hub',
          'time': '2 min ago',
          'icon': Icons.check_circle.codePoint,
          'color': Colors.green.value,
          'isRead': 0,
          'createdAt': DateTime.now().toIso8601String(),
        },
        {
          'title': 'New Discount Available',
          'message': 'Get 20% off on all silk fabrics this weekend',
          'time': '1 hour ago',
          'icon': Icons.local_offer.codePoint,
          'color': Colors.orange.value,
          'isRead': 0,
          'createdAt': DateTime.now().subtract(const Duration(hours: 1)).toIso8601String(),
        },
        {
          'title': 'Measurement Updated',
          'message': 'Your shirt measurements have been updated successfully',
          'time': '3 hours ago',
          'icon': Icons.straighten.codePoint,
          'color': Colors.blue.value,
          'isRead': 1,
          'createdAt': DateTime.now().subtract(const Duration(hours: 3)).toIso8601String(),
        },
        {
          'title': 'Order In Progress',
          'message': 'Style Studio has started working on your order #1233',
          'time': '5 hours ago',
          'icon': Icons.construction.codePoint,
          'color': Colors.purple.value,
          'isRead': 1,
          'createdAt': DateTime.now().subtract(const Duration(hours: 5)).toIso8601String(),
        },
        {
          'title': 'Payment Successful',
          'message': 'Payment of ₹1,299 received successfully',
          'time': '1 day ago',
          'icon': Icons.payment.codePoint,
          'color': Colors.teal.value,
          'isRead': 1,
          'createdAt': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
        },
      ];

      for (var notification in sampleNotifications) {
        await db.insert('notifications', notification);
      }
    }
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}