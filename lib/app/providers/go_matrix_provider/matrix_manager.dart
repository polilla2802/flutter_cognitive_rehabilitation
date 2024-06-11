import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

class MatrixManager {
  late CollectionReference userList;
  late DocumentReference<Map<String, dynamic>> snapshot;
  late DocumentSnapshot<Map<String, dynamic>> progress;

  MatrixManager() {
    userList = FirebaseFirestore.instance.collection("users");
  }

  Future<int>? getHighScore(String uid) async {
    print("[getHighScore USER ID]: $uid");
    try {
      snapshot = userList.doc(uid).collection("Game 4").doc("High Score");
      progress = await snapshot.get();

      return progress.data()!["value"];
    } catch (e) {
      log(e.toString());
      return 0;
    }
  }

  Future<int>? getUserLevel(String uid) async {
    print("[getUserLevel USER ID]: $uid");
    try {
      snapshot = userList.doc(uid).collection("Game 4").doc("Level");
      progress = await snapshot.get();

      return progress.data()!["value"];
    } catch (e) {
      log(e.toString());
      return 0;
    }
  }

  Future<int>? getUserExp(String uid) async {
    print("[getUserExp USER ID]: $uid");
    try {
      snapshot = userList.doc(uid).collection("Game 4").doc("Level");
      progress = await snapshot.get();

      return progress.data()!["xp"];
    } catch (e) {
      log(e.toString());
      return 0;
    }
  }

  Future<int>? getUserPlayTime(String uid) async {
    print("[getUserPlayTime USER ID]: $uid");
    try {
      snapshot = userList.doc(uid).collection("Game 4").doc("Times Played");
      progress = await snapshot.get();

      return progress.data()!["value"];
    } catch (e) {
      log(e.toString());
      return 0;
    }
  }

  Future<bool>? getUnlockStatus(String uid) async {
    print("[getUnlockStatus USER ID]: $uid");
    try {
      snapshot = userList.doc(uid).collection("Game 4").doc("Unlocked");
      progress = await snapshot.get();

      return progress.data()!["value"];
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<void> addHighScore(String uid, int highScore) async {
    print("[addHighScore USER ID]: $uid");
    try {
      await userList
          .doc(uid)
          .collection("Game 4")
          .doc("High Score")
          .update({'value': highScore.toInt()});
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> addPlayTime(String uid) async {
    print("[addPlayTime USER ID]: $uid");
    try {
      snapshot = userList.doc(uid).collection("Game 4").doc("Times Played");
      progress = await snapshot.get();
      int newValue = progress["value"] + 1;

      await userList
          .doc(uid)
          .collection("Game 4")
          .doc("Times Played")
          .update({'value': newValue});
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> levelUp(
    String uid,
    int score,
  ) async {
    print("[levelUp USER ID]: $uid");

    MatrixManager _matrixManager = MatrixManager();

    int _userLevel = await _matrixManager.getUserLevel(uid)!;
    int _userExp = await _matrixManager.getUserExp(uid)!;
    print("level $_userLevel");
    print("exp $_userExp");

    int newExp = score + _userExp;

    if (newExp >= 15000) {
      _userLevel = _userLevel + 1;
      _userExp = newExp - 15000;
      if (_userLevel >= 100) {
        _userLevel = 100;
        _userExp = 15000;
      } else {
        if (_userExp > 15000) {
          _userLevel = _userLevel + 1;
          if (_userLevel == 100) {
            _userExp = 15000;
          } else {
            _userExp = _userExp - 15000;
          }
        }
      }
    } else {
      _userExp = newExp;
    }

    try {
      await userList
          .doc(uid)
          .collection("Game 4")
          .doc("Level")
          .update({'value': _userLevel.toInt(), 'xp': _userExp});
    } catch (e) {
      log(e.toString());
    }
  }
}