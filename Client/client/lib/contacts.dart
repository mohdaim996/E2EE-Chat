import 'package:client/main.dart';
import 'package:flutter/material.dart';
import 'Socket.dart';
import 'dart:convert';
import 'dart:async';

class ContactDisplay extends StatefulWidget {
  static StreamController contactStream = new StreamController.broadcast();
  static Stream stream = ContactDisplay.contactStream.stream;

  @override
  _ContactDisplayState createState() => _ContactDisplayState();
}

class _ContactDisplayState extends State<ContactDisplay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(flex: 1, child: contactListBuilder()),
          ],
        ));
  }

  Widget contactListBuilder() {
    return StreamBuilder(
        stream: ContactDisplay.stream, //channel.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text('Loading');
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                print("listview ${snapshot.data}");
                return ListTile(
                  leading: Icon(Icons.contacts),
                  title: Text(snapshot.data[index]["user"]),
                );
              },
            );
          }
        });
  }
}
