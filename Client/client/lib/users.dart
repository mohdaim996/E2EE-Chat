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
/*
boa 27 40 17
  80,14
[{contact: moa, pkx: 28, pky: 66, secret: [13, 247, 190, 117, 112, 246, 106, 54, 123, 239, 126, 69, 87, 39, 214, 88, 245, 167, 65, 0, 254, 197, 147, 243, 216, 45, 160, 211, 84, 153, 16, 11]},
 {contact: voa, pkx: 19, pky: 77, secret: [189, 171, 25, 15, 138, 135, 100, 225, 56, 183, 234, 202, 28, 222, 95, 54, 84, 148, 14, 217, 60, 251, 244, 36, 62, 168, 57, 180, 26, 228, 137, 255]}]

moa 28 66 85
{contact: voa, pkx: 19, pky: 77, secret: [146, 153, 252, 126, 246, 235, 137, 131, 41, 242, 173, 152, 164, 25, 184, 26, 4, 144, 199, 102, 36, 98, 80, 178, 32, 89, 27, 96, 183, 83, 41, 0]}]

voa 
contact: moa, pkx: 28, pky: 66, secret: [107, 89, 200, 252, 249, 28, 2, 162, 124, 70, 48, 31, 99, 72, 17, 248, 221, 255, 44, 13, 192, 162, 70, 217, 244, 147, 72, 36, 31, 102, 167, 67]}]
*/ 