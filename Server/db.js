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
       return new Promise(async (resolve)=>{
           let userExist = await this.findUser(id);
           if(userExist==false){
            this.database.run(`insert into users(username,email,joined)values("${id}", "${email}","${currentDate()}")`,function(err){
                if(err) {
                    resolve(err);
                }
                
                resolve(`${id} has been inserted`);
            });
            this.insertPass(id,pass);
           }else{
               resolve(`${id} already exist`);
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


   
    async insertcontact(id,contact){
        if(id!=contact){
            let userExist = await this.findUser(id);
            let contactExist = await this.findUser(contact);
            let userExistIn = await this.findUser(id,'contacts');
            let userContacts = '';
            if(contactExist == true && userExist == true){
                userContacts = await this.getcontacts(id)
                userContacts = userContacts[0].contacts.split(',')
                if(userContacts.includes(contact)){
                    return `${contact} already added to ${id}`;
                }else{
                    userContacts.push(contact)
                }
                if(userExistIn == true){
                    return new Promise((resolve,reject)=>{
                        this.database.run(`UPDATE contacts SET contacts = "${userContacts}" WHERE user = "${id}"`,function (err){
                            if(err){reject(err)}
                            resolve(true)
                        })
                    })
                }else{
                    return new Promise((resolve,reject)=>{
                        this.database.run(`insert into contacts(user,contacts)values("${id}", "${contact}")`,function(err){
                            if(err){reject(err)}
                            resolve(true)
                        })
                    })
                }
            }else{
                return "id doesn't exist";
            }

        }else{
            return "cannot self add";
        }
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
        return new Promise((resolve,reject)=>{
            this.database.all(`SELECT username FROM users WHERE username = "${id}"`, function(err,rows){
                if(err){
                    reject(err)
                }
                if(rows.length==0){
                    resolve(false)
                }else{
                    resolve(true)
                }
            })   
        }) 
    }


    findUserIn (id,table) {
        return new Promise((resolve,rejects)=>{
            this.database.all(`SELECT user FROM ${table} WHERE user = "${id}"`, function(err,rows){
                if(err){rejects('failed')}
                if(rows.length==0){
                    resolve(false)
                }else{
                    resolve(true)
                }
            })   
        }) 
    }


    getUser(id){
        return new Promise((resolve,reject)=>{
        this.database.all(`SELECT * FROM users WHERE username = "${id}"`,function(err, rows) {  
            if(err) {
                reject('failed')
            }
            if(rows.length==0){
                resolve(`${id} doesn't exist`)
            }else{
                resolve(rows)
            }

        })}
        )
        
    }
    
    authUser(id, pass){
        return new Promise( (resolve,reject)=>{
            this.findUser(id).then(async(result)=>{
                if(result.length == 1 && result[0].username == id){
                    

                    let salt = await new Promise((resolve,rejects)=>{
                        this.database.all(`SELECT salt FROM passwords WHERE user = "${id}"`, function(err,rows){
                            resolve(rows)
                        })   
                    }) ;
                    let password = await new Promise((resolve,rejects)=>{
                        this.database.all(`SELECT password FROM passwords WHERE user = "${id}"`, function(err,rows){
                            resolve(rows)
                        })   
                    }) ;
                    let passhash = await new Promise((resolve)=>{
                        bcrypt.hash(pass, salt[0].salt, (err, hash) => {
                            if(err){console.log(err,{pass},{salt})}
                            resolve(hash)
                        });
                    })
                    
                        if(passhash == password[0].password){
                            resolve(true)
                        }else(
                            resolve(false)
                        )
                   
                    
                }
            })
        })
    }
    insertPK(id, pk){}
    findPK(id){}


}

userDatabase=new MyDB();
userDatabase.getUser('j;').then((value)=>console.log(value))
//exports.userDatabase;



