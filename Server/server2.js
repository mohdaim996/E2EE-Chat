const {request, ClientRequest, IncomingMessage} = require ('http');
const WebSocket = require ('ws');
const fs = require ('fs');
const Users = require ('./users.js');
const wss = new WebSocket.Server ({port: 3000});
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
        c[user.id].send (JSON.stringify({
          'type': 'login response',
          'status': 'logged',
          'user': `${user.id}`,
         
        }));
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
      c[to].send (msg['message']);
    }
  });
  ws.send ('{"type":"ID card","name":"Moh"}');
});
