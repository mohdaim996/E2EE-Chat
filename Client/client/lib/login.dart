import 'dart:async';

import 'package:client/Socket.dart';
import 'package:client/main.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static StreamController response = new StreamController.broadcast();
  static Stream resStream = LoginScreen.response.stream;
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _usrName = TextEditingController();
  TextEditingController _passwd = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
            child: Column(
          children: [
            TextFormField(
              controller: _usrName,
              decoration: new InputDecoration(),
            ),
            TextFormField(
              controller: _passwd,
              decoration: new InputDecoration(),
            ),
            TextButton(
              child: Text("Login"),
              onPressed: _login,
            ),
            TextButton(
                onPressed: () => Navigator.pushNamed(context, '/SignUp'),
                child: Text("Sign Up?"))
          ],
        )));
  }

  dynamic _login() async {
    if (_usrName.text.isNotEmpty && _passwd.text.isNotEmpty) {
      print("${_usrName.text} - ${_passwd.text} ");
      await sock.login(_usrName.text, _passwd.text, LoginScreen.response);
      String response;

      LoginScreen.resStream.listen((event) {
        response = event;
        print("inside the loop $response");
        if (response == 'sink Error') {
          print(response);

          return _showMyDialog(context);
        } else if (response == 'success') {
          print(response);
         return Navigator.pushNamed(context, '/contact');
         }
       
      });
      print('waiting for server response...');
    }
  }
}

Future<void> _showMyDialog(context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('AlertDialog Title'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('This is a demo alert dialog.'),
              Text('Would you like to approve of this message?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Approve'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
