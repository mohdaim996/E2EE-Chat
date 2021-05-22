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


    async insertContact(id,contact){
        if(id!=contact){
        return new Promise((resolve,rejects)=>{
            this.findUser(id).then((result)=>{
               
                if(result.length == 1 && result[0].username == id){
                    //id exist
                    this.findUser(contact).then((result)=>{
                        if(result.length == 1 && result[0].username == contact){
                            //contact exist
                            //check user in contact
                            this.findUserIn(id,'contacts').then((result)=>{
                                if(result.length == 1 && result[0].user == id){
                                    //id in contacts
                                    //check contact in contacts of user
                                    //if false update
                                    this.getcontacts(id).then((contacts)=>{
                                        let contactList =contacts[0].contacts.split(',')
                                         if(contactList.includes(contact)){
                                             //reject
                                            resolve(`${contact} already added to ${id}`)
                                            }else{
                                                //update
                                                contactList.push(contact)
                                                
                                                let q =new Promise((resolve)=>{
                                                    this.database.run(`UPDATE contacts SET contacts = "${contactList}" WHERE user = "${id}"`,function(err){if(err){resolve(err)}else{resolve('contact added')}})}
                                                    )
                                                q.name?rejects(q):resolve(q)
                                            }
                                    })
                                    
                                }else{
                                    //id not in contacts
                                    //insert id and contact
                                    let q =new Promise((resolve)=>{
                                        this.database.run(`insert into contacts(user,contacts)values("${id}", "${contact}")`,function(err){
                                            if(err){reject(err)}
                                        })
                                    })
                                    resolve(q)
                                }
                            })
                        }else{
                            //contact doesn't exist
                            //reject
                            resolve(`${contact} doesn't exist`)
                        }
                    })
                }else{
                    //id doesn't exist
                    //reject
                    resolve(`${id} doesn't exist`)
                }
            })
        })}else{
            return "can't add to your self"
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
                    reject(false)
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
                    reject(false)
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
                reject(false)
            }else{
                resolve(true)
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
                            reject(false)
                        )
                   
                    
                }
            })
        })
    }
    insertPK(id, pk){}
    findPK(id){}


}

userDatabase=new MyDB();
userDatabase.getUser('Moh').then((data)=>console.log({data}),(reason)=>console.log({reason}))


//exports.userDatabase;



