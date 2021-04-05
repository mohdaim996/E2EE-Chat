import 'dart:async';

import 'package:client/Socket.dart';
import 'package:client/message.dart';
import 'package:flutter/material.dart';
import 'main.dart' as main;
import 'message.dart';
import 'users.dart';

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
    //main.db.fm();
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Reciever Name"),
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
      Socket.sendMsg(_controller.text);
      msgList.add([
        {"msg": _controller.text},
        {"by": "me"}
      ]);
    }
    _controller.clear();
  }

  @override
  void dispose() {
    //channel.sink.close();
    super.dispose();
  }

  Widget streamer(Context) {
    return StreamBuilder(
        stream: ChatRoom.stream, 
        
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error");
          }
          if (snapshot.hasData) {
            print('listing');
            return ListView.builder(
                itemBuilder: (context, index) {
                  print("listing");

                  return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 24.0, horizontal: 10),
                      child: Text(
                        snapshot.hasData
                            ? snapshot.data[index]['message']
                            : 'EMPTY',
                        style: TextStyle(
                            color: snapshot.data[index]['from'] ==
                                    main.db.clientName
                                ? Colors.blue
                                : Colors.green),
                      ));
                },
                itemCount: snapshot.data.length);
          }
          return Text('loading');
        });
  }

  Widget conversation(context) {
    return FutureBuilder(
        future: Socket.listen(),
        builder: (context, snapshot) {
          print('futuring');
          print(snapshot.data);
          return snapshot.hasData
              ? ListView.builder(
                  itemBuilder: (context, index) {
                    print("listing");

                    return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 24.0, horizontal: 10),
                        child: Text(
                          snapshot.hasData
                              ? snapshot.data[index]['message']
                              : 'EMPTY',
                          style: TextStyle(
                              color: snapshot.data[index]['from'] ==
                                      main.db.clientName
                                  ? Colors.blue
                                  : Colors.green),
                        ));
                  },
                  itemCount: snapshot.data.length)
              : Text("loading");
        });
  }

  List<String> msgs = [];
  Map<String, dynamic> msgMap = new Map<String, dynamic>();
  List<List<Map<String, dynamic>>> msgList = [];
  Widget msgBuilder() {
    return StreamBuilder(
      stream: Socket.msgStream(), //channel.stream,
      builder: (context, snapshot) {
        msgs.add(snapshot.data);
        msgList.add([
          {"msg": snapshot.data},
          {"by": "server"}
        ]);
        return ListView.builder(
            itemBuilder: (context, index) {
              return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 24.0, horizontal: 10),
                  child: Text(
                    msgList.isNotEmpty
                        ? '${msgList[index][0]["msg"]}'
                        : 'EMPTY',
                    style: TextStyle(
                        color: msgList[index][1]["by"] == "me"
                            ? Colors.blue
                            : Colors.green),
                  ));
            },
            itemCount: msgs.length);
      },
    );
  }
}
