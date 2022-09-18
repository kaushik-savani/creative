import 'package:path/path.dart';

import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class dbhelper {
  Future<Database> createdatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');

    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE Test (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, contact TEXT, email TEXT, pass TEXT, radio TEXT,learning INTEGER,cricket INTEGER,listenmusic INTEGER,photography INTEGER)');
    });
    return database;

  }
}
