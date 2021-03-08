import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';

class Socket {
  final WebSocketChannel _channel = IOWebSocketChannel.connect(
    "ws://408150ef4ce6.ngrok.io",
  );

  void sendMsg(String message) {
    Map<String, dynamic> msg = new Map<String, dynamic>();
    msg.addAll({
      "by": "user",
      "message": message,
      "time": new DateTime.now().toString()
    });
    print(msg);
    this._channel.sink.add(jsonEncode(msg));
  }

  Stream<dynamic> msgStream() {
    return this._channel.stream;
  }
}
