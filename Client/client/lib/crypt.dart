import 'dart:math';
import 'package:cryptography/cryptography.dart';

class Crypt {
  final List<int> g;
  final int m;
  final int p;
  List<int> public;

  Crypt({this.g, this.m, this.p}) {
    this.public = this.ecKeyGen(this.g[0], this.g[1], this.p, this.m);
  }

  List<int> ecKeyGen(int xx, int yy, int p, int m) {
    List<int> tmp = [1, 1];
    for (int i = 2; i <= p; i++) {
      if (i <= 2) {
        tmp = pdouble(xx, yy, 2, m);
      } else if (i > 2) {
        tmp = pAdd(xx, yy, tmp[0], tmp[1], m);
      }
    }
    return tmp;
  }

  dynamic sharedSec(int x, int y) async {
    Hash secret = await encKey(this.ecKeyGen(x, y, this.p, this.m));
  
      return secret;
    
  }

  dynamic encKey(List<int> sharedSec) async {
    final algorithm = Sha256();
    final sink = algorithm.newHashSink();

    sink.add(sharedSec);
    sink.close();

    final hash = await sink.hash();
    if (hash.runtimeType.toString() == 'Hash') {
      return hash;
    }
  }

  List<int> pdouble(int x, int y, int n, int m) {
    int stop = (((3 * pow(x, 2)) + n).toInt()) % m;
    int sbtm = gcd((2*y) ^ -1, m);
    int s = (stop * sbtm) % m;
    int xx = ((pow(s, 2) % m) - (2 * x) % m).toInt();
    int yy = ((s * (x - xx) % m) - y % m).toInt();
    return [xx, yy];
  }

  List<int> pAdd(int xp, int yp, int xq, int yq, int m) {
    try {
      //Slope
      int stop = (yq - yp);
      int sbtm = stop % (xq - xp) == 0 ? (xq - xp) : gcd((xq - xp) ^ -1, m);
      int s =
          stop % (xq - xp) == 0 ? ((stop ~/ sbtm) % m) : ((stop * sbtm) % m);
      //X-axis
      int xlft = s * s % m;
      int xrit = ((-xp) - xq) % m;
      int x = (xlft + xrit) % m;
      //Y-axis
      int ylft = (s * (xp - x)) % m;
      int y = (ylft - yp) % m;
      return [x, y];
    } catch (IntegerDivisionByZeroException) {
      return [0, 0];
    }
  }

  List<int> pSub(int xp, int yp, int xq, int yq, int m) {
    return pAdd(xp, -yp % m, xq, yq, m);
  }

  dynamic gcd(int a, int b) {
    for (int x = 1; x <= b; x++) {
      if ((((a ^ -1) * x) % b) == 1) {
        return x;
      }
    }
  }
}
