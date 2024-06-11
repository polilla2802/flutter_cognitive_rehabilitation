import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

class SkillManager {
  late CollectionReference userList;
  late DocumentReference<Map<String, dynamic>> snapshot;
  late DocumentSnapshot<Map<String, dynamic>> progress;

  SkillManager() {
    userList = FirebaseFirestore.instance.collection("users");
  }

  Future<int?> getFocus(String uid) async {
    print("[getFocus USER ID]: $uid");
    try {
      snapshot = userList.doc(uid).collection("Skills").doc("Focus");
      progress = await snapshot.get();

      return progress.data()!["value"];
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<int?> getLogic(String uid) async {
    print("[getLogic USER ID]: $uid");
    try {
      snapshot = userList.doc(uid).collection("Skills").doc("Logic");
      progress = await snapshot.get();

      return progress.data()!["value"];
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<int?> getReflex(String uid) async {
    print("[getReflex USER ID]: $uid");
    try {
      snapshot = userList.doc(uid).collection("Skills").doc("Reflex");
      progress = await snapshot.get();

      return progress.data()!["value"];
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<int?> getMemory(String uid) async {
    print("[getMemory USER ID]: $uid");
    try {
      snapshot = userList.doc(uid).collection("Skills").doc("Memory");
      progress = await snapshot.get();

      return progress.data()!["value"];
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<int?> getResponse(String uid) async {
    print("[getResponse USER ID]: $uid");
    try {
      snapshot = userList.doc(uid).collection("Skills").doc("Response");
      progress = await snapshot.get();

      return progress.data()!["value"];
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<int?> getSpeed(String uid) async {
    print("[getSpeed USER ID]: $uid");
    try {
      snapshot = userList.doc(uid).collection("Skills").doc("Speed");
      progress = await snapshot.get();

      return progress.data()!["value"];
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> addFocus(String uid, int raise, int focus) async {
    print("[addFocus USER ID]: $uid");

    int newFocus = focus + raise;
    try {
      await userList
          .doc(uid)
          .collection("Skills")
          .doc("Focus")
          .update({'value': newFocus.toInt()});
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> addLogic(String uid, int raise, int logic) async {
    print("[addFLogic USER ID]: $uid");

    int newLogic = logic + raise;
    try {
      await userList
          .doc(uid)
          .collection("Skills")
          .doc("Logic")
          .update({'value': newLogic.toInt()});
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> addMemory(String uid, int raise, int memory) async {
    print("[addMemory USER ID]: $uid");

    int newMemory = memory + raise;
    try {
      await userList
          .doc(uid)
          .collection("Skills")
          .doc("Memory")
          .update({'value': newMemory.toInt()});
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> addReflex(String uid, int raise, int reflex) async {
    print("[addReflex USER ID]: $uid");

    int newReflex = reflex + raise;
    try {
      await userList
          .doc(uid)
          .collection("Skills")
          .doc("Reflex")
          .update({'value': newReflex.toInt()});
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> addResponse(String uid, int raise, int response) async {
    print("[addResponse USER ID]: $uid");

    int newResponse = response + raise;
    try {
      await userList
          .doc(uid)
          .collection("Skills")
          .doc("Response")
          .update({'value': newResponse.toInt()});
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> addSpeed(String uid, int raise, int speed) async {
    print("[addSpeeed USER ID]: $uid");

    int newSpeed = speed + raise;
    try {
      await userList
          .doc(uid)
          .collection("Skills")
          .doc("Speed")
          .update({'value': newSpeed.toInt()});
    } catch (e) {
      print(e.toString());
    }
  }
}
