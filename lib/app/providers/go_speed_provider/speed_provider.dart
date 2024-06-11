import 'dart:math';
import 'package:flutter/material.dart';

import 'package:mobile_app_cognitive_rehabilitation/app/providers/providers.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/games/go_speed/go_speed.dart';

enum GoSpeedDifficulty {
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

enum SpeedEnum {
  start,
  arrow_right_alt,
  check,
  done_all,
  call,
  phone_in_talk,
  key,
  key_off,
  female,
  swipe_down_alt_outlined,
  sentiment_dissatisfied,
  sentiment_satisfied,
  workspace_premium,
  psychology,
  play_circle_outline,
  pause_circle_outline,
  alternate_email,
  power_settings_new,
  send_outlined,
  send_and_archive_outlined
}

GameDifficulty getGameDifficultyBySpeedDifficulty(
    GoSpeedDifficulty difficulty) {
  GameDifficulty gameDifficulty;

  var map = {
    GoSpeedDifficulty.Zero: GameDifficulty.easy,
    GoSpeedDifficulty.One: GameDifficulty.easy,
    GoSpeedDifficulty.Two: GameDifficulty.easy,
    GoSpeedDifficulty.Three: GameDifficulty.medium,
    GoSpeedDifficulty.Four: GameDifficulty.medium,
    GoSpeedDifficulty.Five: GameDifficulty.medium,
    GoSpeedDifficulty.Six: GameDifficulty.medium,
    GoSpeedDifficulty.Seven: GameDifficulty.hard,
    GoSpeedDifficulty.Eight: GameDifficulty.hard,
    GoSpeedDifficulty.Nine: GameDifficulty.hard,
    GoSpeedDifficulty.Ten: GameDifficulty.hard,
  };

  gameDifficulty = map[difficulty] ?? GameDifficulty.easy;

  return gameDifficulty;
}

double getLevelBySpeedDifficulty(GoSpeedDifficulty difficulty) {
  double gameDifficulty;

  var map = {
    GoSpeedDifficulty.Zero: 0.0,
    GoSpeedDifficulty.One: 1.0,
    GoSpeedDifficulty.Two: 2.0,
    GoSpeedDifficulty.Three: 3.0,
    GoSpeedDifficulty.Four: 4.0,
    GoSpeedDifficulty.Five: 5.0,
    GoSpeedDifficulty.Six: 6.0,
    GoSpeedDifficulty.Seven: 7.0,
    GoSpeedDifficulty.Eight: 8.0,
    GoSpeedDifficulty.Nine: 9.0,
    GoSpeedDifficulty.Ten: 10.0,
  };

  gameDifficulty = map[difficulty] ?? 0.0;

  return gameDifficulty;
}

Color getColorById(int id) {
  Color color;

  var map = {
    0: Colors.yellow[300]!,
    1: Colors.orange[300]!,
    2: Colors.red[400]!,
    3: Colors.pink[300]!,
    4: Colors.lightBlue[300]!,
    5: Colors.lightGreen[400]!,
    6: Colors.white,
    7: Colors.brown[300]!,
    8: Colors.grey[400]!,
    9: Colors.purple[300]!,
  };

  color = map[id] ?? Colors.purple[300]!;

  return color;
}

SpeedEnum getSpeedEnumById(int id) {
  SpeedEnum speedEnum;

  var map = {
    0: SpeedEnum.start,
    1: SpeedEnum.arrow_right_alt,
    2: SpeedEnum.check,
    3: SpeedEnum.done_all,
    4: SpeedEnum.call,
    5: SpeedEnum.phone_in_talk,
    6: SpeedEnum.key,
    7: SpeedEnum.key_off,
    8: SpeedEnum.female,
    9: SpeedEnum.swipe_down_alt_outlined,
    10: SpeedEnum.sentiment_dissatisfied,
    11: SpeedEnum.sentiment_satisfied,
    12: SpeedEnum.workspace_premium,
    13: SpeedEnum.psychology,
    14: SpeedEnum.play_circle_outline,
    15: SpeedEnum.pause_circle_outline,
    16: SpeedEnum.alternate_email,
    17: SpeedEnum.power_settings_new,
    18: SpeedEnum.send_outlined,
    19: SpeedEnum.send_and_archive_outlined,
  };

  speedEnum = map[id] ?? SpeedEnum.start;

  return speedEnum;
}

IconData getIconBySpeedEnum(SpeedEnum icon) {
  IconData iconData;

  var map = {
    SpeedEnum.start: Icons.start,
    SpeedEnum.arrow_right_alt: Icons.arrow_right_alt,
    SpeedEnum.check: Icons.check,
    SpeedEnum.done_all: Icons.done_all,
    SpeedEnum.call: Icons.call,
    SpeedEnum.phone_in_talk: Icons.phone_in_talk,
    SpeedEnum.key: Icons.key,
    SpeedEnum.key_off: Icons.key_off,
    SpeedEnum.female: Icons.female,
    SpeedEnum.swipe_down_alt_outlined: Icons.swipe_down_alt_outlined,
    SpeedEnum.sentiment_dissatisfied: Icons.sentiment_dissatisfied,
    SpeedEnum.sentiment_satisfied: Icons.sentiment_satisfied,
    SpeedEnum.workspace_premium: Icons.workspace_premium,
    SpeedEnum.psychology: Icons.psychology_outlined,
    SpeedEnum.play_circle_outline: Icons.play_circle_outline,
    SpeedEnum.pause_circle_outline: Icons.pause_circle_outline,
    SpeedEnum.alternate_email: Icons.alternate_email,
    SpeedEnum.power_settings_new: Icons.power_settings_new,
    SpeedEnum.send_outlined: Icons.send_outlined,
    SpeedEnum.send_and_archive_outlined: Icons.send_and_archive_outlined,
  };

  iconData = map[icon] ?? Icons.start;

  return iconData;
}

class GoSpeedProvider extends ChangeNotifier {
  late int userProgress,
      userLevel,
      userExp,
      userPlayTime,
      randColor,
      time,
      lives;
  late double multiplier, size;

