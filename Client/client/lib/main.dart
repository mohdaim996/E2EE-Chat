import 'package:client/chatRoom.dart';
import 'package:client/database.dart';
import 'package:client/socketTest.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/widgets.dart';
import 'login.dart';
import 'signUp.dart';
import 'Socket.dart';
import 'contacts.dart';
import 'database.dart';


double height;
double width;
DB db;
final Socket sock = new Socket();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  db = new DB();
  if (sock.channel != null) {
    sock.listen();
  }
  runApp(MyApp());
}

double hScale(double value) => (value / 692 * 100) * height / 100;
double wScale(double value) => (value / 360 * 100) * width / 100;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'WebSocket Demo';
    
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: <String, WidgetBuilder>{
          '/chatRoom': (BuildContext context) => new ChatRoom(),
          '/socketTest': (BuildContext context) => new MyHomePage(
              title: title,
              channel: IOWebSocketChannel.connect(
                "ws://ae6f023162ff.ngrok.io",
              )),
          '/login': (BuildContext context) => new LoginScreen(),
          '/SignUp': (BuildContext context) => new SignUp(),
          '/contact': (BuildContext context) => new ContactDisplay(),
        },
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginScreen());
  }
}

class Router extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/contact'),
          child: Text('contacts'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/login'),
          child: Text('Login'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/SignUp'),
          child: Text('Sign Up'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/chatRoom'),
          child: Text('Chat Room'),
        ),
        ElevatedButton(
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
