import 'dart:async';
import 'package:client/users.dart';
import 'package:client/message.dart';
import 'main.dart' as main;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'chatRoom.dart' as chat;
import 'contacts.dart' as contacts;

class DB {
  String clientName;
  Database _database;
  set db(db) {
    this._database = db;
  }

  get database => this._database;
  String _client;

  Future<void> start(String clientName) async {
    this._client = clientName;
    await this._initDB();
    print(this._database);
  }

  Future<void> _initDB() async {
    String path = await getDatabasesPath();
    this.db = await openDatabase(
      join(path, '${this._client}_database.db'),
      onCreate: (db, version) async {
        return await this.onCreate(db);
      },
      version: 1,
    );
  }

  Future<void> onCreate(db) async {
    await db.execute(
        "CREATE TABLE chat(msgId INTEGER PRIMARY KEY,contact TEXT NOT NULL , sender TEXT, reciever TEXT, message TEXT, stamp TEXT)");
    await db.execute("CREATE TABLE contacts(user TEXT NOT NULL PRIMARY KEY)");
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
    print('new messages');
  }

  Future<void> insertContacts(Contact contact) async {
    await this._database.insert('contacts', contact.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    final List<Map<String, dynamic>> maps =
        await this._database.query('contacts');
    if (maps.isNotEmpty) {
      contacts.contactStream.add(maps);
    }
    print('new contact');
  }

  Future<List<Messages>> fetchChatHistory(Contact contact) async {
    List<Map<String, dynamic>> maps = await this
        ._database
        .query('chat', where: "contact = '${contact.username}'");

    List<Messages> msgs = [];
    maps.forEach((element) {
      String sender = element['sender'];
      msgs.add(Messages(
          contact,
          sender == this.clientName ? User(sender) : contact,
          Users(sender),
          element['message'],
          element['stamp']));
    });
    chat.chat = msgs;

    return msgs;
  }
}
