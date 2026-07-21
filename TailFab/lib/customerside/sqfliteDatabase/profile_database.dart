import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'tailfair.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    // Tailor Profile Table
    await db.execute('''
      CREATE TABLE tailor_profiles(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        image TEXT,
        rating REAL,
        reviews INTEGER,
        followers TEXT,
        experience TEXT,
        specialization TEXT,
        location TEXT,
        open_time TEXT,
        phone TEXT,
        description TEXT,
        is_following INTEGER DEFAULT 0,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Services Table
    await db.execute('''
      CREATE TABLE services(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tailor_id INTEGER,
        name TEXT NOT NULL,
        price INTEGER,
        duration TEXT,
        icon_code INTEGER,
        is_available INTEGER DEFAULT 1,
        FOREIGN KEY (tailor_id) REFERENCES tailor_profiles (id)
      )
    ''');

    // Portfolio Table
    await db.execute('''
      CREATE TABLE portfolio(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tailor_id INTEGER,
        image TEXT,
        title TEXT,
        FOREIGN KEY (tailor_id) REFERENCES tailor_profiles (id)
      )
    ''');

    // Reviews Table
    await db.execute('''
      CREATE TABLE reviews(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tailor_id INTEGER,
        customer_name TEXT,
        rating REAL,
        date TEXT,
        comment TEXT,
        avatar TEXT,
        FOREIGN KEY (tailor_id) REFERENCES tailor_profiles (id)
      )
    ''');

    // Insert sample data
    await _insertSampleData(db);
  }

  Future<void> _insertSampleData(Database db) async {
    // Check if data already exists
    final existingProfiles = await db.query('tailor_profiles');
    if (existingProfiles.isNotEmpty) return;

    // Insert tailor profile
    final tailorId = await db.insert('tailor_profiles', {
      'name': 'Fashion Hub',
      'image': 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?w=500',
      'rating': 4.8,
      'reviews': 342,
      'followers': '1.2K',
      'experience': '15 Years',
      'specialization': 'Custom Suits & Wedding Wear',
      'location': '2.5 km away',
      'open_time': '10:00 AM - 8:00 PM',
      'phone': '+91 9876543210',
      'description': 'Expert tailor specializing in premium custom suits, wedding wear, and ethnic clothing. We pride ourselves on precision, quality craftsmanship, and personalized service for every customer.',
    });

    // Insert services
    final services = [
      {'name': 'Custom Suit', 'price': 2999, 'duration': '7-10 days', 'icon_code': Icons.checkroom.codePoint},
      {'name': 'Shirt Stitching', 'price': 499, 'duration': '3-5 days', 'icon_code': Icons.style.codePoint},
      {'name': 'Pant Alterations', 'price': 299, 'duration': '2-3 days', 'icon_code': Icons.content_cut.codePoint},
      {'name': 'Wedding Sherwani', 'price': 4999, 'duration': '15-20 days', 'icon_code': Icons.celebration.codePoint},
      {'name': 'Kurta Pajama', 'price': 1299, 'duration': '5-7 days', 'icon_code': Icons.dashboard_customize.codePoint},
      {'name': 'Dress Alteration', 'price': 399, 'duration': '2-4 days', 'icon_code': Icons.edit.codePoint},
    ];

    for (var service in services) {
      await db.insert('services', {
        'tailor_id': tailorId,
        ...service,
      });
    }

    // Insert portfolio
    final portfolio = [
      {'image': 'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?w=400', 'title': 'Wedding Suit'},
      {'image': 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?w=400', 'title': 'Formal Wear'},
      {'image': 'https://images.unsplash.com/photo-1617127365659-c47fa864d8bc?w=400', 'title': 'Ethnic Design'},
      {'image': 'https://images.unsplash.com/photo-1598808503491-f1504b4b3448?w=400', 'title': 'Custom Blazer'},
      {'image': 'https://images.unsplash.com/photo-1620799140408-edc6dcb6d633?w=400', 'title': 'Party Wear'},
      {'image': 'https://images.unsplash.com/photo-1594938291221-94f18cbb5660?w=400', 'title': 'Traditional'},
    ];

    for (var item in portfolio) {
      await db.insert('portfolio', {
        'tailor_id': tailorId,
        ...item,
      });
    }

    // Insert reviews
    final reviews = [
      {'customer_name': 'Rahul Sharma', 'rating': 5.0, 'date': '2 days ago', 'comment': 'Excellent work! Perfect fit and amazing quality. Highly recommended for custom suits.', 'avatar': 'R'},
      {'customer_name': 'Priya Patel', 'rating': 4.5, 'date': '1 week ago', 'comment': 'Great experience. The tailor understood exactly what I wanted and delivered on time.', 'avatar': 'P'},
      {'customer_name': 'Amit Kumar', 'rating': 5.0, 'date': '2 weeks ago', 'comment': 'Best tailor in the area. The attention to detail is remarkable. Will definitely come again.', 'avatar': 'A'},
    ];

    for (var review in reviews) {
      await db.insert('reviews', {
        'tailor_id': tailorId,
        ...review,
      });
    }
  }

  // CRUD Operations for Tailor Profile
  Future<Map<String, dynamic>?> getTailorProfile(int id) async {
    final db = await database;
    final profiles = await db.query(
      'tailor_profiles',
      where: 'id = ?',
      whereArgs: [id],
    );
    return profiles.isNotEmpty ? profiles.first : null;
  }

  Future<int> updateFollowingStatus(int id, bool isFollowing) async {
    final db = await database;
    return await db.update(
      'tailor_profiles',
      {'is_following': isFollowing ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Services Operations
  Future<List<Map<String, dynamic>>> getServices(int tailorId) async {
    final db = await database;
    return await db.query(
      'services',
      where: 'tailor_id = ?',
      whereArgs: [tailorId],
    );
  }

  // Portfolio Operations
  Future<List<Map<String, dynamic>>> getPortfolio(int tailorId) async {
    final db = await database;
    return await db.query(
      'portfolio',
      where: 'tailor_id = ?',
      whereArgs: [tailorId],
    );
  }

  // Reviews Operations
  Future<List<Map<String, dynamic>>> getReviews(int tailorId) async {
    final db = await database;
    return await db.query(
      'reviews',
      where: 'tailor_id = ?',
      whereArgs: [tailorId],
    );
  }

  // Add new review
  Future<int> addReview(Map<String, dynamic> review) async {
    final db = await database;
    return await db.insert('reviews', review);
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}