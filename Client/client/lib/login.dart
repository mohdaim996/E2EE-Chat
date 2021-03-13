import 'package:client/Socket.dart';
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
            FlatButton(
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
      Socket.login(_usrName.text, _passwd.text);
    }
  }
}
