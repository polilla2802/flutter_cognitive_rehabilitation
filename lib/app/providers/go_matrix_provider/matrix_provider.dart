import 'package:flutter/material.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/providers/providers.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/games/go_matrix/go_matrix.dart';

enum GoMatrixDifficulty {
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

GameDifficulty getGameDifficultyByMatrixDifficulty(
    GoMatrixDifficulty difficulty) {
  GameDifficulty gameDifficulty;

  var map = {
    GoMatrixDifficulty.Zero: GameDifficulty.easy,
    GoMatrixDifficulty.One: GameDifficulty.easy,
    GoMatrixDifficulty.Two: GameDifficulty.easy,
    GoMatrixDifficulty.Three: GameDifficulty.medium,
    GoMatrixDifficulty.Four: GameDifficulty.medium,
    GoMatrixDifficulty.Five: GameDifficulty.medium,
    GoMatrixDifficulty.Six: GameDifficulty.medium,
    GoMatrixDifficulty.Seven: GameDifficulty.hard,
    GoMatrixDifficulty.Eight: GameDifficulty.hard,
    GoMatrixDifficulty.Nine: GameDifficulty.hard,
    GoMatrixDifficulty.Ten: GameDifficulty.hard,
  };

  gameDifficulty = map[difficulty] ?? GameDifficulty.easy;

  return gameDifficulty;
}

double getLevelByMatrixDifficulty(GoMatrixDifficulty difficulty) {
  double gameDifficulty;

  var map = {
    GoMatrixDifficulty.Zero: 0.0,
    GoMatrixDifficulty.One: 1.0,
    GoMatrixDifficulty.Two: 2.0,
    GoMatrixDifficulty.Three: 3.0,
    GoMatrixDifficulty.Four: 4.0,
    GoMatrixDifficulty.Five: 5.0,
    GoMatrixDifficulty.Six: 6.0,
    GoMatrixDifficulty.Seven: 7.0,
    GoMatrixDifficulty.Eight: 8.0,
    GoMatrixDifficulty.Nine: 9.0,
    GoMatrixDifficulty.Ten: 10.0,
  };

  gameDifficulty = map[difficulty] ?? 0.0;

  return gameDifficulty;
}

class GoMatrixProvider extends ChangeNotifier {
  int userProgress, userLevel, userExp, userPlayTime, time, lives, tiles, hints;
  double multiplier;
  bool gameUnlocked, paused, visiblePause, navigation;
  GameState gameState;
  GoMatrixDifficulty matrixDifficulty;

  GoMatrixProvider(
      {this.userProgress = 0,
      this.userLevel = 0,
      this.userExp = 0,
      this.userPlayTime = 0,
      this.time = 25,
      this.lives = 0,
      this.tiles = 5,
      this.hints = 0,
      this.multiplier = 1.0,
      this.gameUnlocked = false,
      this.paused = false,
      this.visiblePause = false,
      this.navigation = false,
      this.gameState = GameState.Intro,
      this.matrixDifficulty = GoMatrixDifficulty.Zero});

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

  set setMyDifficulty(GoMatrixDifficulty myDifficulty) {
    matrixDifficulty = myDifficulty;
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

  set setMyTiles(int myTiles) {
    tiles = myTiles;
    notifyListeners();
  }

  set setMyHints(int myHints) {
    hints = myHints;
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

  set pauseGame(bool pausedGame) {
    paused = pausedGame;
    notifyListeners();
  }

  set showPause(bool visible) {
    visiblePause = visible;
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

  void gameShowTiles() {
    gameState = GameState.ShowTiles;
    notifyListeners();
  }

  void gamePlaying() {
    gameState = GameState.Playing;
    notifyListeners();
  }

  void gameIncoreect() {
    gameState = GameState.Incorrect;
    notifyListeners();
  }

  void gamePaused() {
    gameState = GameState.Paused;
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
}
