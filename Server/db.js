const sqlite3 = require('sqlite3').verbose();
const bcrypt = require('bcrypt');
const saltRounds = 10;


function currentDate(){
    let date_ob = new Date();
    let date = ("0" + date_ob.getDate()).slice(-2);
    let month = ("0" + (date_ob.getMonth() + 1)).slice(-2);
    let year = date_ob.getFullYear();
    let hours = date_ob.getHours();
    let minutes = date_ob.getMinutes();
    let seconds = date_ob.getSeconds();
    let result = year + "-" + month + "-" + date + " " + hours + ":" + minutes + ":" + seconds;
    return result;
 }


 class MyDB{

    #dbName = 'SecGram';
    #dbPath = `./${this.dbName}.db`;
    #db = new sqlite3.Database(this.path);
    get dbName(){return this.#dbName;}
    get path(){return this.#dbPath;}
    get database(){return this.#db;}

    insertUser(id, email, pass){
        this.database.run(`insert into users(username,email,joined)values("${id}", "${email}","${currentDate()}")`,function(err,row){
            if(err) {
                console.log(err.message)
            }});
        this.insertPass(id,pass);
         
    }
    insertPass(id,pass){
        bcrypt.genSalt(saltRounds, (err, salt) => {
            bcrypt.hash(pass, salt, (err, hash) => {
                this.database.run(`insert into passwords(user, password,salt,created)values("${id}", "${hash}","${salt}","${currentDate()}")` )

            });
        });
    }

    insertContact(id, contact){}
    insertMessage(sender, reciever, message){}

    findUser(id){
        let query = this.database.each(`SELECT username FROM users WHERE username = "${id}"`,function(err, rows) {  
            if(err) {
                console.log(err.message)
            }
            console.log(rows)
        });
        return query;
    }

    getUser(id){
        let query = this.database.each(`SELECT * FROM users WHERE username = "${id}"`,function(err, rows) {  
            if(err) {
                console.log(err.message)
            }
            console.log(rows)
        });
        return query;
    }
    
    authUser(id, pass){}
    insertPK(id, pk){}
    findPK(id){}


}
 userDatabase = new MyDB();
exports.userDatabase;



