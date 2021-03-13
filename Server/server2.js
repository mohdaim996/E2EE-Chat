const {request, ClientRequest, IncomingMessage} = require ('http');
const WebSocket = require ('ws');
const fs = require ('fs');

const wss = new WebSocket.Server ({port: 3000});

wss.on ('connection', function connection (ws, request) {
  console.log ('Connected');
  ws.on ('message', function incoming (message) {
    let msg = JSON.parse (message);
    if (msg['type'] == 'login') {
      console.log (msg['username'] + ' ' + msg['password']);
      let db = fs.readFileSync('users.json')
      let users = JSON.parse(db)
      if (msg['username']==users['Username'] && msg['password']==users['Password']){
        console.log("True")
      }
    }
    if (msg['type'] == 'register') {
      let record = {Username: msg['username'], Password: msg['password']};

      fs.writeFileSync ('users.json', JSON.stringify (record));
    }
  });

  ws.send ('something');
});
