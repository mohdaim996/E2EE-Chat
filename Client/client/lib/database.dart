import 'dart:async';
import 'package:client/users.dart';
import 'package:client/message.dart';
import 'main.dart' as main;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'chatRoom.dart';
import 'contacts.dart';

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
    assert(this._client != null);
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
    final List<Map<String, dynamic>> maps = await this._database.query('chat');
    if (maps.isNotEmpty) {
      ChatRoom.messageStream.add(maps);
    }
    print('new messages');
  }

  Future<void> insertContacts(Contact contact) async {
    await this._database.insert('contacts', contact.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    final List<Map<String, dynamic>> maps =
        await this._database.query('contacts');
    if (maps.isNotEmpty) {
      ContactDisplay.contactStream.add(maps);
    }
    print('new contact');
  }

  Future fetchMessages() async {
    final Future<List<Map<String, dynamic>>> maps =
        this._database.query('chat');
    return maps;

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

  Stream fm() async* {
    while (true) {
      final Stream<List<Map<String, dynamic>>> maps =
          main.db.fetchMessages().asStream();
      ChatRoom.messageStream.add(maps);
      print('adding maps');
      print(maps);
    }
  }

  Stream chatOf(Contact contact) async* {
    List<Map<String, dynamic>> maps = await this._database.query('chat');
    if (maps.runtimeType != Future) {
      yield maps;
    }
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
