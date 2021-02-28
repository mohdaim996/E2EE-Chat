import 'package:client/chatRoom.dart';
import 'package:client/socketTest.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'Socket.dart';



void main() {
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final title = 'WebSocket Demo';
    return MaterialApp(
        routes: <String, WidgetBuilder>{
          '/chatRoom': (BuildContext context) => new ChatRoom(mySocket: Router().mySocket,),
          '/socketTest': (BuildContext context) => new MyHomePage(
              title: title,
              channel: IOWebSocketChannel.connect(
                "ws://a908ce74c99d.ngrok.io",
              )),
        },
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Router());
  }
}

class Router extends StatelessWidget {
  final Socket mySocket = new Socket();
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        RaisedButton(
          onPressed: () => Navigator.pushNamed(context, '/chatRoom'),
          child: Text('Chat Room'),
        ),
        RaisedButton(
          onPressed: () => Navigator.pushNamed(context, '/socketTest', ),
          child: Text('Socket Test'),
        )
      ],
    );
  }
}
