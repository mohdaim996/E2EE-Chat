var WebSocketServer = require('websocket').server;

var http = require('http');
var webSockets = {}
var server = http.createServer(function(request, response) {
    console.log((new Date()) + ' Received request for ' + request.url);
   
    
    response.end();
});
server.listen(3000, function() {
    console.log((new Date()) + ' Server is listening on port 8080');
});

wsServer = new WebSocketServer({
    httpServer: server,
    // You should not use autoAcceptConnections for production
    // applications, as it defeats all standard cross-origin protection
    // facilities built into the protocol and the browser.  You should
    // *always* verify the connection's origin and decide whether or not
    // to accept it.
    autoAcceptConnections: false
});

function originIsAllowed(origin) {
  // put logic here to detect whether the specified origin is allowed.
  return true;
}

wsServer.on('request', function(request) {
    if (!originIsAllowed(request.origin)) {
      // Make sure we only accept requests from an allowed origin
      request.reject();
      console.log((new Date()) + ' Connection from origin ' + request.origin + ' rejected.');
      return;
    }
    
    var connection = request.accept(null, request.origin);
    var userID = connection.remoteAddress 
    
    webSockets[userID] = connection
    console.log('connected: ' + userID + ' in ' + Object.getOwnPropertyNames(webSockets))
    console.log(webSockets)
    console.log((new Date()) + ' Connection accepted.');
    webSockets[userID].sendUTF('Hi this is WebSocket server!');
    webSockets[userID].on('message', function(message) {
        
      
        if (message.type === 'utf8') {
            console.log('Received Message: ' + message.utf8Data);
            webSockets['213.166.147.62'].sendUTF(message.utf8Data)
            
           /* const readline = require('readline').createInterface({
                input: process.stdin,
                output: process.stdout
              });
               
              readline.question('Send: ', msg => {
                console.log(`sent ${msg}!`);
                connection.sendUTF(msg);
                readline.close();
              });*/
        }
        else if (message.type === 'binary') {
            console.log('Received Binary Message of ' + message.binaryData.length + ' bytes');
            connection.sendBytes(message.binaryData);
        }
        
    });
    connection.on('close', function(reasonCode, description) {
        console.log((new Date()) + ' Peer ' + connection.remoteAddress + ' disconnected.');
    });
});