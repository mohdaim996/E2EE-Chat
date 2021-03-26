const {request, ClientRequest, IncomingMessage} = require ('http');
const WebSocket = require ('ws');
const fs = require ('fs');
//const u = require ('./users.js');
const Users = require ('./users.js');
const wss = new WebSocket.Server ({port: 3000});

wss.on ('connection', function connection (ws, request) {
 /* let db = fs.readFileSync('users.json');
      let uu = JSON.parse(db);
      let x = uu["Moh"];
      x.send('hello');*/
      
      
  ws.on ('message', function incoming (message) {
    let msg = JSON.parse (message);
    if (msg['type'] == 'login') {
      
      let user = new Users (
        id = msg['username'],
        email = msg['email'],
        pass = msg['password'],
        socket = ws,
        type = 'login',
        db = 'users.json',
      );
      
      if (user.isAuth) {
       /* let rawdata = JSON.parse(fs.readFileSync('./sockets.json'));
        rawdata[user.id]=ws;
        fs.writeFileSync ('./sockets.json', JSON.stringify (rawdata,null,2));*/
        ws.id = user.id;

      }
      /*console.log (msg['username'] + ' ' + msg['password']);
      let db = fs.readFileSync('users.json')
      let users = JSON.parse(db)
      if (msg['username']==users['Username'] && msg['password']==users['Password']){
        console.log("True")
      }*/
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
    
  });

  ws.send ('{"type":"ID card","name":"Moh"}');
});
