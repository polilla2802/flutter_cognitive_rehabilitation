import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:mobile_app_cognitive_rehabilitation/app/providers/providers.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/games/go_speed/go_speed.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/games/go_speed/pause_speed.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/common/common_widgets.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/providers/game_provider/game_provider.dart'
    as GameProvider;
import 'package:mobile_app_cognitive_rehabilitation/app/providers/skills/skill_manager.dart'
    as Skill;

enum RecordState { newRecord, oldRecord }

class GamePanel extends Component with HasGameRef<GoSpeed>, Tappable {
  late BuildContext? _context;

  late User? _user;
  late SpeedManager? _speedManager;
  late GoSpeedDifficulty? _difficulty;
  late Skill.SkillManager _skillManager;

  late MainText _mainText;
  late NewRecordText _newRecordText;
  late ExplanationText _explanationText;
  late final PauseSpeed _pauseSpeed;

  late TextPaint _textRenderer;
  late final TextComponent _scoreText;
  late final TextComponent _highScoreText;
  late final TextComponent _timeText;
  late final TextComponent _livesText;

  late RecordState _recordState;

  static late Timer _timer;
  late int _time;
  late int _lives;
  late int _level;
  late int _exp;
  late double _multiplier;

  late int gameScore;
  late int highscore;

  int get score => gameScore;
  int get highScore => highscore;

