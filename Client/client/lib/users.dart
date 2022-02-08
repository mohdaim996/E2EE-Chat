import 'main.dart' as main;
import 'crypt.dart';
import 'dart:math';

class Users {
  String username;
  String email;
  int pkx;
  int pky;
  Users(this.username);
  Map<String, dynamic> toMap() {
    return {'user': this.username};
  }
}

class User extends Users {
  User(String username) : super(username = username);
  int private;
  Crypt keys;
  void addKeys(pkx, pky, private) {
    
    if (pkx == null && pky == null) {
      int m = 97;
      List<int> g = [12, 69];
       this.keys = createKeyRand(g, m, new Random.secure());
      this.pkx = keys.public[0];
      this.pky = keys.public[1];
      this.private = keys.p;
      main.db.updateKeys(this.pkx, this.pky, this.private);
      main.sock.publishKeys(this.username, [this.pkx, this.pky]);
    } else {
      int m = 97;
      List<int> g = [12, 69];
      this.pkx = int.parse(pkx);
      this.pky = int.parse(pky);
      this.private = private;
      this.keys = createKey(g, m,  private);
    }
  }

  Crypt createKey(g, m, p) {
    
    Crypt keys = new Crypt(g: g, m: m, p: p);
    return keys.public[0] == 0 ? createKey(g, m, p) : keys.onCurve()?keys:createKey(g, m, p);
  }
   Crypt createKeyRand(g, m, p) {
    
    Crypt keys = new Crypt(g: g, m: m, p: p.nextInt(m));
    return keys.public[0] == 0 ? createKey(g, m, p.nextInt(m)) : keys.onCurve()?keys:createKey(g, m, p.nextInt(m));
  }
}

class Contact extends Users {
  Contact(String username) : super(username = username);
}
