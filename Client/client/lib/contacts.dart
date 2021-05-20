import 'package:flutter/material.dart';
import 'dart:async';

import 'users.dart';

import 'package:client/main.dart' as main;
import 'chatRoom.dart' as chat;

StreamController contactStream = new StreamController.broadcast();
Stream stream = contactStream.stream;

class ContactDisplay extends StatefulWidget {
 
  @override
  _ContactDisplayState createState() => _ContactDisplayState();
}

class _ContactDisplayState extends State<ContactDisplay> {
  FocusNode _searchBar = new FocusNode();
  TextEditingController _searchController = new TextEditingController();
  bool _searchFocus;
  _ContactDisplayState() {
    _searchBar.addListener(() {
      if (!_searchBar.hasPrimaryFocus) {
        setState(() {
          _searchController.dispose();
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _searchFocus = true;
                });
              },
            )
          ],
        ),
        body: Flex(
          direction: Axis.vertical,
          children: [
            _searchFocus == true
                ? Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _searchController,
                          decoration: new InputDecoration(),
                        ),
                      ),
                      FloatingActionButton(
                        onPressed: () {
                          main.sock.contactSearch(_searchController.text);
                          _searchController.clear();                         
                          setState(() {
                            _searchFocus = false;
                          });
                        },
                        tooltip: 'Search',
                        child: Icon(Icons.send),
                      ),
                    ],
                  )
                : Text('Your contacts'),
            Expanded(flex: 1, child: contactListBuilder()),
          ],
        ));
  }

  Widget contactListBuilder() {
    return StreamBuilder(
        stream: stream, //channel.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text('Loading');
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                print("listview ${snapshot.data}");
                return ListTile(
                  onTap: () {
                    chat.user = Contact(snapshot.data[index]["user"]);
                    Navigator.pushNamed(context, '/chatRoom');
                  },
                  leading: Icon(Icons.contacts),
                  title: Text(snapshot.data[index]["user"]),
                );
              },
            );
          }
        });
  }
}
