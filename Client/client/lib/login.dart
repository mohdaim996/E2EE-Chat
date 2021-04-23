import 'package:client/Socket.dart';
import 'package:client/main.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
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

  void _login() {
    if (_usrName.text.isNotEmpty && _passwd.text.isNotEmpty) {
      print("${_usrName.text} - ${_passwd.text} ");
      if (sock.login(_usrName.text, _passwd.text) == Error) {
        _showMyDialog(context);
      }
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
