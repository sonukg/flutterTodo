// lib/database.dart
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TodoDatabase {
  static final TodoDatabase instance = TodoDatabase._init();
  static Database? _database;

  TodoDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('todos.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
    CREATE TABLE todos (
      id $idType,
      description $textType
    )
    ''');
  }

  Future<void> create(String description) async {
    final db = await instance.database;

    await db.insert(
      'todos',
      {'description': description},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> readAll() async {
    final db = await instance.database;

    return await db.query('todos');
  }
  Future<void> delete(int id) async {
    final db = await instance.database;

    await db.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /*Future<int> delete(int id) async {
    final db = await database;

    // Debug Log
    print("Attempting to delete todo with ID: $id");

    int rowsDeleted = await db.delete(
      'todos', // Make sure your table name is correct
      where: 'id = ?',
      whereArgs: [id],
    );

    print("Rows deleted: $rowsDeleted");

    return rowsDeleted;
  }*/

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
