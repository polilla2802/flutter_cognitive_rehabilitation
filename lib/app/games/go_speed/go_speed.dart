import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

import 'package:mobile_app_cognitive_rehabilitation/app/providers/providers.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/games/go_speed/game_panel.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/games/go_speed/speed_panel.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/common/common_widgets.dart';

enum GameState { Intro, Start, Playing, Paused, GameOver, GameReady }

class GoSpeed extends FlameGame with HasTappables {
  static const description = '''
 In this game the main goal is to decide if 
 the current symbol match the previous symbol.
  ''';

  @override
  Color backgroundColor() => ConstValues.myBlackColor[100]!;

  late BuildContext? _context;
  late GoSpeedDifficulty _difficulty;
  late GameState _state;
  late Vector2? _screenSize;

  late final GamePanel _gamePanel;
  late final SpeedPanel _speedPanel;

  GoSpeed(
      {BuildContext? context,
      GoSpeedDifficulty difficulty = GoSpeedDifficulty.Zero,
      int? highScore,
      int lives = 0,
      int time = 25,
      int level = 0,
      int exp = 0,
      double multiplier = 1.0}) {
    _context = context;
    _state = GameState.Intro;
    _difficulty = difficulty;
    _gamePanel = GamePanel(
        difficulty: difficulty,
        highScore: highScore,
        level: level,
        exp: exp,
        lives: lives,
        time: time,
        multiplier: multiplier,
        context: context);
    _speedPanel = SpeedPanel(context: context);
  }

  @override
  Future<void> onLoad() async {
    add(_gamePanel);
    add(_speedPanel);

    FlameAudio.bgm.initialize();
  }

  @override
  Future<void> onMount() async {
    disableNavigation();
    disableButtons();
    clearIcon();
    print("ready");
    await intro();
    await playBackgroundMusic();
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

  GameDifficulty get getDifficulty =>
      getGameDifficultyBySpeedDifficulty(_difficulty);

  bool get isIntro => _state == GameState.Intro;
  bool get isStart => _state == GameState.Start;
  bool get isPlaying => _state == GameState.Playing;
  bool get isPaused => _state == GameState.Paused;
  bool get isGameOver => _state == GameState.GameOver;
  bool get isGameReady => _state == GameState.GameReady;
  GameState get getState => _state;

  set setState(GameState state) {
    _state = state;
  }

  Future<void> intro() async {
    setState = GameState.Intro;
    _gamePanel.reset();
    disableNavigation();
    disableButtons();
    Provider.of<GoSpeedProvider>(_context!, listen: false).gameIntro();
    Provider.of<GoSpeedProvider>(_context!, listen: false)
        .getIcon(difficulty: getGameDifficultyBySpeedDifficulty(_difficulty));
    _speedPanel.setSpeed =
        Provider.of<GoSpeedProvider>(_context!, listen: false).speedIcon;
    await Future.delayed(const Duration(milliseconds: 2500), () async {
      await start();
    });
  }

  Future<void> start() async {
    await FlameAudio.play('intro/start.mp3', volume: 1.0);
    setState = GameState.Start;
    Provider.of<GoSpeedProvider>(_context!, listen: false)
        .getIcon(difficulty: getGameDifficultyBySpeedDifficulty(_difficulty));
    Provider.of<GoSpeedProvider>(_context!, listen: false).gameStart();
    await Future.delayed(const Duration(milliseconds: 1000), () async {
      enableNavigation();
      enableButtons();
      setState = GameState.Playing;
      Provider.of<GoSpeedProvider>(_context!, listen: false).gamePlaying();
      _gamePanel.setRecord = RecordState.oldRecord;
      _gamePanel.startTimer();
    });
  }

  Future<void> yes() async {
    await _speedPanel.checkYes();
  }

  Future<void> no() async {
    await _speedPanel.checkNo();
  }

  Future<void> correctAnswer() async {
    await _gamePanel.correct();
  }

  Future<void> incorrectAnswer(SpeedEnum currentIcon) async {
    await _gamePanel.incorrect(currentIcon);
  }

  Future<void> playBackgroundMusic() async {
    switch (_difficulty) {
      case GoSpeedDifficulty.Zero:
        await FlameAudio.bgm.play('bg_music/bg-v0.mp3', volume: 0.5);
        break;
      case GoSpeedDifficulty.One:
        await FlameAudio.bgm.play('bg_music/bg-v1.mp3', volume: 0.5);
        break;
      case GoSpeedDifficulty.Two:
        await FlameAudio.bgm.play('bg_music/bg-v2.mp3', volume: 0.5);
        break;
      case GoSpeedDifficulty.Three:
        await FlameAudio.bgm.play('bg_music/bg-v3.mp3', volume: 0.5);
        break;
      case GoSpeedDifficulty.Four:
        await FlameAudio.bgm.play('bg_music/bg-v4.mp3', volume: 0.5);
        break;
      case GoSpeedDifficulty.Five:
        await FlameAudio.bgm.play('bg_music/bg-v5.mp3', volume: 0.5);
        break;
      case GoSpeedDifficulty.Six:
        await FlameAudio.bgm.play('bg_music/bg-v6.mp3', volume: 0.5);
        break;
      case GoSpeedDifficulty.Seven:
        await FlameAudio.bgm.play('bg_music/bg-v7.mp3', volume: 0.5);
        break;
      case GoSpeedDifficulty.Eight:
        await FlameAudio.bgm.play('bg_music/bg-v8.mp3', volume: 0.5);
        break;
      case GoSpeedDifficulty.Nine:
        await FlameAudio.bgm.play('bg_music/bg-v9.mp3', volume: 0.5);
        break;
      case GoSpeedDifficulty.Ten:
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

  Future<void> gameOver() async {
    disableNavigation();
    disableButtons();
    getRandomEffect();
    await _gamePanel.addRecord();
  }

  void setSpeed(SpeedEnum speed) {
    _speedPanel.setSpeed = speed;
  }

  void resetIcon() {
    _speedPanel.resetIcon();
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

  void clearIcon() {
    Provider.of<GoSpeedProvider>(_context!, listen: false).clearIcon();
  }

  void enableButtons() {
    Provider.of<GoSpeedProvider>(_context!, listen: false).enable();
  }

  void disableButtons() {
    Provider.of<GoSpeedProvider>(_context!, listen: false).disable();
  }

  void enableNavigation() {
    Provider.of<GoSpeedProvider>(_context!, listen: false).enableNavigation();
  }

  void disableNavigation() {
    Provider.of<GoSpeedProvider>(_context!, listen: false).disableNavigation();
  }

  void getRandomEffect() {
    Provider.of<TBIProvider>(_context!, listen: false).getRandomEffect();
  }

  void disposeGame() {
    FlameAudio.bgm.dispose();
    _gamePanel.stopTimer();
  }
}
