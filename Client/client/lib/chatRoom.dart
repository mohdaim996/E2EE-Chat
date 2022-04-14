import 'dart:async';
import 'package:flutter/material.dart';
import 'users.dart';
import 'package:client/message.dart';
import 'styles.dart' as ST;
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
  bool _isElevated = false;
  @override
  Widget build(BuildContext context) {
    main.height = MediaQuery.of(context).size.height;
    main.width = MediaQuery.of(context).size.width;
    msgCheck();
    reloader.listen((event) {
      if (event == 'new message') {
        newMsgs = true;
        msgCheck();
      }
    });
    Widget curUser = Text(user.username,
        style: TextStyle(
          color: Colors.white,
          fontSize: 23,
        ));
    Widget chatInfo = ST.appBar(child: Center(child: curUser));
    Widget chatBody = Expanded(flex: 1, child: streamer(context));
    Widget msgInput =
        Expanded(child: ST.basicInput(_controller, "", radius: 50));
    Widget sendBtn = ST.basicButton(_isElevated, setState, _sendMessage,
        child: Icon(Icons.send), height: 48, radius: 50);
    Widget inputRow = Row(children: [msgInput, sendBtn]);
    Widget body = Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [chatInfo, chatBody, inputRow],
    );
    return Scaffold(body: SafeArea(child: ST.mainBackground(body)));
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
                bool user =
                    chat[(chat.length - index) - 1].from.username.toString() ==
                        main.db.client.username;
                String msg = chat.isNotEmpty
                    ? chat[(chat.length - index) - 1].message
                    : data.data[(data.data.length - index) - 1].messages;
                Widget styledMsg = Text(
                  msg,
                  style: TextStyle(fontSize: 20),
                );
                Widget msgBox = Align(
                    alignment:
                        user ? Alignment.centerRight : Alignment.centerLeft,
                    child: ST.messageBox(user, styledMsg, context,radius: 30));
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 10),
                  child: msgBox,
                );
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
