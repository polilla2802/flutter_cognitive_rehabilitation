import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mobile_app_cognitive_rehabilitation/app/games/go_pop/go_pop.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/common/common_widgets.dart';

class GamePanel extends Component with HasGameRef<GoPop>, Tappable {
  late bool _shine;

  late MainText _mainText;
  late NewRecordText _newRecordText;
  late ExplanationText _explanationText;

  GamePanel({bool shine = false}) {
    _shine = shine;
    _mainText = MainText();
    _newRecordText = NewRecordText(shine: _shine);
    _explanationText = ExplanationText(shine: _shine);
  }

  @override
  Future<void> onLoad() async {
    add(_mainText);
    add(_newRecordText);
    add(_explanationText);
  }

  @override
  void update(double dt) {
    super.update(dt);
    switch (gameRef.getState) {
      case GameState.Intro:
        _mainText.visible = true;
        _newRecordText.visible = false;
        _explanationText.visible = true;
        break;
      case GameState.Playing:
        _mainText.visible = false;
        _newRecordText.visible = false;
        _explanationText.visible = false;
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
        if (gameRef.getRecord == RecordState.newRecord) {
          _newRecordText.visible = true;
        } else {
          _newRecordText.visible = false;
        }
        _explanationText.visible = false;
        break;
      default:
    }
  }
}

class NewRecordText extends TextComponent {
  bool visible = false;

  NewRecordText({bool shine = false})
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
                      blurRadius: 2,
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

class MainText extends TextComponent with HasGameRef<GoPop> {
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
                      blurRadius: 2,
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

class ExplanationText extends TextComponent with HasGameRef<GoPop>, Tappable {
  bool visible = false;
  late bool _shine;

  ExplanationText({bool shine = false})
      : super(
            text: shine
                ? "Touch the shine as fast \nas possible before time \nruns out!"
                : "Touch the green Hexagon \nas fast as possible before \ntime runs out!",
            anchor: Anchor.center,
            textRenderer: TextPaint(
                style: GoogleFonts.poppins(
                    color: ConstValues.whiteColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    shadows: [
                  Shadow(
                      blurRadius: 2,
                      color: Colors.black,
                      offset: Offset.fromDirection(100))
                ]))) {
    _shine = shine;
  }

  @override
  void render(Canvas canvas) {
    textRenderer.render(canvas, text, Vector2.zero());
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    x = _shine ? gameSize.x / 2 : gameSize.x / 2;
    y = gameSize.y / 2 + 150;
  }

  @override
  void renderTree(Canvas canvas) {
    if (visible) {
      super.renderTree(canvas);
    }
  }
}
