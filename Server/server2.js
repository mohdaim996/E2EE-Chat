const {request, ClientRequest, IncomingMessage} = require ('http');
const WebSocket = require ('ws');
const fs = require ('fs');
const Users = require ('./users.js');
const wss = new WebSocket.Server ({port: 3000});
var c = {};
wss.on ('connection', function connection (ws, request) {
  ws.on ('message', function incoming (message) {
    let msg = JSON.parse (message);
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
      }
    }
    if (msg['type'] == 'register') {
      let user = new Users (
        (id = msg['username']),
        (email = msg['email']),
        (pass = msg['password']),
        (type = 'register'),
        (db = 'users.json')
      );
    }
    if (msg['type'] == 'message') {
      let db = fs.readFileSync ('sockets.json');
      let users = JSON.parse (db);
      let to = msg['to'];
      let u = users[to];
      c[to].send (msg['message']);
    }
  });
  ws.send ('{"type":"ID card","name":"Moh"}');
});
