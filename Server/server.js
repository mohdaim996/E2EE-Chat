const fs = require ('fs');
const Users = require ('./users.js');
const db = require('./db.js');
const http = require('http');
const WebSocket = require('ws');
const { connection } = require('websocket');
const server = http.createServer();
const wss = new WebSocket.Server({ noServer: true });
var connections = {};
server.on('upgrade',async function upgrade(request, socket, head) {
  let [type, username, pass, email] = request.headers['sec-websocket-protocol'].split(',');
  type=type.trim();username=username.trim();pass=pass.trim();email=email?email.trim():undefined;
console.log({type, username, pass, email})
  if(type == 'login'){
    let user = new Users (
      (username = username),
      (pass = pass),
    );
      let logres = await user.login();
    if(user.isAuth == false){
      console.log('closing')
      
     
      socket.write('HTTP/1.1 401 Unauthorized\r\n\r\n');
      socket.destroy();
      wss.close();
      return
    }else{
      wss.handleUpgrade(request, socket, head, async function done(ws,request,client) {
        if (user.isAuth) {
          let contacts = await user.getContacts();
          let contactsList = [];
          if(contacts[0]){
            let temp = contacts[0].contacts.split(',');
            for (index in temp){
              let tmp = await userDatabase.findPK(temp[index])
              contactsList.push({"contact":temp[index],"key":tmp[0].key})
            }
             
          }
          console.log( {contactsList})
          console.log('Auth');
          ws.id = user.username;
          connections[user.username] = ws;
         
          connections[user.username].send (
            JSON.stringify ({
              type: 'login response',
              status: 'logged',
              user: user.username,
              contacts: contactsList?contactsList:'none'
            })
          );
        console.log('connection upgraded')
        wss.emit('connection', ws, request, client);
        return
        }
        });
    }}else if (type == 'register') {
      console.log ('registering: ' + username);
      let user = new Users (
        (username = username),
        (pass = pass),
        (email = email)       
      );
      
    let regStatus = await user.register();
    console.log({regStatus})
    if(regStatus != true){
      socket.write('HTTP/1.1 401 Unauthorized\r\n\r\n');
      socket.destroy();
      wss.close();
      return
    }else{
      wss.handleUpgrade(request, socket, head, async function done(ws,request,client) {
        console.log('account created');
        ws.id = user.username;
        connections[user.username] = ws;
        connections[user.username].send (
          JSON.stringify ({
            type: 'register response',
            status: 'registered',
            user: `${user.username}`,
            email: `${user.email}`
          })
        );
        socket.destroy()
        wss.close()
        });
    }
    }
      
  
  });



wss.on ('connection', async function connection (ws, request) {
 
  console.log (request.socket.remoteAddress);
  
  ws.on ('message', async function incoming (message) {
    let msg = JSON.parse (message);
    console.log (msg);
    
    if (msg['type'] == 'message') {
      let to = msg['to'];
      connections[to].send (
        JSON.stringify ({
          type: 'message',
          from: `${msg['from']}`,
          to: to,
          message:`${msg['message']}`,
          stamp: '1',
        })
      );
    }
    if (msg['type'] == 'query'){
      //TODO
      //database contact management implementation
      //send qurey result first
      //wait for add request
      //add contact to user; 
      let addStatus = await userDatabase.insertcontact( msg['by'],msg['contact'])
      let to = msg['by'];
      if(addStatus == true){
        console.log('contact added')
        connections[to].send(
        JSON.stringify({
          type:'contact',
          from:'server',
          contact:msg['contact']
        })
      )
      }else{
        connections[to].send(
          JSON.stringify({
            type:'contact error',
            from:'server',
            error: addStatus
          })
        )
      }
      
    }
    if(msg['type'] == 'keys'){
      let publishKey = await userDatabase.insertPK(msg['owner'],msg['keys'],msg['time'])
      console.log({publishKey})
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