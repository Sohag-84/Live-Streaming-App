import 'package:flutter/cupertino.dart';
import 'package:twitch_clone/models/user.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(uid: "", username: "", email: "");

  User get user => _user;

  setUser({required User user}) {
    _user = user;
    notifyListeners();
  }
}
