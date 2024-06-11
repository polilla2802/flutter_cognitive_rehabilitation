import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/providers/providers.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/games/go_matrix/go_matrix.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/common/common_widgets.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/providers/game_provider/game_provider.dart'
    as GameProvider;
import 'package:mobile_app_cognitive_rehabilitation/app/providers/skills/skill_manager.dart'
    as Skill;

enum RecordState { newRecord, oldRecord }

class GamePanel extends Component with HasGameRef<GoMatrix>, Tappable {
  late BuildContext? _context;

  late User? _user;
  late MatrixManager? _matrixManager;
  late GameDifficulty? _difficulty;

  late MainText _mainText;
  late TilesText _tilesText;
  late NewRecordText _newRecordText;
  late ExplanationText _explanationText;

  late TextPaint _textRenderer;
  late final TextComponent _scoreText;
  late final TextComponent _highScoreText;
  late final TextComponent _timeText;
  late final TextComponent _livesText;
  late final TextComponent _tilesLeft;

  late RecordState _recordState;

  static late Timer _timer;
  late int _time;
  late int _difficultyTime;
  late int _lives;
  late int _tiles;
  late int _level;
  late int _exp;
  late double _multiplier;

  late int gameScore;
  late int highscore;
  late Skill.SkillManager _skillManager;

  int get score => gameScore;
  int get highScore => highscore;

  GamePanel(
      {BuildContext? context,
      int? highScore,
      bool spanish = false,
      int lives = 0,
      int tiles = 5,
      int time = 25,
      int level = 0,
      int exp = 0,
      double multiplier = 1.0,
      GameDifficulty difficulty = GameDifficulty.easy}) {
    _context = context;
    _user = FirebaseAuth.instance.currentUser != null
        ? FirebaseAuth.instance.currentUser!
        : null;
    _matrixManager = MatrixManager();
    _skillManager = Skill.SkillManager();
    _time = time;
    _difficultyTime = time;
    _lives = lives;
    _tiles = tiles;
    _level = level;
    _difficulty = difficulty;
    _exp = exp;
    _multiplier = multiplier;
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
              blurRadius: 1,
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
    _livesText = TextComponent(
      textRenderer: _textRenderer,
    )
      ..positionType = PositionType.viewport
      ..anchor = Anchor.centerRight;
    _tilesLeft = TextComponent(
      textRenderer: _textRenderer,
    )
      ..positionType = PositionType.viewport
      ..anchor = Anchor.centerRight;
    _mainText = MainText();
    _tilesText = TilesText(tiles: tiles);
    _newRecordText = NewRecordText();
    _explanationText = ExplanationText();
    setScore = 0;
    setHighScore = highscore;
    setTime = _time;
    setTiles = tiles;
    _lives == 0 ? null : setLives = _lives;
  }

