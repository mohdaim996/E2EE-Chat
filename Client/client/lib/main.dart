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

DB db;
final Socket sock = new Socket();
void main() async {
 /* Crypt key = new Crypt(g: [5, 2], m: 97, p: 45);
  print(key.public);
  Crypt key2 = new Crypt(g: [5, 2], m: 97, p: 89);
  print(key2.public);
  Hash sh1 = await key.sharedSec(key2.public[0], key2.public[1]);
  Hash sh2 = await key2.sharedSec(key.public[0], key.public[1]);
  print(sh1 == sh2);
  SecretKey skey = new SecretKey(sh1.bytes);
  print(key.ecKeyGen(key2.public[0],  key2.public[1], 45, 97));
  print(key2.ecKeyGen(key.public[0], key.public[1], 89, 97));

  final algorithm = AesGcm.with256bits();
  final nonce = algorithm.newNonce();
  final secretBox = await algorithm.encrypt(
    [77, 111, 104, 97, 109, 109, 101, 100],
    secretKey: skey,
    nonce: nonce,
  );
  print('Nonce: ${secretBox.nonce}');
  print('Ciphertext: ${secretBox.cipherText}');
  print('MAC: ${secretBox.mac.bytes}');
  print(await algorithm.decrypt(secretBox, secretKey: skey));*/
  WidgetsFlutterBinding.ensureInitialized();
  db = new DB();
  //db.fm();
  //var x = Socket.channel;
  if (sock.channel != null) {
    sock.listen();
  }
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
                "ws://ae6f023162ff.ngrok.io",
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
