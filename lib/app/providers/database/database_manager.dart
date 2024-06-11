import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseManager {
  late CollectionReference userList;

  DatabaseManager() {
    userList = FirebaseFirestore.instance.collection("users");
  }

  Future<bool> createUserProgress(String uid) async {
    print("[createUserProgress USER ID]: $uid");
    try {
      await userList
          .doc(uid)
          .collection('Game 1')
          .doc("High Score")
          .set({"value": 0});
      await userList
          .doc(uid)
          .collection('Game 1')
          .doc("Level")
          .set({"value": 0, "xp": 0});
      await userList
          .doc(uid)
          .collection('Game 1')
          .doc("Times Played")
          .set({"value": 0});
      await userList
          .doc(uid)
          .collection('Game 1')
          .doc("Unlocked")
          .set({"value": true});

      await userList
          .doc(uid)
          .collection('Game 2')
          .doc("High Score")
          .set({"value": 0});
      await userList
          .doc(uid)
          .collection('Game 2')
          .doc("Level")
          .set({"value": 0, "xp": 0});
      await userList
          .doc(uid)
          .collection('Game 2')
          .doc("Times Played")
          .set({"value": 0});
      await userList
          .doc(uid)
          .collection('Game 2')
          .doc("Unlocked")
          .set({"value": true});

      await userList
          .doc(uid)
          .collection('Game 3')
          .doc("High Score")
          .set({"value": 0});
      await userList
          .doc(uid)
          .collection('Game 3')
          .doc("Level")
          .set({"value": 0, "xp": 0});
      await userList
          .doc(uid)
          .collection('Game 3')
          .doc("Times Played")
          .set({"value": 0});
      await userList
          .doc(uid)
          .collection('Game 3')
          .doc("Unlocked")
          .set({"value": true});

      await userList
          .doc(uid)
          .collection('Game 4')
          .doc("High Score")
          .set({"value": 0});
      await userList
          .doc(uid)
          .collection('Game 4')
          .doc("Level")
          .set({"value": 0, "xp": 0});
      await userList
          .doc(uid)
          .collection('Game 4')
          .doc("Times Played")
          .set({"value": 0});
      await userList
          .doc(uid)
          .collection('Game 4')
          .doc("Unlocked")
          .set({"value": true});

      await userList
          .doc(uid)
          .collection('Skills')
          .doc("Focus")
          .set({"value": 0});

      await userList
          .doc(uid)
          .collection('Skills')
          .doc("Logic")
          .set({"value": 0});

      await userList
          .doc(uid)
          .collection('Skills')
          .doc("Memory")
          .set({"value": 0});

      await userList
          .doc(uid)
          .collection('Skills')
          .doc("Reflex")
          .set({"value": 0});

      await userList
          .doc(uid)
          .collection('Skills')
          .doc("Response")
          .set({"value": 0});

      await userList
          .doc(uid)
          .collection('Skills')
          .doc("Speed")
          .set({"value": 0});

      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> updateDocs(String uid) async {
    print("[updateDocs USER ID]: $uid");

    try {
      await userList
          .doc(uid)
          .collection('Skills')
          .doc("Focus")
          .set({"value": 0});

      await userList
          .doc(uid)
          .collection('Skills')
          .doc("Logic")
          .set({"value": 0});

      await userList
          .doc(uid)
          .collection('Skills')
          .doc("Memory")
          .set({"value": 0});

      await userList
          .doc(uid)
          .collection('Skills')
          .doc("Reflex")
          .set({"value": 0});

      await userList
          .doc(uid)
          .collection('Skills')
          .doc("Response")
          .set({"value": 0});

      await userList
          .doc(uid)
          .collection('Skills')
          .doc("Speed")
          .set({"value": 0});

      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
