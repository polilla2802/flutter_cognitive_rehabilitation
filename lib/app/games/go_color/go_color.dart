import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';

import 'package:flutter/material.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/providers/providers.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/games/go_color/game_panel.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/games/go_color/color_panel.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/common/common_widgets.dart';

enum GameState { Intro, Playing, Paused, GameOver, GameReady }

class GoColor extends FlameGame with HasTappables {
  static const description = '''
 In this game the goal is to decide if the meaning of the 
 top word matches the text color of the bottom word.
  ''';

  @override
  Color backgroundColor() => ConstValues.myBlackColor[100]!;

  late bool _spanish;
  late GoColorDifficulty _difficulty;

  late BuildContext? _context;
  late GameState _state;
  late Vector2? _screenSize;

  late final GamePanel _gamePanel;
  late final ColorPanel _colorPanel;

  GoColor(
      {BuildContext? context,
      GoColorDifficulty difficulty = GoColorDifficulty.Zero,
      int? highScore,
      int lives = 0,
      int time = 25,
      int level = 0,
      int exp = 0,
      double multiplier = 1.0,
      bool spanish = false}) {
    _spanish = spanish;
    _context = context;
    _difficulty = difficulty;
    _state = GameState.Intro;
    _gamePanel = GamePanel(
        lives: lives,
        time: time,
        level: level,
        exp: exp,
        highScore: highScore,
        context: context,
        spanish: _spanish,
        multiplier: multiplier,
        difficulty: getGameDifficultyByColorDifficulty(_difficulty));
    _colorPanel = ColorPanel(spanish: _spanish);
  }

  @override
  Future<void> onLoad() async {
    add(_gamePanel);
    add(_colorPanel);

    FlameAudio.bgm.initialize();
  }

  @override
  Future<void> onMount() async {
    disableNavigation();
    disableButtons();

    if (isIntro) {
      await FlameAudio.play('intro/start.mp3');
      await Future.delayed(const Duration(milliseconds: 1000), () async {
        start();
        await playBackgroundMusic();
      });
    }
  }

  @override
  void update(double dt) {
    if (isGameReady) {
      enableNavigation();
      disableButtons();
    }
    super.update(dt);
  }

  @override
  void onGameResize(Vector2? size) {
    _screenSize = size;
    super.onGameResize(size!);
  }

  bool get isIntro => _state == GameState.Intro;
  bool get isPlaying => _state == GameState.Playing;
  bool get isPaused => _state == GameState.Paused;
  bool get isGameOver => _state == GameState.GameOver;
  bool get isGameReady => _state == GameState.GameReady;
  GameState get getState => _state;

  set setState(GameState state) {
    _state = state;
  }

  Future<void> yes() async {
    await _colorPanel.checkYes();
  }

  Future<void> no() async {
    await _colorPanel.checkNo();
  }

  Future<void> correctAnswer() async {
    await _gamePanel.correct();
  }

  Future<void> incorrectAnswer() async {
    await _gamePanel.incorrect();
  }

  Future<void> playBackgroundMusic() async {
    switch (_difficulty) {
      case GoColorDifficulty.Zero:
        await FlameAudio.bgm.play('bg_music/bg-v0.mp3', volume: 0.5);
        break;
      case GoColorDifficulty.One:
        await FlameAudio.bgm.play('bg_music/bg-v1.mp3', volume: 0.5);
        break;
      case GoColorDifficulty.Two:
        await FlameAudio.bgm.play('bg_music/bg-v2.mp3', volume: 0.5);
        break;
      case GoColorDifficulty.Three:
        await FlameAudio.bgm.play('bg_music/bg-v3.mp3', volume: 0.5);
        break;
      case GoColorDifficulty.Four:
        await FlameAudio.bgm.play('bg_music/bg-v4.mp3', volume: 0.5);
        break;
      case GoColorDifficulty.Five:
        await FlameAudio.bgm.play('bg_music/bg-v5.mp3', volume: 0.5);
        break;
      case GoColorDifficulty.Six:
        await FlameAudio.bgm.play('bg_music/bg-v6.mp3', volume: 0.5);
        break;
      case GoColorDifficulty.Seven:
        await FlameAudio.bgm.play('bg_music/bg-v7.mp3', volume: 0.5);
        break;
      case GoColorDifficulty.Eight:
        await FlameAudio.bgm.play('bg_music/bg-v8.mp3', volume: 0.5);
        break;
      case GoColorDifficulty.Nine:
        await FlameAudio.bgm.play('bg_music/bg-v9.mp3', volume: 0.5);
        break;
      case GoColorDifficulty.Ten:
        await FlameAudio.bgm.play('bg_music/bg-v10.mp3', volume: 0.5);
        break;
      default:
        await FlameAudio.bgm.play('bg_music/bg-v0.mp3', volume: 0.5);
    }
  }

  Future<void> pauseBackgroundMusic() async {
    await FlameAudio.bgm.pause();
  }

  Future<void> resumeBackgroundMusic() async {
    await FlameAudio.bgm.resume();
  }

  Future<void> restart() async {
    await FlameAudio.play('intro/start.mp3');
    _colorPanel.resetColors();
    enableNavigation();
    enableButtons();
    setState = GameState.Playing;
    _gamePanel.setRecord = RecordState.oldRecord;
    _gamePanel.reset();
  }

  Future<void> gameOver() async {
    disableNavigation();
    disableButtons();
    getRandomEffect();
    await _gamePanel.addRecord();
  }

  void start() {
    enableNavigation();
    enableButtons();
    setState = GameState.Playing;
    _gamePanel.setRecord = RecordState.oldRecord;
    _gamePanel.reset();
  }

  void resetColors() {
    _colorPanel.resetColors();
  }

  void startTimer() {
    _gamePanel.startTimer();
  }

  void stopTimer() {
    _gamePanel.stopTimer();
  }

  void resumeTimer() {
    _gamePanel.resumeTimer();
  }

  void resetTimer() {
    _gamePanel.resetTimer();
  }

  void enableButtons() {
    Provider.of<GoColorProvider>(_context!, listen: false).enable();
  }

  void disableButtons() {
    Provider.of<GoColorProvider>(_context!, listen: false).disable();
  }

  void enableNavigation() {
    Provider.of<GoColorProvider>(_context!, listen: false).enableNavigation();
  }

  void disableNavigation() {
    Provider.of<GoColorProvider>(_context!, listen: false).disableNavigation();
  }

  void getRandomEffect() {
    Provider.of<TBIProvider>(_context!, listen: false).getRandomEffect();
  }

  void disposeGame() {
    FlameAudio.bgm.dispose();
    _gamePanel.stopTimer();
  }
}
