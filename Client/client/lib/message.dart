import 'package:client/users.dart';

class Messages {
  Contact contact;
  Users from;
  Users to;
  String message;
  String timeStamp;
  Messages(this.contact, this.from, this.to,this.message, this.timeStamp);
  Map<String, dynamic> toMap() {
    return {
      'contact': this.contact.username,
      'sender': this.from.username,
      'reciever': this.to.username,
      'message': this.message,
      'stamp': this.timeStamp
    };
  }
}
