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
import 'crypt.dart';
import 'package:cryptography/cryptography.dart';

DB db;
final Socket sock = new Socket();
void main() async {
  Crypt key = new Crypt(g: [5, 1], m: 17, p: 15);
  print(key.public);
  Crypt key2 = new Crypt(g: [5, 1], m: 17, p: 8);
  print(key2.public);
  Hash sh1 = await key.sharedSec(13, 7);
  Hash sh2 = await key2.sharedSec(3, 16);
  SecretKey skey = new SecretKey(sh1.bytes);
  print(key.ecKeyGen(13, 7, 15, 17));
  print(key2.ecKeyGen(3, 16, 8, 17));

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
  print( await algorithm.decrypt(secretBox, secretKey: skey));
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
