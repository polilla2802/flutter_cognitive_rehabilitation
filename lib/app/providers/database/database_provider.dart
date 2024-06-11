import 'package:flutter/material.dart';

class DatabaseProvider extends ChangeNotifier {
  late bool userReady;

  DatabaseProvider({this.userReady = false});

  set setUserReady(bool myUserReady) {
    this.userReady = myUserReady;
    notifyListeners();
  }
}
