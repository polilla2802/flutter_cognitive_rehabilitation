import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/providers/providers.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/games/go_color/go_color.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/games/go_color/pause_color.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/common/common_widgets.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/providers/game_provider/game_provider.dart'
    as GameProvider;
import 'package:mobile_app_cognitive_rehabilitation/app/providers/skills/skill_manager.dart'
    as Skill;

enum RecordState { newRecord, oldRecord }

class GamePanel extends Component with HasGameRef<GoColor>, Tappable {
  late BuildContext? _context;
  late bool _spanish;

  late User? _user;
  late ColorManager? _colorManager;
  late GameDifficulty? _difficulty;
  late Skill.SkillManager _skillManager;

  late MainText _mainText;
  late NewRecordText _newRecordText;
  late ExplanationText _explanationText;
  late final PauseColor _pauseColor;

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
      bool spanish = false,
      int lives = 0,
      int time = 25,
      int level = 0,
      int exp = 0,
      double multiplier = 1.0,
      GameDifficulty difficulty = GameDifficulty.easy}) {
    _context = context;
    _spanish = spanish;
    _difficulty = difficulty;
    _user = FirebaseAuth.instance.currentUser != null
        ? FirebaseAuth.instance.currentUser!
        : null;
    _colorManager = ColorManager();
    _skillManager = Skill.SkillManager();
    _time = time;
    _lives = lives;
    _level = level;
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
    _pauseColor = PauseColor()..anchor = Anchor.centerRight;
    _livesText = TextComponent(
      textRenderer: _textRenderer,
    )
      ..positionType = PositionType.viewport
      ..anchor = Anchor.centerRight;
    _mainText = MainText(spanish: spanish);
    _newRecordText = NewRecordText(spanish: spanish);
    _explanationText = ExplanationText(spanish: spanish);
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
    add(_pauseColor);
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
    _livesText.text = _spanish ? "Vidas: $newLives" : "Lives: $newLives";
  }

  set setScore(int newScore) {
    gameScore = newScore;
    _scoreText.text = _spanish
        ? 'Puntaje: ${gameScore.toStringAsFixed(0)}'
        : 'Score: ${gameScore.toStringAsFixed(0)}';
  }

  set setHighScore(int newHighScore) {
    highscore = newHighScore;
    _highScoreText.text = _spanish
        ? 'Record: ${highscore.toStringAsFixed(0)}'
        : 'High Score: ${highscore.toStringAsFixed(0)}';
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
        _mainText.visible = true;
        _newRecordText.visible = false;
        _explanationText.visible = false;
        break;
      case GameState.Playing:
        _mainText.visible = false;
        _newRecordText.visible = false;
        _explanationText.visible = true;
        break;
      case GameState.Paused:
        _mainText.visible = true;
        _mainText.text = _spanish ? "Pausa!" : "PAUSE";
        _newRecordText.visible = false;
        _explanationText.visible = false;
        break;
      case GameState.GameOver:
        _mainText.visible = true;
        _mainText.text = _spanish ? "Tiempo!" : "FINISH!";
        _newRecordText.visible = false;
        _explanationText.visible = false;
        break;
      case GameState.GameReady:
        _mainText.visible = true;
        _mainText.text = _spanish ? "Tiempo!" : "FINISH!";
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

    if (gameRef.isIntro) {
      resetTimer();
      return;
    }

    if (gameRef.isPaused) {
      stopTimer();
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
    _livesText..position = Vector2(gameSize.x - 16, 65);
    _timeText..position = Vector2(gameSize.x - 50, 32);
    _pauseColor..position = Vector2(gameSize.x - 8, 32);
    super.onGameResize(gameSize);
  }

  Future<void> addRecord() async {
    await FlameAudio.play('game_over/finish.mp3');
    gameRef.setState = GameState.GameOver;
    if (_user != null) {
      try {
        await _colorManager!.addPlayTime(_user!.uid);
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
          await _colorManager!.addHighScore(_user!.uid, score);
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
        await _colorManager!.levelUp(_user!.uid, score);
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
          await _improveResponse(3);
        });
        break;
      case GameDifficulty.medium:
        await Future.delayed(const Duration(milliseconds: 1000), () async {
          await _improveResponse(5);
          await _improveFocus(4);
        });
        break;
      case GameDifficulty.hard:
        await Future.delayed(const Duration(milliseconds: 1000), () async {
          await _improveResponse(8);
          await _improveFocus(5);
          await _improveLogic(6);
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

  Future<void> correct() async {
    double doubleScore = gameScore.toDouble();
    double result = doubleScore += 100.0 * _multiplier;
    setScore = result.toInt();
    await FlameAudio.play('correct_answer/correct.mp3');
  }

  Future<void> incorrect() async {
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
      disableNavigation();
      disableButtons();
      await FlameAudio.play('wrong_answer/wrong.mp3');
      await Future.delayed(const Duration(milliseconds: 1000), () async {
        enableNavigation();
        enableButtons();
      });
      gameRef.resetColors();
    }
  }

  void reset() {
    resetTimer();
    _time = Provider.of<GoColorProvider>(_context!, listen: false).time;
    setTime = Provider.of<GoColorProvider>(_context!, listen: false).time;
    setLives = Provider.of<GoColorProvider>(_context!, listen: false).lives;
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

  void enableButtons() {
    Provider.of<GoColorProvider>(_context!, listen: false).enable();
  }

  void enableNavigation() {
    Provider.of<GoColorProvider>(_context!, listen: false).enableNavigation();
  }

  void disableButtons() {
    Provider.of<GoColorProvider>(_context!, listen: false).disable();
  }

  void disableNavigation() {
    Provider.of<GoColorProvider>(_context!, listen: false).disableNavigation();
  }
}

class NewRecordText extends TextComponent {
  bool visible = false;

  NewRecordText({bool spanish = false})
      : super(
            text: spanish ? "¡Nuevo Record!" : "New Record!",
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

class MainText extends TextComponent with HasGameRef<GoColor> {
  bool visible = true;

  MainText({bool spanish = false})
      : super(
            text: spanish ? "Empieza!" : "START!",
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

class ExplanationText extends TextComponent with HasGameRef<GoColor>, Tappable {
  bool visible = false;
  late bool _spanish;

  ExplanationText({bool spanish = false})
      : super(
            text: spanish
                ? "¿El significado de la palabra \nsuperior coincide con el color \ndel texto de la palabra inferior?"
                : "Does the meaning of the \ntop word matches the text \ncolor of the bottom word?",
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
                ]))) {
    _spanish = spanish;
  }

  @override
  void render(Canvas canvas) {
    textRenderer.render(canvas, text, Vector2.zero());
  }

  @override
  void onGameResize(Vector2 gameSize) {
    x = _spanish ? gameSize.x / 2 : gameSize.x / 2;
    y = gameSize.y / 2 + 125;
    super.onGameResize(gameSize);
  }

  @override
  void renderTree(Canvas canvas) {
    if (visible) {
      super.renderTree(canvas);
    }
  }
}
