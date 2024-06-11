import 'dart:math';

import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' hide Image;

import 'package:mobile_app_cognitive_rehabilitation/app/providers/providers.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/games/go_pop/shine.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/games/go_pop/polygon.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/games/go_pop/pause_pop.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/games/go_pop/game_panel.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/common/common_widgets.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/providers/game_provider/game_provider.dart'
    as GameProvider;
import 'package:mobile_app_cognitive_rehabilitation/app/providers/skills/skill_manager.dart'
    as Skill;

enum GameState { Intro, Playing, Paused, GameOver, GameReady }

enum RecordState { newRecord, oldRecord }

class GoPop extends FlameGame with HasTappables {
  static const description = '''
 In this game the goal is to tap the hexagon as fast 
 as possible before time runs out!, each time you tap 
 the hexagon, it changes position! So watch out! Try 
 to beat your own record.
  ''';

  late User? _user;
  late PopManager? _popManager;

  @override
  Color backgroundColor() => ConstValues.myBlackColor[100]!;

  late BuildContext? _context;

  late bool _shine;
  late GoPopDifficulty _difficulty;

  static late Random _random;
  static late Vector2? _screenSize;

  late final LowPolygon _polygonEasy;
  late final LowPolygon _polygonMedium;
  late final LowPolygon _polygonHard;

  late final Shine _shineEasy;
  late final Shine _shineMedium;
  late final Shine _shineHard;

  late final GamePanel _gamePanel;
  late final PausePop _pausePop;

  late final TextComponent _scoreText;
  late final TextComponent _highScoreText;
  late final TextComponent _timeText;
  late final TextComponent _livesText;
  late TextPaint _textRenderer;

  static late Timer _timer;
  late int _time;
  late int _lives;
  late int _level;
  late int _exp;
  late int gameScore;
  late int _highscore;
  late double _multiplier;

  late GameState _state;
  late RecordState _recordState;
  late Skill.SkillManager _skillManager;

  GoPop(
      {BuildContext? context,
      GoPopDifficulty difficulty = GoPopDifficulty.Zero,
      int? highScore,
      bool shine = false,
      int level = 0,
      int exp = 0,
      int lives = 0,
      int time = 25,
      double multiplier = 1.0}) {
    _context = context;
    _shine = shine;
    _multiplier = multiplier;
    _user = FirebaseAuth.instance.currentUser != null
        ? FirebaseAuth.instance.currentUser!
        : null;
    _skillManager = Skill.SkillManager();
    _popManager = PopManager();
    _random = new Random();
    _state = GameState.Intro;
    _difficulty = difficulty;
    _recordState = RecordState.oldRecord;
    _timer = Timer(1, repeat: true);
    _time = time;
    _lives = lives;
    _level = level;
    _exp = exp;
    gameScore = 0;
    _highscore = highScore != null ? highScore : 0;
    _gamePanel = GamePanel(shine: _shine);
    _textRenderer = TextPaint(
        style: GoogleFonts.poppins(
            color: ConstValues.whiteColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            shadows: [
          Shadow(
              blurRadius: 2,
              color: Colors.black,
              offset: Offset.fromDirection(100))
        ]));
    _scoreText = TextComponent(
      textRenderer: _textRenderer,
    )
      ..positionType = PositionType.viewport
      ..anchor = Anchor.centerLeft;
    _highScoreText =
        TextComponent(textRenderer: _textRenderer, anchor: Anchor.center)
          ..positionType = PositionType.viewport
          ..anchor = Anchor.centerRight;
    _timeText = TextComponent(
      textRenderer: _textRenderer,
    )
      ..positionType = PositionType.viewport
      ..anchor = Anchor.centerRight;
    _pausePop = PausePop()..anchor = Anchor.centerRight;
    _livesText = TextComponent(
      textRenderer: _textRenderer,
    )
      ..positionType = PositionType.viewport
      ..anchor = Anchor.centerRight;
    setScore = 0;
    setHighScore = _highscore;
    setTime = _time;
    _lives == 0 ? null : setLives = _lives;
  }

