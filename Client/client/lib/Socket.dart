import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';

class Socket {
  static WebSocketChannel _channel = IOWebSocketChannel.connect(
      "ws://1159582ad511.ngrok.io",
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
      "to":"Moh",
      "type":"message",
      "message": message,
      "time": new DateTime.now().toString()
    });
    print(msg);
    Socket._channel.sink.add(jsonEncode(msg));
  }

  static Stream<dynamic> msgStream() {
    return Socket._channel.stream;
  }
  static Stream<dynamic> contactInfo(){
    var strm =Socket._channel.stream.listen((event) => event).toString();
    Map<String,dynamic> msg = new Map<String,dynamic>();
    msg.addAll(json.decode(strm));
    if(msg["type"]=='Id card'){

    }
  }
}
