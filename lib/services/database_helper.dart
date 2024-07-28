import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:assessment/model/product_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'shop.db');

    return await openDatabase(
      path,
      version: 2, // Increment the version
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE products(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        price REAL,
        description TEXT,
        qty INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE personal_info(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        phone TEXT,
        email TEXT,
        address TEXT
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE personal_info(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          phone TEXT,
          email TEXT,
          address TEXT
        )
      ''');
    }
  }

  Future<void> insertProduct(Product product) async {
    final db = await database;
    await db.insert('products', product.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateProduct(Product product) async {
    final db = await database;
    await db.update('products', product.toMap(),
        where: 'id = ?', whereArgs: [product.id]);
  }

  Future<void> deleteProduct(int id) async {
    final db = await database;
    await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Product>> getProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('products');
    return List.generate(maps.length, (i) {
      return Product(
        id: maps[i]['id'],
        name: maps[i]['name'],
        price: maps[i]['price'],
        description: maps[i]['description'],
        qty: maps[i]['qty'],
      );
    });
  }

  Future<void> insertPersonalInfo(
      String name, String phone, String email, String address) async {
    final db = await database;
    await db.insert('personal_info', {
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
    });
  }

  Future<Map<String, String>> getPersonalInfo() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('personal_info');
    if (maps.isNotEmpty) {
      return {
        'name': maps[0]['name'],
        'phone': maps[0]['phone'],
        'email': maps[0]['email'],
        'address': maps[0]['address'],
      };
    }
    return {};
  }
}
