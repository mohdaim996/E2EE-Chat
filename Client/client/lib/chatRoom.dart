import 'dart:async';

import 'package:client/Socket.dart';
import 'package:client/message.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'message.dart';
import 'users.dart';

Contact user;

class ChatRoom extends StatefulWidget {
  static StreamController messageStream = new StreamController.broadcast();
  static Stream stream = ChatRoom.messageStream.stream;

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(user.username),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(flex: 1, child: streamer(context)),
          /* Expanded(
              flex: 1,
              child: Container(
                color: Colors.blueGrey[100],
                constraints: BoxConstraints.expand(),
              )),*/
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _controller,
                  decoration: new InputDecoration(),
                ),
              ),
              FloatingActionButton(
                onPressed: _sendMessage,
                tooltip: 'Send message',
                child: Icon(Icons.send),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      //channel.sink.add(_controller.text);
      sock.sendMsg(_controller.text);
    }
    _controller.clear();
  }

  @override
  void dispose() {
    ChatRoom.messageStream.close();
    super.dispose();
  }

  bool onLoad = true;

  Widget streamer(context) {
    return StreamBuilder(
        stream: ChatRoom.stream,
        builder: (context, snapshot) {
          if (onLoad == true) {
            db.ffm();
          }
          if (snapshot.hasError) {
            return Text("Error");
          }
          if (snapshot.hasData) {
            print('listing');
            onLoad = false;
            ScrollController _myController = ScrollController();

            return ListView.builder(
                controller: _myController,
                itemBuilder: (context, index) {
                  print("listing");
                  try {
                    _myController
                        .jumpTo(_myController.position.maxScrollExtent);
                  } catch (e) {}
                  return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 24.0, horizontal: 10),
                      child: Text(
                        snapshot.hasData
                            ? snapshot.data[index]['message']
                            : 'EMPTY',
                        style: TextStyle(
                            color: snapshot.data[index]['from'] == db.clientName
                                ? Colors.blue
                                : Colors.green),
                      ));
                },
                itemCount: snapshot.data.length);
          }
          return Text('loading');
        });
  }

  Widget chatView(context, snapshot) {
    return ListView.builder(
        itemBuilder: (context, index) {
          print("listing");

          return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 24.0, horizontal: 10),
              child: Text(
                snapshot.hasData ? snapshot[index]['message'] : 'EMPTY',
                style: TextStyle(
                    color: snapshot[index]['from'] == db.clientName
                        ? Colors.blue
                        : Colors.green),
              ));
        },
        itemCount: snapshot.length);
  }
}