  GamePanel(
      {BuildContext? context,
      int? highScore,
      int lives = 0,
      int time = 25,
      int level = 0,
      int exp = 0,
      GoSpeedDifficulty difficulty = GoSpeedDifficulty.Zero,
      double multiplier = 1.0}) {
    _context = context;
    _user = FirebaseAuth.instance.currentUser != null
        ? FirebaseAuth.instance.currentUser!
        : null;
    _speedManager = SpeedManager();
    _skillManager = Skill.SkillManager();
    _time = time;
    _lives = lives;
    _multiplier = multiplier;
    _difficulty = difficulty;
    gameScore = 0;
    _timer = Timer(1, repeat: true);
    _recordState = RecordState.oldRecord;
    highscore = highScore != null ? highScore : 0;
    _textRenderer = TextPaint(
        style: GoogleFonts.poppins(
            color: ConstValues.whiteColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            shadows: [
          Shadow(
              blurRadius: 3,
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
    _pauseSpeed = PauseSpeed()..anchor = Anchor.centerRight;
    _livesText = TextComponent(
      textRenderer: _textRenderer,
    )
      ..positionType = PositionType.viewport
      ..anchor = Anchor.centerRight;
    _mainText = MainText();
    _newRecordText = NewRecordText();
    _explanationText = ExplanationText();
    setScore = 0;
    setHighScore = highscore;
    setTime = _time;
    _lives == 0 ? null : setLives = _lives;
  }

  @override
  Future<void> onLoad() async {
    add(_mainText);
    add(_newRecordText);
    add(_scoreText);
    add(_highScoreText);
    add(_timeText);
    add(_explanationText);
    add(_pauseSpeed);
    _lives == 0 ? null : add(_livesText);

    _timer.onTick = () async {
      if (_time <= 1) {
        setTime = 0;
        await gameRef.gameOver();
      } else {
        setTime = _time -= 1;
      }
    };
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

  set setScore(int newScore) {
    gameScore = newScore;
    _scoreText.text = 'Score: ${gameScore.toStringAsFixed(0)}';
  }

  set setHighScore(int newHighScore) {
    highscore = newHighScore;
    _highScoreText.text = 'High Score: ${highscore.toStringAsFixed(0)}';
  }

  set setRecord(RecordState state) {
    _recordState = state;
  }

  bool get isOldRecord => _recordState == RecordState.oldRecord;
  bool get isNewRecord => _recordState == RecordState.newRecord;
  RecordState get getRecord => _recordState;

  @override
  void update(double dt) {
    super.update(dt);
    switch (gameRef.getState) {
      case GameState.Intro:
        _mainText.visible = false;
        _newRecordText.visible = false;
        _explanationText.visible = true;
        _explanationText.text = "Memorize this symbol";
        break;
      case GameState.Start:
        _mainText.visible = true;
        _mainText.text = "START!";
        _newRecordText.visible = false;
        _explanationText.visible = false;
        break;
      case GameState.Playing:
        _mainText.visible = false;
        _newRecordText.visible = false;
        _explanationText.visible = true;
        _explanationText.text = "Does this symbol match \nthe previous symbol?";
        break;
      case GameState.Paused:
        _mainText.visible = true;
        _mainText.text = "PAUSE";
        _newRecordText.visible = false;
        _explanationText.visible = false;
        break;
      case GameState.GameOver:
        _mainText.visible = true;
        _mainText.text = "FINISH!";
        _newRecordText.visible = false;
        _explanationText.visible = false;
        break;
      case GameState.GameReady:
        _mainText.visible = true;
        _mainText.text = "FINISH!";
        if (getRecord == RecordState.newRecord) {
          _newRecordText.visible = true;
        } else {
          _newRecordText.visible = false;
        }
        _explanationText.visible = false;
        break;
      default:
    }

    if (gameRef.isIntro) {
      _timer.reset();
      return;
    }

    if (gameRef.isStart) {
      _timer.stop();
      return;
    }

    if (gameRef.isPlaying) {
      _timer.update(dt);
      return;
    }

    if (gameRef.isPaused) {
      stopTimer();
      return;
    }

    if (gameRef.isGameOver) {
      _timer.stop();
      return;
    }

    if (gameRef.isGameReady) {
      _timer.stop();
      return;
    }
  }

  @override
  void onGameResize(Vector2 gameSize) {
    _scoreText..position = Vector2(16, gameSize.y - 20);
    _highScoreText..position = Vector2(gameSize.x - 16, gameSize.y - 20);
    _livesText..position = Vector2(gameSize.x - 16, 65);
    _timeText..position = Vector2(gameSize.x - 50, 32);
    _pauseSpeed..position = Vector2(gameSize.x - 8, 32);
    super.onGameResize(gameSize);
  }

  Future<void> addRecord() async {
    await FlameAudio.play('game_over/finish.mp3');
    gameRef.setState = GameState.GameOver;
    Provider.of<GoSpeedProvider>(_context!, listen: false).gameOver();
    if (_user != null) {
      try {
        await _speedManager!.addPlayTime(_user!.uid);
      } catch (e) {
        print("error addPlayTime");
      }
    }
    if (score > highscore) {
      await Future.delayed(const Duration(milliseconds: 300), () async {
        await FlameAudio.play('new_record/new-record.mp3', volume: 1.0);
      });
      if (_user != null) {
        try {
          await _speedManager!.addHighScore(_user!.uid, score);
        } catch (e) {
          print("error addHighScore");
        }
      }
      setHighScore = score;
      setRecord = RecordState.newRecord;
    } else {
      setRecord = RecordState.oldRecord;
    }
    if (_user != null) {
      try {
        await _speedManager!.levelUp(_user!.uid, score);
      } catch (e) {
        print("error");
      }
    }
    gameRef.setState = GameState.GameReady;
    await _raiseLevels();
  }

  Future<void> _raiseLevels() async {
    switch (getGameDifficultyBySpeedDifficulty(_difficulty!)) {
      case GameProvider.GameDifficulty.easy:
        await Future.delayed(const Duration(milliseconds: 1000), () async {
          await _improveResponse(3);
        });
        break;
      case GameProvider.GameDifficulty.medium:
        await Future.delayed(const Duration(milliseconds: 1000), () async {
          await _improveResponse(5);
          await _improveMemory(5);
        });
        break;
      case GameProvider.GameDifficulty.hard:
        await Future.delayed(const Duration(milliseconds: 1000), () async {
          await _improveResponse(8);
          await _improveMemory(6);
          await _improveSpeed(5);
        });
        break;
      default:
        await Future.delayed(const Duration(milliseconds: 1000), () async {
          await _improveResponse(3);
        });
    }
  }

  Future<void> _improveResponse(int raiseResponse) async {
    if (_user == null) {
      return;
    }
    try {
      int newResponse =
          Provider.of<GameProvider.GameProvider>(_context!, listen: false)
                  .response +
              raiseResponse;
      if (newResponse >= 1000) {
        await _skillManager.addResponse(_user!.uid, 0, 1000);
        Provider.of<GameProvider.GameProvider>(_context!, listen: false)
            .setMyResponse = 1000;
      } else {
        await _skillManager.addResponse(
            _user!.uid,
            raiseResponse,
            Provider.of<GameProvider.GameProvider>(_context!, listen: false)
                .response);
        Provider.of<GameProvider.GameProvider>(_context!, listen: false)
            .setMyResponse = newResponse;
      }
    } catch (e) {
      print("error _improveResponse");
    }
  }

  Future<void> _improveMemory(int raiseMemory) async {
    if (_user == null) {
      return;
    }
    try {
      int newMemory =
          Provider.of<GameProvider.GameProvider>(_context!, listen: false)
                  .memory +
              raiseMemory;
      if (newMemory >= 1000) {
        await _skillManager.addMemory(_user!.uid, 0, 1000);
        Provider.of<GameProvider.GameProvider>(_context!, listen: false)
            .setMyMemory = 1000;
      } else {
        await _skillManager.addMemory(
            _user!.uid,
            raiseMemory,
            Provider.of<GameProvider.GameProvider>(_context!, listen: false)
                .memory);
        Provider.of<GameProvider.GameProvider>(_context!, listen: false)
            .setMyMemory = newMemory;
      }
    } catch (e) {
      print("error _improveMemory");
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
      print("error _improveSpeed");
    }
  }

  Future<void> correct() async {
    double doubleScore = gameScore.toDouble();
    double result = doubleScore += 100.0 * _multiplier;
    setScore = result.toInt();
    await FlameAudio.play('correct_answer/correct.mp3', volume: 1.0);
  }

  Future<void> incorrect(SpeedEnum currentIcon) async {
    double doubleScore = gameScore.toDouble();
    double result = doubleScore -= 130.0 * _multiplier;
    if (result <= 0) {
      setScore = 0;
    } else {
      setScore = result.toInt();
    }
    int newLife = _lives - 1;
    if (newLife == 0) {
      setLives = newLife;
      gameRef.gameOver();
    } else {
      setLives = newLife;
      Provider.of<GoSpeedProvider>(_context!, listen: false)
          .disableNavigation();
      Provider.of<GoSpeedProvider>(_context!, listen: false).disable();
      await FlameAudio.play('wrong_answer/wrong.mp3', volume: 1.0);
      await Future.delayed(const Duration(milliseconds: 1000), () async {
        Provider.of<GoSpeedProvider>(_context!, listen: false)
            .enableNavigation();
        Provider.of<GoSpeedProvider>(_context!, listen: false).enable();
      });
      gameRef.resetIcon();
      gameRef.setSpeed(currentIcon);
    }
  }

  void reset() {
    resetTimer();
    _time = Provider.of<GoSpeedProvider>(_context!, listen: false).time;
    setTime = Provider.of<GoSpeedProvider>(_context!, listen: false).time;
    setLives = Provider.of<GoSpeedProvider>(_context!, listen: false).lives;
    setScore = 0;
  }

  void startTimer() {
    _timer.start();
  }

  void stopTimer() {
    _timer.stop();
  }

  void resumeTimer() {
    _timer.resume();
  }

  void resetTimer() {
    _timer.reset();
  }
}

class NewRecordText extends TextComponent {
  bool visible = false;

  NewRecordText()
      : super(
            text: "New Record!",
            anchor: Anchor.center,
            textRenderer: TextPaint(
                style: GoogleFonts.poppins(
                    color: ConstValues.whiteColor,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    shadows: [
                  Shadow(
                      blurRadius: 3,
                      color: Colors.black,
                      offset: Offset.fromDirection(100))
                ])));

  @override
  void render(Canvas canvas) {
    textRenderer.render(canvas, text, Vector2.zero());
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    x = gameSize.x / 2;
    y = gameSize.y - 80;
  }

  @override
  void renderTree(Canvas canvas) {
    if (visible) {
      super.renderTree(canvas);
    }
  }
}

class MainText extends TextComponent with HasGameRef<GoSpeed> {
  bool visible = true;

  MainText()
      : super(
            text: "START!",
            anchor: Anchor.center,
            textRenderer: TextPaint(
                style: GoogleFonts.poppins(
                    color: ConstValues.whiteColor,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    shadows: [
                  Shadow(
                      blurRadius: 3,
                      color: Colors.black,
                      offset: Offset.fromDirection(100))
                ])));

  @override
  void render(Canvas canvas) {
    textRenderer.render(canvas, text, Vector2.zero());
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    x = gameSize.x / 2;
    y = gameSize.y / 2 - 100;
  }

  @override
  void renderTree(Canvas canvas) {
    if (visible) {
      super.renderTree(canvas);
    }
  }
}

class ExplanationText extends TextComponent with HasGameRef<GoSpeed>, Tappable {
  bool visible = false;

  ExplanationText()
      : super(
            text: "Does this symbol match \nthe previous symbol?",
            anchor: Anchor.center,
            textRenderer: TextPaint(
                style: GoogleFonts.poppins(
                    color: ConstValues.whiteColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    shadows: [
                  Shadow(
                      blurRadius: 3,
                      color: Colors.black,
                      offset: Offset.fromDirection(100))
                ])));

  @override
  void render(Canvas canvas) {
    textRenderer.render(canvas, text, Vector2.zero());
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    x = gameSize.x / 2;
    y = gameSize.y / 2 + 125;
  }

  @override
  void renderTree(Canvas canvas) {
    if (visible) {
      super.renderTree(canvas);
    }
  }
}
