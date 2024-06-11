import 'package:flutter/material.dart';

enum GameDifficulty { easy, medium, hard, undefined }

class GameProvider extends ChangeNotifier {
  late GameDifficulty gameDifficulty;
  late bool focusReady,
      logicReady,
      memoryReady,
      reflexReady,
      responseReady,
      speedReady;
  late int focus, logic, memory, reflex, response, speed;

  GameProvider(
      {this.gameDifficulty = GameDifficulty.easy,
      this.focusReady = false,
      this.logicReady = false,
      this.memoryReady = false,
      this.reflexReady = false,
      this.responseReady = false,
      this.speedReady = false,
      this.focus = 0,
      this.logic = 0,
      this.memory = 0,
      this.reflex = 0,
      this.response = 0,
      this.speed = 0});

  set setMyDifficulty(GameDifficulty myDifficulty) {
    this.gameDifficulty = myDifficulty;
    notifyListeners();
  }

  set setMyFocusReady(bool myFocusReady) {
    this.focusReady = myFocusReady;
    notifyListeners();
  }

  set setMyFocus(int myFocus) {
    this.focus = myFocus;
    notifyListeners();
  }

  set setMyLogicReady(bool myLogicReady) {
    this.logicReady = myLogicReady;
    notifyListeners();
  }

  set setMyLogic(int myLogic) {
    this.logic = myLogic;
    notifyListeners();
  }

  set setMyMemoryReady(bool myMemoryReady) {
    this.memoryReady = myMemoryReady;
    notifyListeners();
  }

  set setMyMemory(int myMemory) {
    this.memory = myMemory;
    notifyListeners();
  }

  set setMyReflexReady(bool myReflexReady) {
    this.reflexReady = myReflexReady;
    notifyListeners();
  }

  set setMyReflex(int myReflex) {
    this.reflex = myReflex;
    notifyListeners();
  }

  set setMyResponseReady(bool myResponseReady) {
    this.responseReady = myResponseReady;
    notifyListeners();
  }

  set setMyResponse(int myResponse) {
    this.response = myResponse;
    notifyListeners();
  }

  set setMySpeedReady(bool mySpeedReady) {
    this.speedReady = mySpeedReady;
    notifyListeners();
  }

  set setMySpeed(int mySpeed) {
    this.speed = mySpeed;
    notifyListeners();
  }
}
