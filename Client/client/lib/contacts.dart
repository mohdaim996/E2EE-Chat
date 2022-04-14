import 'package:flutter/material.dart';
import 'dart:async';
import 'users.dart';
import "styles.dart" as ST;
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
  bool _searchFocus = false;
  void _searchFoucusSwitch() => _searchFocus = false;
  _ContactDisplayState() {
    _searchBar.addListener(() {
      if (!_searchBar.hasPrimaryFocus) {
        setState(() {
          _searchController.dispose();
        });
      }
    });
  }
  void searchAndSwitchFocus() {
    main.sock.contactSearch(_searchController.text);
    _searchController.clear();
    setState(_searchFoucusSwitch);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height / 100 * 10;
    double width = MediaQuery.of(context).size.width;
    Widget title = Text("Contacts",
        style: TextStyle(
          color: Colors.white,
          fontSize: 23,
        ));

    Widget searchField = ST.basicInput(_searchController, "Name", width: 250);

    Widget searchButton = IconButton(
        onPressed: searchAndSwitchFocus,
        icon: Icon(Icons.send, color: Colors.white));

    Widget searchRow = Row(children: [searchField, searchButton]);

    Widget searchIcon = IconButton(
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(),
      icon: Icon(Icons.search, color: Colors.white),
      onPressed: () {
        setState(() {
          _searchFocus = !_searchFocus;
        });
      },
    );

    Widget barRow = ST.appBar(
        height: 70,
        width:width,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              searchIcon,
              _searchFocus == true ? searchRow : title,
              Icon(
                Icons.circle,
                color: Colors.transparent,
              )
            ]));

    Widget body = Flex(
      direction: Axis.vertical,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: barRow,
        ),
        Expanded(flex: 1, child: contactListBuilder())
      ],
    );

    return Scaffold(body: SafeArea(child: ST.mainBackground(body)));
  }

  Widget contactListBuilder() {
    return StreamBuilder(
        stream: stream, //channel.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text('you have no contacts');
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                print("listview ${snapshot.data}");
                return ST.promtContainer(
                    ListTile(
                        onTap: () {
                          chat.user = Contact(snapshot.data[index]["user"]);
                          Navigator.pushNamed(context, '/chatRoom');
                        },
                        leading: Icon(Icons.contacts),
                        title: Text(snapshot.data[index]["user"])),
                    context,
                    radius: 0);
              },
            );
          }
        });
  }
}
