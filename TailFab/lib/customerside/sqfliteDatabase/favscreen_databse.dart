import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
class FavoritesDatabaseHelper {
  static final FavoritesDatabaseHelper _instance = FavoritesDatabaseHelper._internal();
  static Database? _database;

  FavoritesDatabaseHelper._internal();

  factory FavoritesDatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'favorites.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    // Tailors Favorites Table
    await db.execute('''
      CREATE TABLE favorite_tailors(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        rating REAL,
        reviews INTEGER,
        image TEXT,
        category TEXT,
        distance TEXT,
        is_open INTEGER DEFAULT 1,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Fabrics Favorites Table
    await db.execute('''
      CREATE TABLE favorite_fabrics(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        price INTEGER,
        image TEXT,
        category TEXT,
        material TEXT,
        in_stock INTEGER DEFAULT 1,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Insert sample data if empty
    await _insertSampleData(db);
  }

  Future<void> _insertSampleData(Database db) async {
    // Check if data already exists
    final existingTailors = await db.query('favorite_tailors');
    final existingFabrics = await db.query('favorite_fabrics');
    
    if (existingTailors.isEmpty) {
      // Insert sample tailors
      final sampleTailors = [
        {
          'name': 'Fashion Hub', 'rating': 4.8, 'reviews': 245, 
          'image': 'https://images.unsplash.com/photo-1556906781-9a412961c28c?w=500',
          'category': 'Fashion', 'distance': '2.5 km', 'is_open': 1,
        },
        {
          'name': 'Style Studio', 'rating': 4.7, 'reviews': 189, 
          'image': 'https://images.unsplash.com/photo-1558769132-cb1aea3c1eff?w=500',
          'category': 'Lifestyle', 'distance': '3.2 km', 'is_open': 1,
        },
        {
          'name': 'Elite Boutique', 'rating': 4.9, 'reviews': 312, 
          'image': 'https://images.unsplash.com/photo-1567401893414-76b7b1e5a7a5?w=500',
          'category': 'Luxury', 'distance': '4.1 km', 'is_open': 0,
        },
      ];

      for (var tailor in sampleTailors) {
        await db.insert('favorite_tailors', tailor);
      }
    }

    if (existingFabrics.isEmpty) {
      // Insert sample fabrics
      final sampleFabrics = [
        {
          'name': 'Premium Cotton Shirt', 'price': 899, 
          'image': 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=500',
          'category': 'Men', 'material': 'Cotton', 'in_stock': 1,
        },
        {
          'name': 'Silk Kurta Material', 'price': 1599, 
          'image': 'https://images.unsplash.com/photo-1583743814966-8936f5b7be1a?w=500',
          'category': 'Men', 'material': 'Silk', 'in_stock': 1,
        },
        {
          'name': 'Girls Frock Material', 'price': 699, 
          'image': 'https://images.unsplash.com/photo-1518831959646-742c3a14ebf7?w=500',
          'category': 'Kids', 'material': 'Cotton Blend', 'in_stock': 0,
        },
        {
          'name': 'Designer Saree Fabric', 'price': 2499, 
          'image': 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=500',
          'category': 'Women', 'material': 'Silk', 'in_stock': 1,
        },
      ];

      for (var fabric in sampleFabrics) {
        await db.insert('favorite_fabrics', fabric);
      }
    }
  }

  // Tailors CRUD Operations
  Future<List<Map<String, dynamic>>> getFavoriteTailors() async {
    final db = await database;
    return await db.query('favorite_tailors', orderBy: 'created_at DESC');
  }

  Future<int> addFavoriteTailor(Map<String, dynamic> tailor) async {
    final db = await database;
    return await db.insert('favorite_tailors', tailor);
  }

  Future<int> removeFavoriteTailor(int id) async {
    final db = await database;
    return await db.delete(
      'favorite_tailors',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<bool> isTailorFavorite(String name) async {
    final db = await database;
    final result = await db.query(
      'favorite_tailors',
      where: 'name = ?',
      whereArgs: [name],
    );
    return result.isNotEmpty;
  }

  // Fabrics CRUD Operations
  Future<List<Map<String, dynamic>>> getFavoriteFabrics() async {
    final db = await database;
    return await db.query('favorite_fabrics', orderBy: 'created_at DESC');
  }

  Future<int> addFavoriteFabric(Map<String, dynamic> fabric) async {
    final db = await database;
    return await db.insert('favorite_fabrics', fabric);
  }

  Future<int> removeFavoriteFabric(int id) async {
    final db = await database;
    return await db.delete(
      'favorite_fabrics',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<bool> isFabricFavorite(String name) async {
    final db = await database;
    final result = await db.query(
      'favorite_fabrics',
      where: 'name = ?',
      whereArgs: [name],
    );
    return result.isNotEmpty;
  }

  // Clear all favorites
  Future<void> clearAllFavorites() async {
    final db = await database;
    await db.delete('favorite_tailors');
    await db.delete('favorite_fabrics');
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}