  late bool enabled, navigation, gameUnlocked;

  late GameState gameState;
  late SpeedEnum speedIcon;

  Color? _color;
  Icon? icon;
  IconData? _iconData;

  Random _random = Random();

  GoSpeedDifficulty speedDifficulty;

  GoSpeedProvider(
      {this.userProgress = 0,
      this.userLevel = 0,
      this.userExp = 0,
      this.userPlayTime = 0,
      this.randColor = 0,
      this.time = 25,
      this.lives = 0,
      this.multiplier = 1.0,
      this.size = 150,
      this.enabled = false,
      this.navigation = false,
      this.gameUnlocked = false,
      this.gameState = GameState.Intro,
      this.speedIcon = SpeedEnum.start,
      this.speedDifficulty = GoSpeedDifficulty.Zero});

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

  set setMyDifficulty(GoSpeedDifficulty myDifficulty) {
    speedDifficulty = myDifficulty;
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

  void gameIntro() {
    gameState = GameState.Intro;
    notifyListeners();
  }

  void gameStart() {
    gameState = GameState.Start;
    notifyListeners();
  }

  void gamePlaying() {
    gameState = GameState.Playing;
    notifyListeners();
  }

  void gameOver() {
    gameState = GameState.GameOver;
    notifyListeners();
  }

  void gameReady() {
    gameState = GameState.GameReady;
    notifyListeners();
  }

  void clearIcon() {
    icon = null;
    notifyListeners();
  }

  void getIcon({GameDifficulty difficulty = GameDifficulty.easy}) {
    int sameIcon;
    switch (difficulty) {
      case GameDifficulty.easy:
        sameIcon = _random.nextInt(7);
        break;
      case GameDifficulty.medium:
        sameIcon = _random.nextInt(5);
        break;
      case GameDifficulty.hard:
        sameIcon = _random.nextInt(4);
        break;
      default:
        sameIcon = _random.nextInt(7);
        break;
    }
    if (sameIcon == 0) {
      int tempColor = _random.nextInt(10);
      while (tempColor == randColor) {
        tempColor = _random.nextInt(10);
      }
      randColor = tempColor;
      _color = getColorById(randColor);
      icon = Icon(
        _iconData,
        size: size,
        color: _color,
      );
    } else {
      int tempColor = _random.nextInt(10);
      while (tempColor == randColor) {
        tempColor = _random.nextInt(10);
      }
      randColor = tempColor;
      int randIcon = _random.nextInt(20);
      speedIcon = getSpeedEnumById(randIcon);
      _iconData = getIconBySpeedEnum(speedIcon);
      _color = getColorById(randColor);
      icon = Icon(
        _iconData,
        size: size,
        color: _color,
      );
    }
    notifyListeners();
  }
}
