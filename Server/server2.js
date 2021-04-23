const fs = require ('fs');
const Users = require ('./users.js');
const http = require('http');
const WebSocket = require('ws');
const server = http.createServer();
const wss = new WebSocket.Server({ noServer: true });

server.on('upgrade',function upgrade(request, socket, head) {
  let proto =  request.headers['sec-websocket-protocol'].split(',');
  
  proto.forEach(function(item,index){proto[index] = item.trim()})
  console.log(proto)
  console.log(proto[1])

  if(proto[0] == 'login'){
    let user = new Users (
      (id = proto[1]),
      (email = proto[1]),
      (pass = proto[2]),
      (socket = socket),
      (type = 'login'),
      (db = 'users.json')
    );
    if(user.isAuth == false){
      console.log('closing')
      socket.write('HTTP/1.1 401 Unauthorized\r\n\r\n');
      socket.destroy();
      wss.close();
      return
    }else{
      wss.handleUpgrade(request, socket, head, function done(ws,request,client) {
        if (user.isAuth) {
          console.log('Auth');
          ws.id = user.id;
          c[user.id] = ws;
          c[user.id].send (
            JSON.stringify ({
              type: 'login response',
              status: 'logged',
              user: `${user.id}`,
            })
          );
        console.log('connection upgraded')
        wss.emit('connection', ws, request, client);
        return
        }
        });
    }}
      
  
  });

var c = {};

wss.on ('connection', function connection (ws, request) {
 
  console.log (request.socket.remoteAddress);
  
  ws.on ('message', function incoming (message) {
    let msg = JSON.parse (message);
    console.log (msg);
    if (msg['type'] == 'login') {
      let user = new Users (
        (id = msg['username']),
        (email = msg['email']),
        (pass = msg['password']),
        (socket = ws),
        (type = 'login'),
        (db = 'users.json')
      );
      if (user.isAuth) {
        ws.id = user.id;
        c[user.id] = user.socket;
        c[user.id].send (
          JSON.stringify ({
            type: 'login response',
            status: 'logged',
            user: `${user.id}`,
          })
        );
      }
    }
    if (msg['type'] == 'register') {
      console.log ('registering: ' + msg['username']);
      let user = new Users (
        (id = msg['username']),
        (email = msg['email']),
        (pass = msg['password']),
        (socket = ws),
        (type = 'register'),
        (db = 'users.json')
      );
    }
    if (msg['type'] == 'message') {
      let to = msg['to'];
      c[to].send (
        JSON.stringify ({
          type: 'message',
          from: 'Moh',
          to: to,
          message:`${msg['message']}`,
          stamp: '1',
        })
      );
    }
  });
  ws.send (
    JSON.stringify ({
      type: 'message',
      from: 'Moh',
      to: 'raze',
      message: 'Hello',
      stamp: '1',
    })
  );
});
server.listen(3000);