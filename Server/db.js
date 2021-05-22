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

    async insertUser(id, email, pass){
        return await this.findUser(id).then((data)=>{
            if(data.length == 0){
            this.database.run(`insert into users(username,email,joined)values("${id}", "${email}","${currentDate()}")`,function(err,row){
                if(err) {
                    console.log(err.message)
                }});
            this.insertPass(id,pass);
        }else{
              return `User ${id} already exists`;  
            }     
        })
    }
    insertPass(id,pass){
        bcrypt.genSalt(saltRounds, (err, salt) => {
            bcrypt.hash(pass, salt, (err, hash) => {
                this.database.run(`insert into passwords(user, password,salt,created)values("${id}", "${hash}","${salt}","${currentDate()}")` )

            });
        });
    }

    insertContact(id, contact){
        return this.findUser(id).then((data)=>{
            
            if(data.length == 1 && data[0].username == id){
                
                return this.getcontacts(id,contact).then((contacts)=>{
                    let contactList =contacts[0].contacts.split(',')
                   console.log(contactList)
                    if(contactList.includes(contact)){
                            
                        return `${contact} already added to ${id}`
                    } else {
                        return this.findUser(contact).then((data)=>{
                            
                            if(data.length == 1 && data[0].username == contact){
                                
                                var newContacts = [];
                                contacts.every((contact)=>newContacts.push(contact.contacts))
                                newContacts.push(contact);
                                this.findUserIn(id,'contacts').then((data)=>{
                                    
                                    if(data.length == 1 && data[0].user == id){
                                        
                                        return this.database.run(`UPDATE contacts SET contacts = "${newContacts}" WHERE user = "${id}"`,function(err){if(err){console.log(err)}})
                                    } else if(data.length == 0){
                                        
                                        return this.database.run(`insert into contacts(user,contacts)values("${id}", "${contact}")`)}

                                })
                                }
                            else if(data.length == 0){return `${contact} doesn't exist`}                           
                            })
                    }
                })
            }else if(data.length == 0){return `${id} doesn't exist`}

        }

        )
    }
    insertMessage(sender, reciever, message){}
    getcontacts (id) {
        return new Promise((resolve,rejects)=>{
            this.database.all(`SELECT contacts FROM contacts WHERE user = "${id}"`, function(err,rows){
                resolve(rows)
            })   
        }) 
    }
    findUser (id) {
        return new Promise((resolve,rejects)=>{
            this.database.all(`SELECT username FROM users WHERE username = "${id}"`, function(err,rows){
                resolve(rows)
            })   
        }) 
    }
    findUserIn (id,table) {
        return new Promise((resolve,rejects)=>{
            this.database.all(`SELECT user FROM ${table} WHERE user = "${id}"`, function(err,rows){
                if(err){console.log("error",err);rejects('failed')}
                resolve(rows)
            })   
        }) 
    }
    getUser(id){
        let query = new Promise((resolve)=>this.database.each(`SELECT * FROM users WHERE username = "${id}"`,function(err, rows) {  
            if(err) {
                console.log(err.message)
            }
            console.log(rows)
        }))
        return query;
    }
    
    authUser(id, pass){}
    insertPK(id, pk){}
    findPK(id){}


}

userDatabase=new MyDB();
userDatabase.insertContact('ham','Moh').then((data)=>console.log('data',data))

//exports.userDatabase;



