import 'dart:async';
import 'package:client/main.dart';
import 'package:flutter/material.dart';
import 'styles.dart' as ST;

class LoginScreen extends StatefulWidget {
  static StreamController response = new StreamController.broadcast();
  static Stream resStream = LoginScreen.response.stream;
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _usrName = TextEditingController();
  TextEditingController _passwd = TextEditingController();
  bool _isElevated = false;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(extendBody: true, body: body(context));
  }

  Widget body(BuildContext context) {
    Widget name = ST.basicInput(_usrName, "Username:");
    Widget pswd = ST.basicInput(_passwd, "Password:",password: true);

    Widget signup = TextButton(
        onPressed: () => Navigator.pushNamed(context, '/SignUp'),
        child: Text("Sign Up?"));

    Widget login = ST.basicButton(_isElevated, setState, _login,child:Text("Login"));

    Widget body = ST.bodyBase(Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(height: hScale(36)),
        ST.logo,
        Spacer(),
        ST.promtContainer(
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text("Enter your account information"),
              Container(
                height: hScale(20.75),
              ),
              name,
              Container(height: hScale(25)),
              pswd,
              Container(height: hScale(25)),
              login,
              signup,
              Container(height: hScale(15)),
              
            ]),
            context),
        
        Spacer(),
        Divider(indent: 20, endIndent: 20),
        Spacer(),
        ST.creds,
      ],
    ));
    return ST.mainBackground(body);
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
        title: Text('Something went wrong'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('An error has occurred'),
              Text('Please Try again'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
