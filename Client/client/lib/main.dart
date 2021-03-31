import 'package:client/chatRoom.dart';
import 'package:client/socketTest.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/widgets.dart';
import 'login.dart';
import 'signUp.dart';
import 'Socket.dart';
import 'contacts.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  Socket.channel;

  runApp(MyApp());
}

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
                "ws://a908ce74c99d.ngrok.io",
              )),
          '/login': (BuildContext context) => new LoginScreen(),
          '/SignUp': (BuildContext context) => new SignUp(),
          '/contact': (BuildContext context) => new ContactDisplay(),
        },
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Router());
  }
}

class Router extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        RaisedButton(
          onPressed: () => Navigator.pushNamed(context, '/contact'),
          child: Text('contacts'),
        ),
        RaisedButton(
          onPressed: () => Navigator.pushNamed(context, '/login'),
          child: Text('Login'),
        ),
        RaisedButton(
          onPressed: () => Navigator.pushNamed(context, '/SignUp'),
          child: Text('Sign Up'),
        ),
        RaisedButton(
          onPressed: () => Navigator.pushNamed(context, '/chatRoom'),
          child: Text('Chat Room'),
        ),
        RaisedButton(
          onPressed: () => Navigator.pushNamed(
            context,
            '/socketTest',
          ),
          child: Text('Socket Test'),
        )
      ],
    );
  }
}
