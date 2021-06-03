import 'dart:async';
import 'package:flutter/material.dart';
import 'users.dart';
import 'package:client/message.dart';

import 'main.dart' as main;
import 'message.dart';

Contact user;
List<Messages> chat = [];
StreamController messageStream = new StreamController.broadcast();
Stream stream = messageStream.stream;
bool newMsgs = false;
StreamController pushMsg = new StreamController.broadcast();
Stream reloader = pushMsg.stream;

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    msgCheck();
    reloader.listen((event) {
      if (event == 'new message') {
        newMsgs = true;
        msgCheck();
      }
    });
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
      Messages usermsg = new Messages(user, main.db.client, user,
          _controller.text, new DateTime.now().toString());
      main.db.insertMessage(usermsg);
      main.sock.sendMsg(_controller.text, user.username);
      chat.add(usermsg);
      setState(() {
        newMsgs = false;
      });
    }
    _controller.clear();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget streamer(context) {
    //ScrollController _myController = ScrollController();
    return FutureBuilder(
        future: main.db.fetchChatHistory(user),
        builder: (context, data) {
          return ListView.builder(
            reverse: true,
             // controller: _myController,
              itemBuilder: (context, index) {
                print("listing");
                try {
                 // _myController.jumpTo(_myController.position.maxScrollExtent);
                } catch (e) {}
                
                return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 24.0, horizontal: 10),
                    child: Text(
                      chat.isNotEmpty
                          ? chat[(chat.length - index)-1].message
                          : data.data[(data.data.length - index)-1].messages,
                      style: TextStyle(
                          color: chat[(chat.length - index)-1].from.username.toString() ==
                                  main.db.client.username
                              ? Colors.blue
                              : Colors.green),
                    ));
              },
              itemCount: chat.length ?? data.data.length);
        });
  }

  void msgCheck() async {
    while (newMsgs == true) {
      setState(() {
        newMsgs = false;
      });
    }
  }
}
