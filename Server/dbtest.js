var mysql      = require('mysql');
var connection = mysql.createConnection({
    host     : '28ea9365c102.ngrok.io',
    port     : 8080,
    database : 'scs',
    user     : 'root',
    password : 'Mysql123',
    debug:true,
});

connection.connect(function(err) {
    if (err) {
        console.error('Error connecting: ' + err.stack);
        return;
    }

    console.log('Connected as id ' + connection.threadId);
});

connection.query('SELECT * FROM users', function (error, results, fields) {
    if (error){
        throw error;
    }
    results.forEach(result => {
        console.log(result);
    });
});

connection.end();