  @override
  Future<void> onLoad() async {
    if (_shine) {
      _addShines();
    } else {
      _addHexagons();
    }
    add(_gamePanel);
    add(_scoreText);
    add(_highScoreText);
    add(_timeText);
    add(_pausePop);
    _lives == 0 ? null : add(_livesText);

    _timer.onTick = () async {
      if (_time <= 1) {
        setTime = 0;
        await gameOver();
      } else {
        setTime = _time -= 1;
      }
    };

    FlameAudio.bgm.initialize();
  }

  void _addShines() {
    double level = getLevelByPopDifficulty(_difficulty);

    if (level >= 0 && level < 3) {
      add(_shineEasy = Shine(
        multiplier: _multiplier,
        difficulty: GameDifficulty.easy,
      ));
    } else if (level >= 3 && level < 7) {
      add(_shineEasy = Shine(
        multiplier: _multiplier,
        difficulty: GameDifficulty.easy,
      ));
      add(_shineMedium = Shine(
        multiplier: _multiplier,
        difficulty: GameDifficulty.medium,
      ));
    } else {
      add(_shineEasy = Shine(
        multiplier: _multiplier,
        difficulty: GameDifficulty.easy,
      ));
      add(_shineMedium = Shine(
        multiplier: _multiplier,
        difficulty: GameDifficulty.medium,
      ));
      add(_shineHard = Shine(
        multiplier: _multiplier,
        difficulty: GameDifficulty.hard,
      ));
    }
  }

  void _addHexagons() {
    double level = getLevelByPopDifficulty(_difficulty);

    if (level >= 0 && level < 3) {
      add(_polygonEasy = LowPolygon(
        multiplier: _multiplier,
        difficulty: GameDifficulty.easy,
      ));
    } else if (level >= 3 && level < 7) {
      add(_polygonEasy = LowPolygon(
        multiplier: _multiplier,
        difficulty: GameDifficulty.easy,
      ));
      add(_polygonMedium = LowPolygon(
        multiplier: _multiplier,
        difficulty: GameDifficulty.medium,
      ));
    } else {
      add(_polygonEasy = LowPolygon(
        multiplier: _multiplier,
        difficulty: GameDifficulty.easy,
      ));
      add(_polygonMedium = LowPolygon(
        multiplier: _multiplier,
        difficulty: GameDifficulty.medium,
      ));
      add(_polygonHard = LowPolygon(
        multiplier: _multiplier,
        difficulty: GameDifficulty.hard,
      ));
    }
  }

  @override
  Future<void> onMount() async {
    Provider.of<GoPopProvider>(_context!, listen: false).disableNavigation();
    print("ready");
    if (!isIntro) {
      return;
    }

    if (_shine) {
      await playIntroFox();
    } else {
      await playIntro();
    }
    await Future.delayed(const Duration(milliseconds: 1500), () async {
      start();
      await playBackgroundMusic();
    });
  }

  @override
  void onGameResize(Vector2? size) {
    _screenSize = size;
    _scoreText..position = Vector2(16, _screenSize!.y - 20);
    _highScoreText
      ..position = Vector2(_screenSize!.x - 16, _screenSize!.y - 20);
    _livesText..position = Vector2(_screenSize!.x - 16, 65);
    _timeText..position = Vector2(_screenSize!.x - 50, 32);
    _pausePop..position = Vector2(_screenSize!.x - 8, 32);
    super.onGameResize(size!);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isIntro) {
      _timer.reset();
      return;
    }

    if (isPlaying) {
      _timer.update(dt);
      Provider.of<GoPopProvider>(_context!, listen: false).enableNavigation();
      return;
    }

    if (isPaused) {
      stopTimer();
      Provider.of<GoPopProvider>(_context!, listen: false).disableNavigation();
      return;
    }

    if (isGameOver) {
      stopTimer();
      return;
    }