  @override
  Future<void> onLoad() async {
    add(_mainText);
    add(_tilesText);
    add(_newRecordText);
    add(_scoreText);
    add(_highScoreText);
    add(_timeText);
    add(_explanationText);
    add(_tilesLeft);

    _lives == 0 ? null : add(_livesText);

    _timer.onTick = () async {
      if (_time <= 1) {
        setTime = 0;
        await gameRef.gameOver();
      } else if (_time == _difficultyTime - 1) {
        gameRef.setState = GameState.Playing;
        Provider.of<GoMatrixProvider>(_context!, listen: false).setMyHints = 1;
        setTime = _time -= 1;
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

  set setTiles(int newTiles) {
    _tiles = newTiles;
    _tilesLeft.text = "Tiles Left: $newTiles";
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

  set setMultiplier(double multiplier) {
    _multiplier = multiplier;
  }

  int get getLives => _lives;
  bool get isOldRecord => _recordState == RecordState.oldRecord;
  bool get isNewRecord => _recordState == RecordState.newRecord;
  RecordState get getRecord => _recordState;

  @override
  void update(double dt) {
    super.update(dt);
    switch (gameRef.getState) {
      case GameState.Intro:
        _mainText.visible = true;
        _tilesText.visible = true;
        _newRecordText.visible = false;
        _explanationText.visible = true;
        break;
      case GameState.ShowTiles:
        _mainText.visible = false;
        _tilesText.visible = false;
        _newRecordText.visible = false;
        _explanationText.visible = false;
        break;
      case GameState.Playing:
        _mainText.visible = false;
        _tilesText.visible = false;
        _newRecordText.visible = false;
        _explanationText.visible = false;
        break;
      case GameState.Paused:
        _mainText.visible = true;
        _mainText.text = "PAUSE";
        _tilesText.visible = false;
        _newRecordText.visible = false;
        _explanationText.visible = false;
        break;
      case GameState.GameOver:
        _mainText.visible = true;
        _mainText.text = "FINISH!";
        _tilesText.visible = false;
        _newRecordText.visible = false;
        _explanationText.visible = false;
        break;
      case GameState.GameReady:
        _mainText.visible = true;
        _mainText.text = "FINISH!";
        _tilesText.visible = false;
        if (getRecord == RecordState.newRecord) {
          _newRecordText.visible = true;
        } else {
          _newRecordText.visible = false;
        }
        _explanationText.visible = false;
        break;
      default:
    }

    if (gameRef.isGameOver) {
      stopTimer();
      return;
    }

    if (gameRef.isGameReady) {
      stopTimer();
      return;
    }

    if (gameRef.isIntro) {
      resetTimer();
      return;
    }

    if (gameRef.isPaused) {
      stopTimer();
      return;
    }

    if (gameRef.isShowingTiles) {
      _timer.update(dt);
      return;
    }

    if (gameRef.isPlaying) {
      _timer.update(dt);
      return;
    }
  }

  @override
  void onGameResize(Vector2 gameSize) {
    _scoreText..position = Vector2(16, gameSize.y - 20);
    _highScoreText..position = Vector2(gameSize.x - 16, gameSize.y - 20);
    _timeText..position = Vector2(gameSize.x - 50, 32);
    _tilesLeft..position = Vector2(gameSize.x - 16, 65);
    _livesText..position = Vector2(gameSize.x - 16, 98);

    super.onGameResize(gameSize);
  }

  Future<void> addRecord() async {
    await FlameAudio.play('game_over/finish.mp3');
    gameRef.setState = GameState.GameOver;
    if (_user != null) {
      try {
        await _matrixManager!.addPlayTime(_user!.uid);
      } catch (e) {
        print("error addPlayTime");
      }
    }
    if (score > highscore) {
      await Future.delayed(const Duration(milliseconds: 300), () async {
        await FlameAudio.play('new_record/new-record.mp3');
      });
      if (_user != null) {
        try {
          await _matrixManager!.addHighScore(_user!.uid, score);
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
        await _matrixManager!.levelUp(_user!.uid, score);
      } catch (e) {
        print("error");
      }
    }
    gameRef.setState = GameState.GameReady;
    await _raiseLevels();
  }

  Future<void> _raiseLevels() async {
    switch (_difficulty) {
      case GameDifficulty.easy:
        await Future.delayed(const Duration(milliseconds: 1000), () async {
          await _improveMemory(4);
        });
        break;
      case GameDifficulty.medium:
        await Future.delayed(const Duration(milliseconds: 1000), () async {
          await _improveMemory(5);
          await _improveFocus(3);
        });
        break;
      case GameDifficulty.hard:
        await Future.delayed(const Duration(milliseconds: 1000), () async {
          await _improveMemory(8);
          await _improveFocus(4);
          await _improveLogic(7);
        });
        break;
      default:
        await Future.delayed(const Duration(milliseconds: 1000), () async {
          await _improveMemory(4);
        });
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

  Future<void> _improveLogic(int raiseLogic) async {
    if (_user == null) {
      return;
    }
    try {
      int newLogic =
          Provider.of<GameProvider.GameProvider>(_context!, listen: false)
                  .logic +
              raiseLogic;
      if (newLogic >= 1000) {
        await _skillManager.addLogic(_user!.uid, 0, 1000);
        Provider.of<GameProvider.GameProvider>(_context!, listen: false)
            .setMyLogic = 1000;
      } else {
        await _skillManager.addLogic(
            _user!.uid,
            raiseLogic,
            Provider.of<GameProvider.GameProvider>(_context!, listen: false)
                .logic);
        Provider.of<GameProvider.GameProvider>(_context!, listen: false)
            .setMyLogic = newLogic;
      }
    } catch (e) {
      print("error _improvelogic");
    }
  }

  void reset() {
    resetTimer();
    _time = Provider.of<GoMatrixProvider>(_context!, listen: false).time;
    setTime = Provider.of<GoMatrixProvider>(_context!, listen: false).time;
    setLives = Provider.of<GoMatrixProvider>(_context!, listen: false).lives;
    setTiles = Provider.of<GoMatrixProvider>(_context!, listen: false).tiles;
    setScore = 0;
    startTimer();
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

  void correct() {
    setTiles = _tiles - 1;
    double doubleScore = gameScore.toDouble();
    double result = doubleScore += 100.0 * _multiplier;
    setScore = result.toInt();
  }

  void winMatrix() {
    Provider.of<GoMatrixProvider>(_context!, listen: false).setMyHints = 0;
    double doubleScore = gameScore.toDouble();
    double result = doubleScore += 200.0 * _multiplier;
    setScore = result.toInt();
  }

  Future<void> incorrect() async {
    Provider.of<GoMatrixProvider>(_context!, listen: false).showPause = false;
    await FlameAudio.play('wrong_answer/wrong.mp3');
    disableNavigation();
    gameRef.setState = GameState.Incorrect;
    double doubleScore = gameScore.toDouble();
    double result = doubleScore -= 130.0 * _multiplier;
    if (result <= 0) {
      setScore = 0;
    } else {
      setScore = result.toInt();
    }
    int newLife = _lives - 1;
    if (newLife < 0) {
      setLives = 0;
      Future.delayed(const Duration(milliseconds: 1000), () async {
        Provider.of<GoMatrixProvider>(_context!, listen: false).setMyHints = 0;
        await gameRef.newMatrix();
        enableNavigation();
      });
    } else if (newLife == 0) {
      setLives = 0;
      await gameRef.gameOver();
    } else {
      setLives = newLife;
      Future.delayed(const Duration(milliseconds: 1000), () async {
        Provider.of<GoMatrixProvider>(_context!, listen: false).setMyHints = 0;
        await gameRef.newMatrix();
        enableNavigation();
      });
    }
  }

  void enableNavigation() {
    Provider.of<GoMatrixProvider>(_context!, listen: false).enableNavigation();
  }

  void disableNavigation() {
    Provider.of<GoMatrixProvider>(_context!, listen: false).disableNavigation();
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
                    fontWeight: FontWeight.bold)));

  @override
  void render(Canvas canvas) {
    textRenderer.render(canvas, text, Vector2.zero());
  }

  @override
  void onGameResize(Vector2 gameSize) {
    x = gameSize.x / 2;
    y = gameSize.y - 80;
    super.onGameResize(gameSize);
  }

  @override
  void renderTree(Canvas canvas) {
    if (visible) {
      super.renderTree(canvas);
    }
  }
}

class MainText extends TextComponent with HasGameRef<GoMatrix> {
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
                      blurRadius: 1,
                      color: Colors.black,
                      offset: Offset.fromDirection(100))
                ])));

  @override
  void render(Canvas canvas) {
    textRenderer.render(canvas, text, Vector2.zero());
  }

  @override
  void onGameResize(Vector2 gameSize) {
    x = gameSize.x / 2;
    y = gameSize.y / 2 - 100;
    super.onGameResize(gameSize);
  }

  @override
  void renderTree(Canvas canvas) {
    if (visible) {
      super.renderTree(canvas);
    }
  }
}

class TilesText extends TextComponent with HasGameRef<GoMatrix> {
  bool visible = true;

