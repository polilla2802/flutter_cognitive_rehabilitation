import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/models/effect.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/models/core/result.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/providers/providers.dart';

class TBIProvider extends ChangeNotifier {
  late Effect? effect;
  late List<Result<Effect>>? effects;
  late Random random;
  late int lastRandom;
  late TBIManager tbiManager;

  TBIProvider({this.effect, this.effects}) {
    lastRandom = 0;
    random = Random();
    tbiManager = TBIManager();
  }

  bool navigation = false;

  set setEffect(Effect myEffect) {
    effect = myEffect;
    notifyListeners();
  }

  set setEffects(List<Result<Effect>>? myEffects) {
    effects = myEffects;
    notifyListeners();
  }

  Future<void> getEffects() async {
    var effectsRes = await tbiManager.getEffects();

    if (effectsRes == null) {
      print("there was an error trying to fecth effects");
      return;
    }

    setEffects = effectsRes;

    lastRandom = random.nextInt(effects!.length);

    notifyListeners();
  }

  void getRandomEffect() {
    int randInt = random.nextInt(effects!.length);

    while (randInt == lastRandom) {
      randInt = random.nextInt(effects!.length);
    }

    lastRandom = randInt;

    setEffect = effects![lastRandom].data!;
    notifyListeners();
  }
}
