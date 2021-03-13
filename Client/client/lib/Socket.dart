import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';

class Socket {
  static WebSocketChannel _channel = IOWebSocketChannel.connect(
      "ws://ea166529464b.ngrok.io",
      headers: {"name": "Mohammed"});
  static WebSocketChannel get channel {
    return Socket._channel;
  }

  static void login(String usrName, String passwd) {
    Map<String, dynamic> msg = new Map<String, dynamic>();
    msg.addAll({"type": "login", "username": usrName, "password": passwd});
    Socket._channel.sink.add(jsonEncode(msg));
  }

  static void register(
      String usrName, String email, String passwd, String passwd2) {
    Map<String, dynamic> msg = new Map<String, dynamic>();
    msg.addAll({
      "type": "register",
      "username": usrName,
      "email": email,
      "password": passwd,
      "password2":passwd2
    });
    Socket._channel.sink.add(jsonEncode(msg));
  }

  static void sendMsg(String message) {
    Map<String, dynamic> msg = new Map<String, dynamic>();
    msg.addAll({
      "by": "user",
      "message": message,
      "time": new DateTime.now().toString()
    });
    print(msg);
    Socket._channel.sink.add(jsonEncode(msg));
  }

  static Stream<dynamic> msgStream() {
    return Socket._channel.stream;
  }
}
