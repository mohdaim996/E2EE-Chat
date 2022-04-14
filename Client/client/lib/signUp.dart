import 'package:client/main.dart';
import 'package:flutter/material.dart';
import 'styles.dart' as ST;

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _usrName = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _passwd = TextEditingController();
  TextEditingController _passwd2 = TextEditingController();
  bool _isElevated = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(extendBody: true, body: body(context));
  }

  Widget body(BuildContext context) {
    Widget name = ST.basicInput(_usrName, "Username:");
    Widget pswd = ST.basicInput(_passwd, "Password");
    Widget repswd = ST.basicInput(_passwd2, "Re-enter Password:");
    Widget email = ST.basicInput(_email, "Email:");

    Widget signup = ST.basicButton(_isElevated, setState, _signUp,child:Text("Signup"));

    Widget body =ST.bodyBase(Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(height: hScale(36)),
        ST.logo,
        Spacer(),
        ST.promtContainer(
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text("Pleas provide the following information"),
              Container(
                height: hScale(20.75),
              ),
              name,
              Container(height: hScale(25)),
              email,
              Container(height: hScale(25)),
              pswd,
              Container(height: hScale(25)),
              repswd,
              Container(height: hScale(25)),
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

  void _signUp() {
    if (_usrName.text.isNotEmpty &&
        _email.text.isNotEmpty &&
        _passwd.text.isNotEmpty &&
        _passwd2.text.isNotEmpty) {
      sock.register(_usrName.text, _email.text, _passwd.text, _passwd2.text);
    }
  }
}
