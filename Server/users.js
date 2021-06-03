const fs = require ('fs');
const db = require('./db.js');
 module.exports=class Users{
    username;
    email;
    #pass;
    contacts;
    #isAuth = false;
    #isValid;
    socket;
    get isUser(){return this.exist();}
    get isAuth(){return this.#isAuth;}
    set #isAuthSet(state){this.#isAuth = state;}

    constructor( username, pass, email){  
        this.username = username;
        this.pass = pass;
        this.email = email;  
    }
    validate(){
        //implement
        return true;
    }

    async exist(){
        //implement
        let userExist = await userDatabase.findUser(this.username);
        return userExist;
    }
    
    async register(){
       let userExist = await this.isUser;
        if(userExist==false){
            if(!(this.username&&this.pass&&this.email)){
                throw 'Invalid data'
            }
        let inesrtResult = await userDatabase.insertUser(this.username, this.pass, this.email)
        return inesrtResult;}
        return 'username is taken';
    }

    async login(){
    let userExist = await this.isUser;
    if(userExist==true){   
        if(!(this.username&&this.pass)){
            throw 'Invalid data'
        }
        let authResult = await userDatabase.authUser(this.username, this.pass)
        this.#isAuthSet = authResult;
        return authResult;
        }
    return "username doesn't exist";
    } 
    async getContacts(){
        let userExist = await this.isUser;
        if(userExist==true){
            let contacts = await userDatabase.getcontacts(this.username)
            return contacts;
        }
        return "username doesn't exist"
    }
    async addContacts(contact){
        return await userDatabase(this.username, contact);
    }
}
