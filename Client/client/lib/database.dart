import 'dart:async';
import 'package:client/users.dart';
import 'package:client/message.dart';
import 'main.dart' as main;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'chatRoom.dart';

class DB {
  String clientName;
  Database _database;
  set db(db) {
    this._database = db;
  }

  String _client;

  DB(String clientName) {
    this._client = clientName;
    this._initDB();
  }

  void _initDB() async {
    // ignore: unused_local_variable
    this._database = await openDatabase(
      join(await getDatabasesPath(), '${this._client}_database.db'),
      onCreate: (db, version) {
        return DB.onCreate(db);
      },
      version: 1,
    );
  }

  static void onCreate(db) async {
    await db.execute(
        "CREATE TABLE chat(msgId INTEGER PRIMARY KEY,contact TEXT NOT NULL , sender TEXT, reciever TEXT, message TEXT, stamp TEXT)");
    await db
        .execute("CREATE TABLE contacts(username TEXT NOT NULL PRIMARY KEY)");
    await db.execute(
        "CREATE TABLE user(user TEXT NOT NULL PRIMARY KEY,email TEXT, token TEXT)");
  }

  Future<void> insertUser(Users user, String table) async {
    await this._database.insert(table, user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    final List<Map<String, dynamic>> maps =
        await this._database.query('$table');
    print(maps);
    var q = await (this._database.query('user'));
    this.clientName = q[0]['user'];
  }

  Future<void> insertMessage(Messages message) async {
    await this._database.insert('chat', message.toMap());
    final List<Map<String, dynamic>> maps = await this._database.query('chat');
    try{
    ChatRoom().newMessagenote();}catch(e){}
    print(maps);
  }

  Future fetchMessages() async {
    return this._database.query('chat');
    /*List<Messages> messages;
    maps.forEach((element) => messages.add(Messages(
        Contact(element['contact']),
        Contact(element['from']),
        Contact(element['to']),
        element['message'],
        element['stamp'])));
    print("returning messages");
    return maps;*/
  }
}
//contacts(ID Username)
//chat(ID contact_INT, Time stamp, from, message)
//User(ID Username, Token)
//Todo:
//insert messages
//select messages
//select contacts
//insert contacts
