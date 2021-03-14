import 'package:flutter/material.dart';
import 'Socket.dart';
import 'dart:convert';

class ContactDisplay extends StatefulWidget {
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

  static List<Map<String, dynamic>> book = [];
  Widget contactListBuilder() {
    return StreamBuilder(
        stream: Socket.msgStream(), //channel.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text('Loading');
          } else {
            book.add(json.decode(snapshot.data));
            return ListView.builder(
              itemCount: book.isEmpty ? 0 : book.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.contacts),
                  title: Text(book[index]["name"]),
                );
              },
            );
          }
        });
  }
}
