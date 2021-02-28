import 'package:client/Socket.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

class ChatRoom extends StatefulWidget {
  final Socket mySocket;
  ChatRoom({@required this.mySocket});
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final WebSocketChannel channel = IOWebSocketChannel.connect(
    "ws://4646ed7b6bbd.ngrok.io",
  );
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Reciever Name"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(flex: 1, child: MsgBuilder()),
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
      widget.mySocket.sendMsg(_controller.text);
      msgList.add([
        {"msg": _controller.text},
        {"by": "me"}
      ]);
    }
    _controller.clear();
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  List<String> msgs = new List<String>();
  Map<String, dynamic> msgMap = new Map<String, dynamic>();
  List<List<Map<String, dynamic>>> msgList =
      new List<List<Map<String, dynamic>>>();
  Widget MsgBuilder() {
    assert(widget.mySocket != null);
    return StreamBuilder(
      stream: widget.mySocket.msgStream(), //channel.stream,
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
                    msgList.isNotEmpty ? '${msgList[index][0]["msg"]}' : '',
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
