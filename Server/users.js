const fs = require ('fs');

module.exports = class Users{
    
    constructor( id, email, pass, socket, type, db){  
        this.id = id;
        this.email = email;
        this._pass = pass;
        this.socket = socket;
        this.isValid = this._validate();
        this.isUser = this._exist();
        this.isAuth = false;
        this.type = type;
        if(type == 'register'){
            console.log('registering...!');
            this._register(db,this.id,this._pass,this.email);
            console.log('logged');
        }
        if(type == 'login'){
            console.log('logging in')
            this._login(db,this.id,this._pass)
            if(this.isAuth){
                this._logConnection(this.id,this.socket)
            }
        }
    }
    _validate(){
        //implement
        return true;
    }

    _exist(){
        //implement
        return true;
    }
    
    _register(file,id,pass,email){
        var record = {Username: `${id}`, Email: `${email}`, Password:`${pass}`}
        
        let rawdata = JSON.parse(fs.readFileSync(`${file}`));
        rawdata.push(record);
        fs.writeFileSync (`${file}`, JSON.stringify (rawdata,null,2));
        
    }

    _login(file, id, pass){
        let rawdata = JSON.parse(fs.readFileSync(`${file}`));
        console.log(rawdata.length);
        
        rawdata.forEach(element=> {
            
            console.log("reading elemnts");
            console.log(element['Username'] == id,pass,element['Password'] )
            if(element['Username'] == id){
                console.log('id exist')
                if(element['Password'] == pass){
                    console.log('password match')
                    this.isAuth = true
                }
            }
        })
        
        ;
    }
    _logConnection(id,socket){
        let rawdata = JSON.parse(fs.readFileSync('./sockets.json'));
        rawdata[id]=socket;
        fs.writeFileSync ('./sockets.json', JSON.stringify (rawdata,null,2));
        return
    }
    toJson(){
        return JSON.stringify({Username: `${this.id}`, Email: `${this.email}`, Password:`${this._pass}`, User:`${this.isUser}`},null,2)
    }
    
}
