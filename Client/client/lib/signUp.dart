import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _usrName = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _passwd = TextEditingController();
  TextEditingController _passwd2 = TextEditingController();
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
              controller: _email,
              decoration: new InputDecoration(),
            ),
            TextFormField(
              controller: _passwd,
              decoration: new InputDecoration(),
            ),
            TextFormField(
              controller: _passwd2,
              decoration: new InputDecoration(),
            ),
            FlatButton(onPressed: _signUp, child: Text("Enter!"))
          ],
        ),
      ),
    );
  }

  void _signUp() {
    if (_usrName.text.isNotEmpty &&
        _email.text.isNotEmpty &&
        _passwd.text.isNotEmpty &&
        _passwd2.text.isNotEmpty) {
      print("${_usrName.text +' '+ _email.text +' '+ _passwd.text +' '+ _passwd2.text}");
    }
  }
}
