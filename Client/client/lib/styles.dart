import 'package:flutter/material.dart';
import 'main.dart';

Widget logo = Image.asset(
  'logo.png',
  width: wScale(150),
  height: hScale(150),
);

Widget creds = Text(
  "Devoloped by Mohammed Abduldaim & Hamad Al-safi",
  style: TextStyle(color: Colors.white70),
);

Widget basicButton(bool isElevated, Function setState, Function callback,
    {Widget child, double radius = 5, double width = 75, double height = 40}) {
  Widget child_widget = child ?? Container();

  return GestureDetector(
      onTapDown: (details) {
        setState(() {
          isElevated = !isElevated;
          callback();
        });
      },
      onTapUp: (details) {
        setState(() {
          isElevated = !isElevated;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        height: hScale(height),
        width: wScale(width),
        child: Align(alignment: Alignment.center, child: child_widget),
        decoration: BoxDecoration(
            color: Color(0xFFc2e9fb),
            borderRadius: BorderRadius.circular(radius),
            boxShadow: isElevated
                ? [
                    BoxShadow(
                        color: Color(0xFF6b8996),
                        offset: Offset(4, 4),
                        blurRadius: 15,
                        spreadRadius: 0.5),
                    BoxShadow(
                        color: Color(0xff9ce0ff),
                        offset: Offset(-4, -4),
                        blurRadius: 15,
                        spreadRadius: 0.5)
                  ]
                : null),
      ));
}

Widget bodyBase(Widget child) => SingleChildScrollView(
        child: SizedBox(
      height: height,
      child: Center(
        child: child,
      ),
    ));

Widget basicInput(TextEditingController controller, String label,
    {double width = 300, double radius = 5, bool password = false}) {
  return Container(
    width: wScale(width),
    height: hScale(50),
    padding: EdgeInsets.all(0.5),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.black12, Color(0x96fef9d7)]),
    ),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(0xFFc2e9fb), Color(0xFFa1c4fd)]),
      ),
      child: TextFormField(
        obscureText: password,
        controller: controller,
        decoration: new InputDecoration(
          labelText: label,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
        ),
      ),
    ),
  );
}

Widget mainBackground(Widget child) {
  return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF8BC6EC),
            Color(0xFF9599E2),
          ],
        ),
      ),
      child: child);
}

Widget promtContainer(Widget child, BuildContext context,
    {double width = 324, double radius = 10}) {
  return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.6),
              Colors.white.withOpacity(0.3),
            ],
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
          ),
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          border: Border.all(
            width: wScale(1.5),
            color: Colors.white.withOpacity(0.2),
          )),
      width: wScale(width),
      child: child);
}

Widget messageBox(bool user,Widget child, BuildContext context,
    { double radius = 10}) {
  return Container(
    constraints: BoxConstraints(maxWidth: wScale(300)),
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2.5),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.6),
              Colors.white.withOpacity(0.3),
            ],
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
          ),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(radius),
              topRight: Radius.circular(radius),
              bottomRight: user?Radius.zero : Radius.circular(radius),
              bottomLeft: !user?Radius.zero : Radius.circular(radius)),
          border: Border.all(
            width: 1.5,
            color: Colors.white.withOpacity(0.2),
          )),
      
      child: child);
}

Widget appBar({Widget child, double height = 80, double width = 1000}) {
  Widget childItem = child ?? Container();
  Widget bar = Container(
    child: childItem,
    height: hScale(height),
    width: wScale(width),
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: Offset(0, 5),
            blurRadius: 10,
            spreadRadius: 5)
      ],
      gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blue[300], Colors.blue]),
      borderRadius: BorderRadius.only(
        bottomRight: Radius.circular(10),
        bottomLeft: Radius.circular(10),
      ),
    ),
  );
  return bar;
}
