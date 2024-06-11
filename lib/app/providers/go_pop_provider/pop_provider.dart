import 'package:flutter/material.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/providers/providers.dart';

enum GoPopDifficulty {
  Zero,
  One,
  Two,
  Three,
  Four,
  Five,
  Six,
  Seven,
  Eight,
  Nine,
  Ten,
  Undefined
}

GameDifficulty getGameDifficultyByPopDifficulty(GoPopDifficulty difficulty) {
  GameDifficulty gameDifficulty;

  var map = {
    GoPopDifficulty.Zero: GameDifficulty.easy,
    GoPopDifficulty.One: GameDifficulty.easy,
    GoPopDifficulty.Two: GameDifficulty.easy,
    GoPopDifficulty.Three: GameDifficulty.medium,
    GoPopDifficulty.Four: GameDifficulty.medium,
    GoPopDifficulty.Five: GameDifficulty.medium,
    GoPopDifficulty.Six: GameDifficulty.medium,
    GoPopDifficulty.Seven: GameDifficulty.hard,
    GoPopDifficulty.Eight: GameDifficulty.hard,
    GoPopDifficulty.Nine: GameDifficulty.hard,
    GoPopDifficulty.Ten: GameDifficulty.hard,
  };

  gameDifficulty = map[difficulty] ?? GameDifficulty.easy;

  return gameDifficulty;
}

double getLevelByPopDifficulty(GoPopDifficulty difficulty) {
  double gameDifficulty;

  var map = {
    GoPopDifficulty.Zero: 0.0,
    GoPopDifficulty.One: 1.0,
    GoPopDifficulty.Two: 2.0,
    GoPopDifficulty.Three: 3.0,
    GoPopDifficulty.Four: 4.0,
    GoPopDifficulty.Five: 5.0,
    GoPopDifficulty.Six: 6.0,
    GoPopDifficulty.Seven: 7.0,
    GoPopDifficulty.Eight: 8.0,
    GoPopDifficulty.Nine: 9.0,
    GoPopDifficulty.Ten: 10.0,
  };

  gameDifficulty = map[difficulty] ?? 0.0;

  return gameDifficulty;
}

class GoPopProvider extends ChangeNotifier {
  int userProgress, userLevel, userExp, userPlayTime, time, lives;
  bool gameUnlocked;
  double multiplier;
  GoPopDifficulty popDifficulty;

  GoPopProvider(
      {this.userProgress = 0,
      this.userLevel = 0,
      this.userExp = 0,
      this.userPlayTime = 0,
      this.time = 25,
      this.lives = 0,
      this.multiplier = 1.0,
      this.gameUnlocked = false,
      this.popDifficulty = GoPopDifficulty.Zero});

  bool navigation = false;

  set setMyProgress(int myProgress) {
    userProgress = myProgress;
    notifyListeners();
  }

  set setMyLevel(int myLevel) {
    userLevel = myLevel;
    notifyListeners();
  }

  set setMyExp(int myExp) {
    userExp = myExp;
    notifyListeners();
  }

  set setMyPlayTime(int myPlayTime) {
    userPlayTime = myPlayTime;
    notifyListeners();
  }

  set setMyTime(int myTime) {
    time = myTime;
    notifyListeners();
  }

  set setMyLives(int myLives) {
    lives = myLives;
    notifyListeners();
  }

  set setMyMultiplier(double myMultiplier) {
    multiplier = myMultiplier;
    notifyListeners();
  }

  set setMyUnlock(bool myUnlock) {
    gameUnlocked = myUnlock;
    notifyListeners();
  }

  set setMyDifficulty(GoPopDifficulty myDifficulty) {
    popDifficulty = myDifficulty;
    notifyListeners();
  }

  void enableNavigation() {
    navigation = true;
    notifyListeners();
  }

  void disableNavigation() {
    navigation = false;
    notifyListeners();
  }
}
