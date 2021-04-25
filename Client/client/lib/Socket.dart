import 'dart:async';

import 'package:client/message.dart';
import 'package:client/users.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';
import 'main.dart' as main;

class Socket {
  String host = "wss://c8f4d2582a35.ngrok.io";
  WebSocketChannel _channel;
  // static WebSocketChannel _channel = IOWebSocketChannel.connect(
  //     "wss://88cb2928d22a.ngrok.io",
  //    headers: {"name": "Mohammed"});
  WebSocketChannel get channel {
    return this._channel;
  }

  set setChannel(WebSocketChannel connection) {
    this._channel = connection;
  }

  Future listen({response}) async {
    print('listening...');
    this._channel.stream.listen(
        (event) {
          var e = event.toString();
          Map<String, dynamic> msg = new Map<String, dynamic>();
          print(e);
          msg.addAll(json.decode(e));

          if (msg['type'] == 'login response') {
             response.sink.add('success');
            print('inserting user');
            main.db.insertUser(new User(msg['user']), 'user');
          } else if (msg['type'] == 'message') {
            print('new message:socket');
            main.db.insertMessage(new Messages(
                new Contact(msg['from']),
                new Contact(msg['from']),
                new User(msg['to']),
                msg['message'].toString(),
                msg['stamp']));
          } else {
            print(msg);
          }
          return main.db.fetchMessages();
        },
        onDone: () => print('onDone'),
        onError: (error, stackTrace) {
          print('OnError: $error');
          print("onError $response");
          response.sink.add('sink Error');
        });
  }

  dynamic login(String usrName, String passwd, response) async {
    //  Map<String, dynamic> msg = new Map<String, dynamic>();
    //  msg.addAll({"type": "login", "username": usrName, "password": passwd});
    //  Socket._channel.sink.add(jsonEncode(msg));
    try {
      this.setChannel = await IOWebSocketChannel.connect(
        this.host,
        protocols: ["login", usrName, passwd],
      );
      this.listen(response: response);
    } catch (e) {
      print('catching');
      return e;
    }
  }

  void register(String usrName, String email, String passwd, String passwd2) {
    Map<String, dynamic> msg = new Map<String, dynamic>();
    msg.addAll({
      "type": "register",
      "username": usrName,
      "email": email,
      "password": passwd,
      "password2": passwd2
    });
    this._channel.sink.add(jsonEncode(msg));
  }

  void sendMsg(String message) {
    Map<String, dynamic> msg = new Map<String, dynamic>();
    msg.addAll({
      "by": "user",
      "to": "Moh",
      "type": "message",
      "message": message,
      "time": new DateTime.now().toString()
    });
    print(msg);
    this._channel.sink.add(jsonEncode(msg));
  }

  Stream<dynamic> msgStream() {
    return this._channel.stream;
  }

  Stream<dynamic> contactInfo() {
    var strm = this._channel.stream.listen((event) => event).toString();
    Map<String, dynamic> msg = new Map<String, dynamic>();
    msg.addAll(json.decode(strm));
    if (msg["type"] == 'Id card') {}
  }
}
