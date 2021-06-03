import 'dart:async';
import 'package:client/users.dart';
import 'package:client/message.dart';
import 'main.dart' as main;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'chatRoom.dart' as chat;
import 'contacts.dart' as contacts;

class DB {
  String _client;
  User client;
  Database _database;

  set db(db) {
    this._database = db;
  }

  get database => this._database;

  Future<void> start(String clientName) async {
    this._client = clientName;
    this.client = new User(clientName);
    await this._initDB();
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
        "CREATE TABLE user(user TEXT NOT NULL PRIMARY KEY,email TEXT, token TEXT,pkx TEXT,pky TEXT, private BIGINT)");
    await db.execute(
        "CREATE TABLE keys(contact TEXT PRIMARY KEY REFERENCES contacts (user),pkx TEXT,pky TEXT, secret TEXT)");
  }

  Future<void> insertUser(Users user, String table) async {
    await this._database.insert(table, user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
    final List<Map<String, dynamic>> maps =
        await this._database.query('$table');
    print(maps);
    var q = await (this._database.query('user'));
    print(q);
    this.client.addKeys(q[0]['pkx'], q[0]['pky'],q[0]['private']);
  }

  Future<void> insertMessage(Messages message) async {
    await this._database.insert('chat', message.toMap());
    print('new messages');
  }

  Future<void> updateKeys(int pkx, int pky, int private) async {
    var q = await (this._database.query('user'));
    Map<String, dynamic> map = new Map<String, dynamic>();
    map.addAll({
      "user": q[0]['user'],
      "email": q[0]['email'],
      "token": q[0]['token'],
      "pkx": pkx,
      "pky": pky,
      "private": private
    });
    

    await this._database.update('user', map);
    q = await (this._database.query('user'));
    print(q);
  }
Future<void> insertKeys(contact,pkx,pky,secret) async {
    await this._database.insert('keys', {"contact":contact,"pkx":pkx,"pky":pky,"secret":secret},conflictAlgorithm: ConflictAlgorithm.replace);
    ;
    var q = await (this._database.query('keys'));
    print(q);
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
          sender == this.client.username ? this.client : contact,
          Users(sender),
          element['message'],
          element['stamp']));
    });
    chat.chat = msgs;

    return msgs;
  }
}