  TilesText({int tiles = 5})
      : super(
            text: "Tiles: $tiles",
            anchor: Anchor.center,
            textRenderer: TextPaint(
                style: GoogleFonts.poppins(
                    color: ConstValues.whiteColor,
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    shadows: [
                  Shadow(
                      blurRadius: 1,
                      color: Colors.black,
                      offset: Offset.fromDirection(100))
                ])));

  @override
  void render(Canvas canvas) {
    textRenderer.render(canvas, text, Vector2.zero());
  }

  @override
  void onGameResize(Vector2 gameSize) {
    x = gameSize.x / 2;
    y = gameSize.y / 2 + 0;
    super.onGameResize(gameSize);
  }

  @override
  void renderTree(Canvas canvas) {
    if (visible) {
      super.renderTree(canvas);
    }
  }
}

class ExplanationText extends TextComponent
    with HasGameRef<GoMatrix>, Tappable {
  bool visible = false;

  ExplanationText()
      : super(
            text: "Remember the pattern",
            anchor: Anchor.center,
            textRenderer: TextPaint(
                style: GoogleFonts.poppins(
                    color: ConstValues.whiteColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    shadows: [
                  Shadow(
                      blurRadius: 1,
                      color: Colors.black,
                      offset: Offset.fromDirection(100))
                ])));

  @override
  void render(Canvas canvas) {
    textRenderer.render(canvas, text, Vector2.zero());
  }

  @override
  void onGameResize(Vector2 gameSize) {
    x = gameSize.x / 2;
    y = gameSize.y / 2 + 150;
    super.onGameResize(gameSize);
  }

  @override
  void renderTree(Canvas canvas) {
    if (visible) {
      super.renderTree(canvas);
    }
  }
}