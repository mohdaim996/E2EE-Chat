import 'package:client/chatRoom.dart';
import 'package:client/socketTest.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'WebSocket Demo';
    return MaterialApp(
      routes: <String, WidgetBuilder>{
        '/chatRoom': (BuildContext context) => new ChatRoom(),
        '/socketTest': (BuildContext context) => new MyHomePage(
              title: title,
              channel: IOWebSocketChannel.connect(
                "ws://58999b6f04c3.ngrok.io/",
              )),

      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Router()
    );
  }
}

class Router extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        RaisedButton(
          onPressed: () => Navigator.pushNamed(context, '/chatRoom'),
          child: Text('Chat Room'),
          ),
          RaisedButton(
          onPressed: () => Navigator.pushNamed(context, '/socketTest'),
          child: Text('Socket Test'),
          )
      ],
    );
  }
}

