import 'package:flutter/material.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/providers/providers.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/common/common_widgets.dart';

enum ColorEnum { yellow, orange, red, violet, blue, green, black }

enum GoColorDifficulty {
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

ColorEnum getColorEnumById(int id) {
  ColorEnum colorEnum;

  const map = {
    0: ColorEnum.yellow,
    1: ColorEnum.orange,
    2: ColorEnum.red,
    3: ColorEnum.violet,
    4: ColorEnum.blue,
    5: ColorEnum.green,
    6: ColorEnum.black
  };

  colorEnum = map[id] ?? ColorEnum.black;

  return colorEnum;
}

Color getColorByEnum(ColorEnum colorEnum) {
  Color color;

  var map = {
    ColorEnum.yellow: Colors.yellow[600]!,
    ColorEnum.orange: Colors.orange[700]!,
    ColorEnum.red: Colors.red,
    ColorEnum.violet: Colors.purple,
    ColorEnum.blue: Colors.blue,
    ColorEnum.green: Colors.green,
    ColorEnum.black: ConstValues.myBlackColor,
  };

  color = map[colorEnum] ?? ConstValues.myBlackColor;

  return color;
}

ColorEnum getColorEnumByString(String color) {
  ColorEnum colorEnum;

  var map = {
    "yellow": ColorEnum.yellow,
    "orange": ColorEnum.orange,
    "red": ColorEnum.yellow,
    "violet": ColorEnum.violet,
    "blue": ColorEnum.blue,
    "green": ColorEnum.green,
    "black": ColorEnum.black,
  };

  colorEnum = map[color] ?? ColorEnum.black;

  return colorEnum;
}

String getStringByColorEnum(ColorEnum color) {
  String colorText;

  var map = {
    ColorEnum.yellow: "yellow",
    ColorEnum.orange: "orange",
    ColorEnum.red: "red",
    ColorEnum.violet: "violet",
    ColorEnum.blue: "blue",
    ColorEnum.green: "green",
    ColorEnum.black: "black"
  };

  colorText = map[color] ?? "black";

  return colorText;
}

ColorEnum getColorEnumBySpanishString(String color) {
  ColorEnum colorEnum;

  var map = {
    "amarillo": ColorEnum.yellow,
    "naranja": ColorEnum.orange,
    "rojo": ColorEnum.yellow,
    "violeta": ColorEnum.violet,
    "azul": ColorEnum.blue,
    "verde": ColorEnum.green,
    "negro": ColorEnum.black,
  };

  colorEnum = map[color] ?? ColorEnum.black;

  return colorEnum;
}

String getSpanishStringByColorEnum(ColorEnum color) {
  String colorText;

  var map = {
    ColorEnum.yellow: "amarillo",
    ColorEnum.orange: "naranja",
    ColorEnum.red: "rojo",
    ColorEnum.violet: "violeta",
    ColorEnum.blue: "azul",
    ColorEnum.green: "verde",
    ColorEnum.black: "negro"
  };

  colorText = map[color] ?? "black";

  return colorText;
}

GameDifficulty getGameDifficultyByColorDifficulty(
    GoColorDifficulty difficulty) {
  GameDifficulty gameDifficulty;

  var map = {
    GoColorDifficulty.Zero: GameDifficulty.easy,
    GoColorDifficulty.One: GameDifficulty.easy,
    GoColorDifficulty.Two: GameDifficulty.easy,
    GoColorDifficulty.Three: GameDifficulty.medium,
    GoColorDifficulty.Four: GameDifficulty.medium,
    GoColorDifficulty.Five: GameDifficulty.medium,
    GoColorDifficulty.Six: GameDifficulty.medium,
    GoColorDifficulty.Seven: GameDifficulty.hard,
    GoColorDifficulty.Eight: GameDifficulty.hard,
    GoColorDifficulty.Nine: GameDifficulty.hard,
    GoColorDifficulty.Ten: GameDifficulty.hard,
  };

  gameDifficulty = map[difficulty] ?? GameDifficulty.easy;

  return gameDifficulty;
}

double getLevelByColorDifficulty(GoColorDifficulty difficulty) {
  double gameDifficulty;

  var map = {
    GoColorDifficulty.Zero: 0.0,
    GoColorDifficulty.One: 1.0,
    GoColorDifficulty.Two: 2.0,
    GoColorDifficulty.Three: 3.0,
    GoColorDifficulty.Four: 4.0,
    GoColorDifficulty.Five: 5.0,
    GoColorDifficulty.Six: 6.0,
    GoColorDifficulty.Seven: 7.0,
    GoColorDifficulty.Eight: 8.0,
    GoColorDifficulty.Nine: 9.0,
    GoColorDifficulty.Ten: 10.0,
  };

  gameDifficulty = map[difficulty] ?? 0.0;

  return gameDifficulty;
}

class GoColorProvider extends ChangeNotifier {
  int userProgress, userLevel, userExp, userPlayTime, time, lives;
  double multiplier;
  bool gameUnlocked;
  GoColorDifficulty colorDifficulty;

  GoColorProvider(
      {this.userProgress = 0,
      this.userLevel = 0,
      this.userExp = 0,
      this.userPlayTime = 0,
      this.time = 25,
      this.lives = 0,
      this.multiplier = 1.0,
      this.gameUnlocked = false,
      this.colorDifficulty = GoColorDifficulty.Zero});

  bool navigation = false;
  bool enabled = false;

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

  set setMyDifficulty(GoColorDifficulty myDifficulty) {
    colorDifficulty = myDifficulty;
    notifyListeners();
  }

  void enable() {
    enabled = true;
    notifyListeners();
  }

  void disable() {
    enabled = false;
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
