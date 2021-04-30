var WebSocketClient = require('websocket').client;

var client = new WebSocketClient();

client.on('connectFailed', function(error) {
    console.log('Connect Error: ' + error.toString());
});

client.on('connect', function(connection) {
    console.log('WebSocket Client Connected');
    connection.sendUTF('{"type":"login","username":"Moh","password":"moh"}');
    
    connection.on('error', function(error) {
        console.log("Connection Error: " + error.toString());
    });
    connection.on('close', function() {
        console.log('echo-protocol Connection Closed');
    });
    connection.on('message', function(message) {
        if (message.type === 'utf8') {
            console.log("Received: '" + message.utf8Data + "'");
        }
        const readline = require('readline').createInterface({
            input: process.stdin,
            output: process.stdout
          });
           
          readline.question('Send: ', msg => {
            console.log(`sent ${msg}!`);
            connection.sendUTF('{"type":"message","from":"Moh","to":"raze","message":"fggfx","stamp":"1"}');
            readline.close();
          });
    });
    
    function sendNumber() {
        if (connection.connected) {
            var number = Math.round(Math.random() * 0xFFFFFF);
            connection.sendUTF(number.toString());
            setTimeout(sendNumber, 1000);
        }
    }
    //sendNumber();
    const readline = require('readline').createInterface({
        input: process.stdin,
        output: process.stdout
      });
       
      readline.question('Send: ', msg => {
        console.log(`sent ${msg}!`);
        connection.sendUTF('{"type":"message","from":"Moh","to":"raze","message":"yujr","stamp":"1"}');
        readline.close();
      });
});

client.connect('ws://localhost:3000',['login','Moh','moh']);
