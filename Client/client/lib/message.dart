import 'package:client/users.dart';

class Messages {
  Users from;
  Contact contact;
  String message;
  String timeStamp;
  Map<String, dynamic> toMap() {
    return {
      'contact': this.contact.username,
      'from': this.from.username,
      'to': this.from.username,
      'message': this.message,
      'stamp':this.timeStamp
    };
  }
}
