class Users {
  String username;
  String email;
  Users(this.username);
  Map<String, dynamic> toMap() {
    return {'user': this.username};
  }
}

class User extends Users {
  User(String username) : super(username = username);
}

class Contact extends Users {
  Contact(String username): super(username = username);
}
