import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLHelper {
  // **Membuka Database**
  static Future<Database> _database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'notes_database.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notes(
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            title TEXT, 
            description TEXT, 
            note TEXT
          )
        ''');
      },
      version: 1,
    );
  }

  // **Insert Data (Create)**
  static Future<int> createItem(
      String title, String description, String note) async {
    final db = await _database();
    return await db.insert(
      'notes',
      {'title': title, 'description': description, 'note': note},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // **Read Data**
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await _database();
    return db.query('notes', orderBy: "id DESC");
  }

  // **Update Data**
  static Future<int> updateItem(
      int id, String title, String description, String note) async {
    final db = await _database();
    return await db.update(
      'notes',
      {'title': title, 'description': description, 'note': note},
      where: "id = ?",
      whereArgs: [id],
    );
  }

  // **Delete Data**
  static Future<void> deleteItem(int id) async {
    final db = await _database();
    await db.delete(
      'notes',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
