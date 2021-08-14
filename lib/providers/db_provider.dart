import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DbProvider with ChangeNotifier{
  static const DatabaseName = 'movies.db';
  static const MoviesWatchedTableName = 'moviesWatched';
  Database? db;

  DbProvider() {
    initDatabase();
  }

  void initDatabase() async {
    db = await openDatabase(
      join(await getDatabasesPath(), DatabaseName),
      onCreate: (db, version) {
        return db.execute(
          '''CREATE TABLE IF NOT EXISTS $MoviesWatchedTableName(
            name STRING PRIMARY KEY, 
            director STRING, 
            image STRING, 
            createdOn STRING,
            updatedOn STRING
          )''',
        );
      },
      version: 1,
    );
    print('Creating db $db');
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> read() async {
    return await db!.query(MoviesWatchedTableName);
  }

  Future<List<Map<String, dynamic>>> find(String query) async {
    final ret = await db!.rawQuery(
        'SELECT *, COUNT(*) as watchedTimes FROM $MoviesWatchedTableName where name like ?',
        ['%$query%']);

    return ret;
  }

  void createOrUpdate(Map<String, dynamic> data) async {
    await db!.insert(MoviesWatchedTableName, data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> delete(int key) async {
    await db!.delete(
      MoviesWatchedTableName,
      where: 'name = ?',
      whereArgs: [key],
    );
  }
}
