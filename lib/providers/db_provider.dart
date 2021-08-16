import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DbProvider{
  static const tableName = 'moviesWatched';

  static Future<Database> initDatabase() async {
    final dbPath = await getApplicationDocumentsDirectory(); ///db directory
    return openDatabase(
        join(dbPath.path, 'movies.db'),
        onCreate: (db, version) async {
          return await db.execute(
            '''CREATE TABLE IF NOT EXISTS $tableName(
            createdOn TEXT PRIMARY KEY,
            name TEXT, 
            director TEXT, 
            imageUrl TEXT, 
            updatedOn TEXT
          )''',
          );
        },
        version: 1,
      );
  }

  static Future<List<Map<String, dynamic>>> read() async {
    final _db = await DbProvider.initDatabase();
    return await _db.query(tableName);
  }

  static Future<List<Map<String, dynamic>>> find(String name) async {
    final _db = await DbProvider.initDatabase();
    final ret = await _db.query(tableName, where: 'name = name');
    return ret;
  }

  static Future<void> createOrUpdate(Map<String, dynamic> data) async {
    print("DB Poster ${data["imageUrl"]}");
    final _db = await DbProvider.initDatabase();
    await _db.insert(tableName, data, conflictAlgorithm: ConflictAlgorithm.replace,);
    (await _db.query(tableName, columns: ['createdOn', 'name'])).forEach((row) {
      print(row.values);
    });
  }

  static Future<void> delete(String key) async {
    final _db = await DbProvider.initDatabase();
    await _db.delete(
      tableName,
      where: 'name = ?',
      whereArgs: [key],
    );
  }

  static Future clearTable() async {
    final _db = await DbProvider.initDatabase();
    return await _db.rawQuery("DELETE FROM $tableName");
  }
}
