import 'dart:async';
import 'package:client/message.dart';
import 'package:client/users.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';
import 'main.dart' as main;
import 'chatRoom.dart' as chat;

class Socket {
  String host = "wss://3bc43e5e87f0.ngrok.io";
  WebSocketChannel _channel;

  WebSocketChannel get channel {
    return this._channel;
  }

  set setChannel(WebSocketChannel connection) {
    this._channel = connection;
  }

  Future listen({response}) async {
    print('listening...');
    this._channel.stream.listen(
        (event) async {
          var e = event.toString();
          Map<String, dynamic> msg = new Map<String, dynamic>();
          print(e);
          msg.addAll(json.decode(e));

          if (msg['type'] == 'login response') {
            response.sink.add('success');
            await main.db.start(msg['user']);
            print('inserting user');
            await main.db.insertUser(main.db.client, 'user');
            if (msg['contacts'] != 'none') {
              //  List contact = msg['contacts'].split(',');

              msg['contacts'].forEach((element) async {
                var keys = element['key'].split(',');
                var myPK = main.db.client.keys.public;
                main.db.insertContacts(Contact(element['contact']));

                dynamic shared = await main.db.client.keys
                    .sharedSec(int.parse(keys[0]), int.parse(keys[1]));
                print(shared);
                main.db.insertKeys(
                    element['contact'], keys[0], keys[1], shared.bytes);
              });
            }
          }
          if (msg['type'] == 'register response') {
            print('succeful registration');
          }
          if (main.db.database != null) {
            if (msg['type'] == 'message') {
              print('socket:new message');
              Contact sender = new Contact(msg['from']);
              Messages message = new Messages(sender, sender, main.db.client,
                  msg['message'].toString(), msg['stamp']);
              if (chat.user != null && chat.user.username == sender.username) {
                chat.chat.add(message);
                chat.pushMsg.add('new message');
              }
              main.db.insertMessage(message);
            } else if (msg['type'] == 'contact') {
              main.db.insertContacts(new Contact(msg['contact']));
            } else {
              print(msg);
            }
          }
          return;
        },
        onDone: () => print('onDone'),
        onError: (error, stackTrace) {
          print('OnError: $error');
          response.sink.add('sink Error');
        });
  }

  dynamic login(String usrName, String passwd, response) {
    try {
      this.setChannel = IOWebSocketChannel.connect(
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
    try {
      this.setChannel = IOWebSocketChannel.connect(
        this.host,
        protocols: ["register", usrName, passwd, email],
      );

      this.listen();
    } catch (e) {
      print('catching');
      return e;
    }
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

  void sendMsg(String message, user) {
    Map<String, dynamic> msg = new Map<String, dynamic>();
    msg.addAll({
      "by": main.db.client.username,
      "to": user,
      "type": "message",
      "message": message,
      "time": new DateTime.now().toString()
    });
    this._channel.sink.add(jsonEncode(msg));
    print('Message Sent to $user, on ${msg['time']}');
  }

  Stream<dynamic> msgStream() {
    return this._channel.stream;
  }

  void contactSearch(String user) {
    Map<String, dynamic> query = new Map<String, dynamic>();
    query.addAll({
      "type": "query",
      "by": main.db.client.username,
      "contact": user,
      "time": new DateTime.now().toString()
    });
    this._channel.sink.add(jsonEncode(query));
    print('Query started for $user, on ${query['time']}');
  }

  void publishKeys(String username, List<int> pk) {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data.addAll({
      "type": "keys",
      "owner": username,
      "keys": pk,
      "time": new DateTime.now().toString()
    });
    this._channel.sink.add(jsonEncode(data));
  }
}
