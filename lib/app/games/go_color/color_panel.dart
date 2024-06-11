import 'dart:math';

import 'package:flame/components.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/providers/providers.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/games/go_color/go_color.dart';

class ColorPanel extends Component with HasGameRef<GoColor>, Tappable {
  late bool _visible;
  late bool _spanish;

  late Random _random;

  late TopColor _topText;
  late TopRectangle _topRectangle;
  late BottomColor _bottomText;
  late BottomRectangle _bottomRectangle;

  late ColorEnum? _topRandomColor;
  late ColorEnum? _bottomRandomColor;
  late String? _topRandomText;
  late String? _bottomRandomText;

  ColorPanel({bool spanish = false}) {
    _spanish = spanish;
    _random = Random();
    _topRandomColor = getColorEnumById(_random.nextInt(8));
    _bottomRandomColor = getColorEnumById(_random.nextInt(8));
    _topRandomText = _spanish
        ? getSpanishStringByColorEnum(getColorEnumById(_random.nextInt(8)))
        : getStringByColorEnum(getColorEnumById(_random.nextInt(8)));
    _bottomRandomText = _spanish
        ? getSpanishStringByColorEnum(getColorEnumById(_random.nextInt(8)))
        : getStringByColorEnum(getColorEnumById(_random.nextInt(8)));
    _topText = TopColor(color: _topRandomColor, text: _topRandomText);
    _topRectangle = TopRectangle()..anchor = Anchor.center;
    _bottomText =
        BottomColor(color: _bottomRandomColor, text: _bottomRandomText);
    _bottomRectangle = BottomRectangle()..anchor = Anchor.center;
    _visible = false;
  }

  // @override
  // bool debugMode = true;

  @override
  Future<void> onLoad() async {
    add(_topRectangle);
    add(_topText);
    add(_bottomRectangle);
    add(_bottomText);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (gameRef.isPlaying) {
      _visible = true;
    } else {
      _visible = false;
    }
  }

  @override
  void renderTree(Canvas canvas) {
    if (_visible) {
      super.renderTree(canvas);
    }
  }

  set setTopRandomColor(int? id) {
    _topRandomColor = getColorEnumById(id!);
    _topText.textRenderer = TextPaint(
        style: GoogleFonts.poppins(
      color: getColorByEnum(_topRandomColor!),
      fontSize: 35,
      fontWeight: FontWeight.bold,
    ));
  }

  set setBottomRandomColor(int? id) {
    _bottomRandomColor = getColorEnumById(id!);
    _bottomText.textRenderer = TextPaint(
        style: GoogleFonts.poppins(
      color: getColorByEnum(_bottomRandomColor!),
      fontSize: 35,
      fontWeight: FontWeight.bold,
    ));
  }

  set setTopRandomText(int? id) {
    _topRandomText = _spanish
        ? getSpanishStringByColorEnum(getColorEnumById(_random.nextInt(8)))
        : getStringByColorEnum(getColorEnumById(id!));
    _topText.text = _topRandomText!;
  }

  set setBottomRandomText(int? id) {
    _bottomRandomText = _spanish
        ? getSpanishStringByColorEnum(getColorEnumById(_random.nextInt(8)))
        : getStringByColorEnum(getColorEnumById(id!));
    _bottomText.text = _bottomRandomText!;
  }

  void resetColors() {
    setTopRandomColor = _random.nextInt(8);
    setBottomRandomColor = _random.nextInt(8);
    setTopRandomText = _random.nextInt(8);
    setBottomRandomText = _random.nextInt(8);
  }

  Future<void> checkYes() async {
    ColorEnum top = _spanish
        ? getColorEnumBySpanishString(_topRandomText!)
        : getColorEnumByString(_topRandomText!);
    ColorEnum bottom = _bottomRandomColor!;
    if (top == bottom) {
      await gameRef.correctAnswer();
      resetColors();
    } else {
      await gameRef.incorrectAnswer();
    }
  }

  Future<void> checkNo() async {
    ColorEnum top = _spanish
        ? getColorEnumBySpanishString(_topRandomText!)
        : getColorEnumByString(_topRandomText!);
    ColorEnum bottom = _bottomRandomColor!;
    if (top != bottom) {
      await gameRef.correctAnswer();
      resetColors();
    } else {
      await gameRef.incorrectAnswer();
    }
  }
}

class TopColor extends TextComponent with HasGameRef<GoColor>, Tappable {
  bool visible = true;

  TopColor({ColorEnum? color, String? text})
      : super(
            text: text,
            anchor: Anchor.center,
            textRenderer: TextPaint(
                style: GoogleFonts.poppins(
              color: getColorByEnum(color!),
              fontSize: 35,
              fontWeight: FontWeight.bold,
            )));

  @override
  void render(Canvas canvas) {
    textRenderer.render(canvas, text, Vector2.zero());
  }

  @override
  void onGameResize(Vector2 gameSize) {
    x = gameSize.x / 2;
    y = gameSize.y / 3 - 60;
    super.onGameResize(gameSize);
  }

  @override
  Future<void> onLoad() async {}

  @override
  bool onTapDown(_) {
    return true;
  }

  @override
  void renderTree(Canvas canvas) {
    if (visible) {
      super.renderTree(canvas);
    }
  }
}

class TopRectangle extends RectangleComponent with HasGameRef {
  TopRectangle()
      : super(
            size: Vector2(250, 120),
            paint: Paint()
              ..color = Colors.white
              ..strokeWidth = 2
              ..style = PaintingStyle.fill);

  @override
  Future<void> onLoad() async {}

  @override
  void onGameResize(Vector2 gameSize) {
    x = gameSize.x / 2;
    y = gameSize.y / 3 - 60;
    super.onGameResize(gameSize);
  }
}

class BottomColor extends TextComponent with HasGameRef<GoColor>, Tappable {
  bool visible = true;

  BottomColor({ColorEnum? color, String? text})
      : super(
            text: text,
            anchor: Anchor.center,
            textRenderer: TextPaint(
                style: GoogleFonts.poppins(
              color: getColorByEnum(color!),
              fontSize: 35,
              fontWeight: FontWeight.bold,
            )));

  @override
  Future<void> onLoad() async {}

  @override
  void render(Canvas canvas) {
    textRenderer.render(canvas, text, Vector2.zero());
  }

  @override
  void onGameResize(Vector2 gameSize) {
    x = gameSize.x / 2;
    y = gameSize.y / 1.8 - 45;
    super.onGameResize(gameSize);
  }

  @override
  bool onTapDown(_) {
    return true;
  }

  @override
  void renderTree(Canvas canvas) {
    if (visible) {
      super.renderTree(canvas);
    }
  }
}

class BottomRectangle extends RectangleComponent with HasGameRef {
  BottomRectangle()
      : super(
            size: Vector2(250, 120),
            paint: Paint()
              ..color = Colors.white
              ..strokeWidth = 2
              ..style = PaintingStyle.fill);

  @override
  Future<void> onLoad() async {}

  @override
  void onGameResize(Vector2 gameSize) {
    x = gameSize.x / 2;
    y = gameSize.y / 1.8 - 45;
    super.onGameResize(gameSize);
  }
}
