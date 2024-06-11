import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/models/effect.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/models/core/result.dart';

class TBIManager {
  late CollectionReference tbiCollection;

  TBIManager() {
    tbiCollection = FirebaseFirestore.instance.collection("tbi");
  }

  Future<List<Result<Effect>>?> getEffects() async {
    print("[getEffects]");
    try {
      // Get docs from collection reference
      QuerySnapshot querySnapshot = await tbiCollection.get();

      // Get data from docs and convert map to List
      List<Result<Effect>> effects = querySnapshot.docs
          .map((doc) =>
              Effect.fromJson(data: doc.data() as Map<String, dynamic>))
          .toList();

      return effects;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
