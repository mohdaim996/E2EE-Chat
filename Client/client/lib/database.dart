import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DB {
  Future<Database> _database;
  set db(db){this._database = db;}
   String _client;

  DB(String clientName)  {
    this._client = clientName;
    this._initDB();
  }

  void _initDB() async {
    // ignore: unused_local_variable
     this._database = openDatabase(
      join(await getDatabasesPath(), '${this._client}_database.db'),
      onCreate: (db, version) {
        return DB.onCreate(db);
      },
      version: 1,
    );
  }

  static void onCreate(db) async {
    await db.execute(
        "CREATE TABLE chat(contact TEXT NOT NULL, int NOT NULL AUTOINCREMENT,from TEXT, message TEXT, stamp TEXT,PRIMARY KEY(contact, int))");
    await db
        .execute("CREATE TABLE contacts(username TEXT NOT NULL PRIMARY KEY)");
    await db.execute(
        "CREATE TABLE user(user TEXT NOT NULL PRIMARY KEY, token TEXT)");
  }
}
//contacts(ID Username)
//chat(ID contact_INT, Time stamp, from, message)
//User(ID Username, Token)
