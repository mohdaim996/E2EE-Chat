import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

class Socket {
  final WebSocketChannel _channel = IOWebSocketChannel.connect(
    "ws://768dd39d9906.ngrok.io",
  );

  void sendMsg(String message) {
    Map<String, dynamic> msg = new Map<String, dynamic>();
    msg.addAll({"by": "user", "message": message, "time": new DateTime.now()});
    this._channel.sink.add(msg.toString());
  }

  Stream<dynamic> msgStream()  {
     return this._channel.stream;
  }
}