import 'package:ebook_app/src/book/book.dart';
import 'package:ebook_app/src/category/category.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqliteService {
  static const dbName = 'de_leon.db';

  Future<Database> initializeDB() async {
    return openDatabase(
      join(await getDatabasesPath(), SqliteService.dbName),
      onCreate: (database, version) {
        database.execute(
          'CREATE TABLE IF NOT EXISTS ${Category.modelName}(id INTEGER PRIMARY KEY AUTOINCREMENT, related_id INT NOT NULL UNIQUE, content_data TEXT NOT NULL)',
        );
        database.execute(
          'CREATE TABLE IF NOT EXISTS ${Book.modelName}(id INTEGER PRIMARY KEY AUTOINCREMENT, related_id INT NOT NULL UNIQUE, content_data TEXT NOT NULL)',
        );
      },
      version: 1,
    );
  }

  Future<int> saveItem(String table, Map<String, String> values) async {
    // Get a reference to the database.
    final db = await initializeDB();

    return db.insert(
      table,
      values,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<T>> getAllItems<T>(String table, {required T Function(dynamic) fromEntries}) async {
    // Get a reference to the database.
    final db = await initializeDB();

    final List<Map<String, dynamic>> queryResult = await db.query(table);

    return queryResult.map((e) => fromEntries(e)).toList();
  }

  Future<void> updateItem(String table, {required Map<String, String> values, String? where, List? whereArgs}) async {
    // Get a reference to the database.
    final db = await initializeDB();

    // Update the given Item.
    await db.update(
      table,
      values,
      where: where,
      whereArgs: whereArgs,
    );
  }

  Future<void> deleteItem(String table, {String? where, List? whereArgs}) async {
    // Get a reference to the database.
    final db = await initializeDB();

    // Remove the Item from the database.
    await db.delete(
      table,
      // Use a `where` clause to delete a specific item.
      where: where,
      // Pass the Item's id as a whereArg to prevent SQL injection.
      whereArgs: whereArgs,
    );
  }

  /// Only for testing purposes
  Future<void> _deleteDatabase() async {
    return deleteDatabase(
      join(await getDatabasesPath(), SqliteService.dbName),
    );
  }
}
