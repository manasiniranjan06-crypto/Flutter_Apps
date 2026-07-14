// database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TailorDatabaseHelper {
  static final TailorDatabaseHelper _instance = TailorDatabaseHelper._internal();
  factory TailorDatabaseHelper() => _instance;
  TailorDatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'tailor_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    // Tailor Profile Table
    await db.execute('''
      CREATE TABLE tailor_profile(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        shop_name TEXT,
        owner_name TEXT,
        email TEXT,
        phone TEXT,
        address TEXT,
        experience TEXT,
        specialization TEXT,
        description TEXT,
        working_hours TEXT,
        rating REAL DEFAULT 0.0,
        total_orders INTEGER DEFAULT 0,
        pending_orders INTEGER DEFAULT 0,
        completed_orders INTEGER DEFAULT 0,
        is_shop_open INTEGER DEFAULT 1,
        shop_logo_path TEXT,
        created_at TEXT,
        updated_at TEXT
      )
    ''');

    // Shop Images Table
    await db.execute('''
      CREATE TABLE shop_images(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        image_path TEXT NOT NULL,
        created_at TEXT
      )
    ''');

    // Services Table
    await db.execute('''
      CREATE TABLE services(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        price_range TEXT,
        delivery_time TEXT,
        created_at TEXT
      )
    ''');

    // Insert default services
    await _insertDefaultServices(db);
  }

  Future<void> _insertDefaultServices(Database db) async {
    final defaultServices = [
      {
        'name': 'Shirt Stitching',
        'price_range': '₹500 - ₹1500',
        'delivery_time': '3-5 days',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Pant Stitching',
        'price_range': '₹400 - ₹1200',
        'delivery_time': '2-4 days',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Suits',
        'price_range': '₹2000 - ₹8000',
        'delivery_time': '5-7 days',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Blouse',
        'price_range': '₹300 - ₹1000',
        'delivery_time': '2-3 days',
        'created_at': DateTime.now().toIso8601String(),
      },
    ];

    for (var service in defaultServices) {
      await db.insert('services', service);
    }
  }

  // Tailor Profile Methods
  Future<int> insertTailorProfile(Map<String, dynamic> profile) async {
    final db = await database;
    profile['created_at'] = DateTime.now().toIso8601String();
    profile['updated_at'] = DateTime.now().toIso8601String();
    return await db.insert('tailor_profile', profile);
  }

  Future<Map<String, dynamic>?> getTailorProfile() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tailor_profile',
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return maps.first;
  }

  Future<int> updateTailorProfile(Map<String, dynamic> profile) async {
    final db = await database;
    profile['updated_at'] = DateTime.now().toIso8601String();
    return await db.update(
      'tailor_profile',
      profile,
      where: 'id = ?',
      whereArgs: [profile['id']],
    );
  }

  Future<int> updateTailorProfileField(String field, dynamic value) async {
    final db = await database;
    final currentProfile = await getTailorProfile();
    if (currentProfile != null) {
      return await db.update(
        'tailor_profile',
        {
          field: value,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [currentProfile['id']],
      );
    }
    return 0;
  }

  // Shop Images Methods
  Future<int> insertShopImage(String imagePath) async {
    final db = await database;
    return await db.insert('shop_images', {
      'image_path': imagePath,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<List<String>> getShopImages() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'shop_images',
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => map['image_path'] as String).toList();
  }

  Future<int> deleteShopImage(int id) async {
    final db = await database;
    return await db.delete(
      'shop_images',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteShopImageByPath(String imagePath) async {
    final db = await database;
    return await db.delete(
      'shop_images',
      where: 'image_path = ?',
      whereArgs: [imagePath],
    );
  }

  // Services Methods
  Future<List<Map<String, dynamic>>> getServices() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'services',
      orderBy: 'created_at DESC',
    );
    return maps;
  }

  Future<int> insertService(Map<String, dynamic> service) async {
    final db = await database;
    service['created_at'] = DateTime.now().toIso8601String();
    return await db.insert('services', service);
  }

  Future<int> updateService(Map<String, dynamic> service) async {
    final db = await database;
    return await db.update(
      'services',
      service,
      where: 'id = ?',
      whereArgs: [service['id']],
    );
  }

  Future<int> deleteService(int id) async {
    final db = await database;
    return await db.delete(
      'services',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Statistics Methods
  Future<int> updateOrderStatistics({
    int? totalOrders,
    int? pendingOrders,
    int? completedOrders,
  }) async {
    final db = await database;
    final currentProfile = await getTailorProfile();
    if (currentProfile != null) {
      final updates = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };
      
      if (totalOrders != null) updates['total_orders'] = totalOrders;
      if (pendingOrders != null) updates['pending_orders'] = pendingOrders;
      if (completedOrders != null) updates['completed_orders'] = completedOrders;

      return await db.update(
        'tailor_profile',
        updates,
        where: 'id = ?',
        whereArgs: [currentProfile['id']],
      );
    }
    return 0;
  }

  // Clear all data (for logout)
  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('tailor_profile');
    await db.delete('shop_images');
    // Don't delete services as they are default
  }

  // Initialize default profile if none exists
  Future<void> initializeDefaultProfile() async {
    final profile = await getTailorProfile();
    if (profile == null) {
      await insertTailorProfile({
        'shop_name': '',
        'owner_name': '',
        'email': '',
        'phone': '',
        'address': '',
        'experience': '',
        'specialization': '',
        'description': '',
        'working_hours': '9:00 AM - 7:00 PM',
        'rating': 0.0,
        'total_orders': 0,
        'pending_orders': 0,
        'completed_orders': 0,
        'is_shop_open': 1,
        'shop_logo_path': '',
      });
    }
  }
}