    if (isGameReady) {
      Provider.of<GoPopProvider>(_context!, listen: false).enableNavigation();
    }
  }

  void start() {
    Provider.of<GoPopProvider>(_context!, listen: false).enableNavigation();
    setState = GameState.Playing;
    resetPositions();
    startTimer();
  }

  void resetPositions() {
    double level = getLevelByPopDifficulty(_difficulty);

    if (_shine) {
      if (level >= 0 && level < 3) {
        double x = getRandomPositionX();
        double y = getRandomPositionShineY();
        _shineEasy.position = Vector2(x, y);
      } else if (level >= 3 && level < 7) {
        double x = getRandomPositionX();
        double y = getRandomPositionShineY();
        _shineEasy.position = Vector2(x, y);
        _getMediumShinePosition();
      } else {
        double x = getRandomPositionX();
        double y = getRandomPositionShineY();
        _shineEasy.position = Vector2(x, y);
        _getMediumShinePosition();
        _getHardShinePosition();
      }
    } else {
      if (level >= 0 && level < 3) {
        double x = getRandomPositionX();
        double y = getRandomPositionY();
        _polygonEasy.position = Vector2(x, y);
      } else if (level >= 3 && level < 7) {
        double x = getRandomPositionX();
        double y = getRandomPositionY();
        _polygonEasy.position = Vector2(x, y);
        _getMediumPosition();
      } else {
        double x = getRandomPositionX();
        double y = getRandomPositionY();
        _polygonEasy.position = Vector2(x, y);
        _getMediumPosition();
        _getHardPosition();
      }
    }
  }

  void _getMediumShinePosition() {
    double x = getRandomPositionX();
    double y = getRandomPositionShineY();
    double minusX = _shineEasy.position.x - 60;
    double plusX = _shineEasy.position.x + 60;
    double minusY = _shineEasy.position.y - 65;
    double plusY = _shineEasy.position.y + 65;
    while (minusX <= x && x <= plusX) {
      x = getRandomPositionX();
    }
    while (minusY <= y && y <= plusY) {
      y = getRandomPositionShineY();
    }
    _shineMedium.position = Vector2(x, y);
  }

  void _getHardShinePosition() {
    double x = getRandomPositionX();
    double y = getRandomPositionShineY();
    double minusEasyShineX = _shineEasy.position.x - 60;
    double plusEasyShineX = _shineEasy.position.x + 60;
    double minusEasyshineY = _shineEasy.position.y - 65;
    double plusEasyshineY = _shineEasy.position.y + 65;

    double minusMediumShineX = _shineMedium.position.x - 60;
    double plusMediumShineX = _shineMedium.position.x + 60;
    double minusMediumShineY = _shineMedium.position.y - 65;
    double plusMediumShineY = _shineMedium.position.y + 65;
    while (minusEasyShineX <= x && x <= plusEasyShineX ||
        minusMediumShineX <= x && x <= plusMediumShineX) {
      x = getRandomPositionX();
    }
    while (minusEasyshineY <= y && y <= plusEasyshineY ||
        minusMediumShineY <= y && y <= plusMediumShineY) {
      y = getRandomPositionShineY();
    }
    _shineHard.position = Vector2(x, y);
  }

  void _getMediumPosition() {
    double x = getRandomPositionX();
    double y = getRandomPositionY();
    double minusX = _polygonEasy.position.x - 65;
    double plusX = _polygonEasy.position.x + 65;
    double minusY = _polygonEasy.position.y - 60;
    double plusY = _polygonEasy.position.y + 60;
    while (minusX <= x && x <= plusX) {
      x = getRandomPositionX();
    }
    while (minusY <= y && y <= plusY) {
      y = getRandomPositionY();
    }
    _polygonMedium.position = Vector2(x, y);
  }

  void _getHardPosition() {
    double x = getRandomPositionX();
    double y = getRandomPositionY();
    double minusEasyX = _polygonEasy.position.x - 65;
    double plusEasyX = _polygonEasy.position.x + 65;
    double minusEasyY = _polygonEasy.position.y - 60;
    double plusEasyY = _polygonEasy.position.y + 60;

    double minusMediumX = _polygonMedium.position.x - 65;
    double plusMediumX = _polygonMedium.position.x + 65;
    double minusMediumY = _polygonMedium.position.y - 60;
    double plusMediumY = _polygonMedium.position.y + 60;
    while (minusEasyX <= x && x <= plusEasyX ||
        minusMediumX <= x && x <= plusMediumX) {
      x = getRandomPositionX();
    }
    while (minusEasyY <= y && y <= plusEasyY ||
        minusMediumY <= y && y <= plusMediumY) {
      y = getRandomPositionY();
    }
    _polygonHard.position = Vector2(x, y);
  }

  int get score => gameScore;
  int get lives => _lives;

  bool get isIntro => _state == GameState.Intro;
  bool get isPlaying => _state == GameState.Playing;
  bool get isPaused => _state == GameState.Paused;
  bool get isGameOver => _state == GameState.GameOver;
  bool get isGameReady => _state == GameState.GameReady;
  GameState get getState => _state;

  bool get isOldRecord => _recordState == RecordState.oldRecord;
  bool get isNewRecord => _recordState == RecordState.newRecord;
  RecordState get getRecord => _recordState;

  set setScore(int newScore) {
    gameScore = newScore;
    _scoreText.text = 'Score: ${gameScore.toStringAsFixed(0)}';
  }

  set setHighScore(int newHighScore) {
    _highscore = newHighScore;
    _highScoreText.text = 'High Score: ${_highscore.toStringAsFixed(0)}';
  }

  set setTime(int newTime) {
    if (newTime < 10) {
      _timeText.text = "00:0$newTime";
    } else {
      _timeText.text = "00:$newTime";
    }
  }

  set setLives(int newLives) {
    _lives = newLives;
    _livesText.text = "Lives: $newLives";
  }

  set setState(GameState state) {
    _state = state;
  }

  set setRecord(RecordState state) {
    _recordState = state;
  }

  Future<void> restart() async {
    if (_shine) {
      await playIntroFox();
    } else {
      await playIntro();
    }
    Provider.of<GoPopProvider>(_context!, listen: false).enableNavigation();
    setState = GameState.Playing;
    setRecord = RecordState.oldRecord;
    resetPositions();
    _timer.reset();
    _time = Provider.of<GoPopProvider>(_context!, listen: false).time;
    setTime = Provider.of<GoPopProvider>(_context!, listen: false).time;
    setLives = Provider.of<GoPopProvider>(_context!, listen: false).lives;
    setScore = 0;
    startTimer();
  }

  Future<void> gameOver() async {
    if (_shine) {
      await playGameOver();
    } else {
      await playFinish();
    }
    setState = GameState.GameOver;
    Provider.of<GoPopProvider>(_context!, listen: false).disableNavigation();
    Provider.of<TBIProvider>(_context!, listen: false).getRandomEffect();
    if (_user != null) {
      try {
        await _popManager!.addPlayTime(_user!.uid);
      } catch (e) {
        print("error");
      }
    }
    if (score > _highscore) {
      if (_shine) {
        await Future.delayed(const Duration(milliseconds: 1500), () async {
          await playNewRecordSmash();
        });
      } else {
        await Future.delayed(const Duration(milliseconds: 300), () async {
          await playNewRecord();
        });
      }
      if (_user != null) {
        try {
          await _popManager!.addHighScore(_user!.uid, score);
        } catch (e) {
          print("error");
        }
      }
      setHighScore = score;
      setRecord = RecordState.newRecord;
    } else {
      setRecord = RecordState.oldRecord;
    }
    if (_user != null) {
      try {
        await _popManager!.levelUp(_user!.uid, score);
      } catch (e) {
        print("error");
      }
    }
    setState = GameState.GameReady;
    await _raiseLevels();
  }

  Future<void> _raiseLevels() async {
    switch (getGameDifficultyByPopDifficulty(_difficulty)) {
      case GameDifficulty.easy:
        await Future.delayed(const Duration(milliseconds: 1000), () async {
          await _improveReflex(2);
        });
        break;
      case GameDifficulty.medium:
        await Future.delayed(const Duration(milliseconds: 1000), () async {
          await _improveReflex(4);
          await _improveFocus(3);
        });
        break;
      case GameDifficulty.hard:
        await Future.delayed(const Duration(milliseconds: 1000), () async {
          await _improveReflex(8);
          await _improveFocus(5);
          await _improveSpeed(6);
        });
        break;
      default:
        await Future.delayed(const Duration(milliseconds: 1000), () async {
          await _improveReflex(2);
        });
    }
  }

  Future<void> _improveReflex(int raiseReflex) async {
    if (_user == null) {
      return;
    }

    try {
      int newReflex =
          Provider.of<GameProvider.GameProvider>(_context!, listen: false)
                  .reflex +
              raiseReflex;
      if (newReflex >= 1000) {
        await _skillManager.addReflex(_user!.uid, 0, 1000);
        Provider.of<GameProvider.GameProvider>(_context!, listen: false)
            .setMyReflex = 1000;
      } else {
        await _skillManager.addReflex(
            _user!.uid,
            raiseReflex,
            Provider.of<GameProvider.GameProvider>(_context!, listen: false)
                .reflex);
        Provider.of<GameProvider.GameProvider>(_context!, listen: false)
            .setMyReflex = newReflex;
      }
    } catch (e) {
      print("error _improvereflex");
    }
  }

  Future<void> _improveFocus(int raiseFocus) async {
    if (_user == null) {
      return;
    }

    try {
      int newFocus =
          Provider.of<GameProvider.GameProvider>(_context!, listen: false)
                  .focus +
              raiseFocus;
      if (newFocus >= 1000) {
        await _skillManager.addFocus(_user!.uid, 0, 1000);
        Provider.of<GameProvider.GameProvider>(_context!, listen: false)
            .setMyFocus = 1000;
      } else {
        await _skillManager.addFocus(
            _user!.uid,
            raiseFocus,
            Provider.of<GameProvider.GameProvider>(_context!, listen: false)
                .focus);
        Provider.of<GameProvider.GameProvider>(_context!, listen: false)
            .setMyFocus = newFocus;
      }
    } catch (e) {
      print("error _improveFocus");
    }
  }

  Future<void> _improveSpeed(int raiseSpeed) async {
    if (_user == null) {
      return;
    }

    try {
      int newSpeed =
          Provider.of<GameProvider.GameProvider>(_context!, listen: false)
                  .speed +
              raiseSpeed;
      if (newSpeed >= 1000) {
        await _skillManager.addSpeed(_user!.uid, 0, 1000);
        Provider.of<GameProvider.GameProvider>(_context!, listen: false)
            .setMySpeed = 1000;
      } else {
        await _skillManager.addSpeed(
            _user!.uid,
            raiseSpeed,
            Provider.of<GameProvider.GameProvider>(_context!, listen: false)
                .speed);
        Provider.of<GameProvider.GameProvider>(_context!, listen: false)
            .setMySpeed = newSpeed;
      }
    } catch (e) {
      print("error _improvespeed");
    }
  }

  Future<void> playBackgroundMusic() async {
    double level = getLevelByPopDifficulty(_difficulty);

    if (_shine) {
      if (level >= 0 && level < 3) {
        await FlameAudio.bgm.play('bg_music/melee-v1.mp3');
      } else if (level >= 3 && level < 7) {
        await FlameAudio.bgm.play('bg_music/melee-v2.mp3');
      } else {
        await FlameAudio.bgm.play('bg_music/melee-v3.mp3');
      }
    } else {
      switch (_difficulty) {
        case GoPopDifficulty.Zero:
          await FlameAudio.bgm.play('bg_music/bg-v0.mp3', volume: 0.5);
          break;
        case GoPopDifficulty.One:
          await FlameAudio.bgm.play('bg_music/bg-v1.mp3', volume: 0.5);
          break;
        case GoPopDifficulty.Two:
          await FlameAudio.bgm.play('bg_music/bg-v2.mp3', volume: 0.5);
          break;
        case GoPopDifficulty.Three:
          await FlameAudio.bgm.play('bg_music/bg-v3.mp3', volume: 0.5);
          break;
        case GoPopDifficulty.Four:
          await FlameAudio.bgm.play('bg_music/bg-v4.mp3', volume: 0.5);
          break;
        case GoPopDifficulty.Five:
          await FlameAudio.bgm.play('bg_music/bg-v5.mp3', volume: 0.5);
          break;
        case GoPopDifficulty.Six:
          await FlameAudio.bgm.play('bg_music/bg-v6.mp3', volume: 0.5);
          break;
        case GoPopDifficulty.Seven:
          await FlameAudio.bgm.play('bg_music/bg-v7.mp3', volume: 0.5);
          break;
        case GoPopDifficulty.Eight:
          await FlameAudio.bgm.play('bg_music/bg-v8.mp3', volume: 0.5);
          break;
        case GoPopDifficulty.Nine:
          await FlameAudio.bgm.play('bg_music/bg-v9.mp3', volume: 0.5);
          break;
        case GoPopDifficulty.Ten:
          await FlameAudio.bgm.play('bg_music/bg-v10.mp3', volume: 0.5);
          break;
        default:
          await FlameAudio.bgm.play('bg_music/bg-v0.mp3', volume: 0.5);
      }
    }
  }

  Future<void> playIntro() async {
    await FlameAudio.play('intro/start.mp3');
  }

  Future<void> playIntroFox() async {
    await FlameAudio.play('intro/start-fox.wav');
  }

  Future<void> playFinish() async {
    await FlameAudio.play('game_over/finish.mp3');
  }

  Future<void> playGameOver() async {
    await FlameAudio.play('game_over/game-over.mp3');
  }

  Future<void> playNewRecord() async {
    await FlameAudio.play('new_record/new-record.mp3');
  }

  Future<void> playNewRecordSmash() async {
    await FlameAudio.play('new_record/new-record.wav');
  }

  Future<void> playLaser() async {
    await FlameAudio.play('games/go_pop/pop-6.mp3');
  }

  Future<void> playWrong() async {
    await FlameAudio.play('wrong_answer/wrong-short.mp3');
  }

  Future<void> playShine() async {
    await FlameAudio.play('games/go_pop/shine.mp3');
  }

  Future<void> playWrongFox1() async {
    await FlameAudio.play('wrong_answer/wrong-fox-v1.wav');
  }

  Future<void> playWrongFox2() async {
    await FlameAudio.play('wrong_answer/wrong-fox-v2.wav');
  }

  Future<void> pauseBackgroundMusic() async {
    await FlameAudio.bgm.pause();
  }

  Future<void> resumeBackgroundMusic() async {
    await FlameAudio.bgm.resume();
  }

  double getRandomPositionX() {
    double randX = _random.nextDouble() * (_screenSize!.x - 50 - 50) + 50;
    return randX;
  }

  double getRandomPositionY() {
    if (_difficulty == GameDifficulty.easy) {
      double randY = _random.nextDouble() * (_screenSize!.y - 95 - 110) + 110;
      return randY;
    } else {
      double randY = _random.nextDouble() * (_screenSize!.y - 95 - 135) + 135;
      return randY;
    }
  }

  double getRandomPositionShineY() {
    if (_difficulty == GameDifficulty.easy) {
      double randY = _random.nextDouble() * (_screenSize!.y - 95 - 120) + 120;
      return randY;
    } else {
      double randY = _random.nextDouble() * (_screenSize!.y - 95 - 145) + 145;
      return randY;
    }
  }

  void stopTimer() {
    _timer.stop();
  }

  void startTimer() {
    _timer.start();
  }

  void disposeGame() {
    FlameAudio.bgm.dispose();
    stopTimer();
  }
}
