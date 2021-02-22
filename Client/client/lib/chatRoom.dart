import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final WebSocketChannel channel = IOWebSocketChannel.connect(
    "ws://58999b6f04c3.ngrok.io/",
  );
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Reciever Name"),
      ),
      body: 
      
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        
        children: [
          Expanded(
            flex: 1,
            child:Container(
              color: Colors.blueGrey[100],
             constraints: BoxConstraints.expand(),
             
              ) )
          ,
       
            Row(
            
            children: [
              Expanded(
                child:TextFormField(
                controller: _controller,
                decoration: new InputDecoration(),
              ) ,
              )
              ,
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
      channel.sink.add(_controller.text);
    }
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}
