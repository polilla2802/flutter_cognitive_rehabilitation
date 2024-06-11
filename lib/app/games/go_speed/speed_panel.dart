import 'package:flame/components.dart';

import 'package:flutter/material.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/providers/providers.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/games/go_speed/go_speed.dart';

class SpeedPanel extends Component with HasGameRef<GoSpeed>, Tappable {
  late bool _visible;
  late BuildContext? _context;

  late SpeedEnum? _speedEnum;

  SpeedPanel({BuildContext? context}) {
    _context = context;
    _speedEnum = null;

    _visible = false;
  }

  @override
  Future<void> onLoad() async {}

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

  set setSpeed(SpeedEnum? speed) {
    _speedEnum = speed;
  }

  void resetIcon() {
    Provider.of<GoSpeedProvider>(_context!, listen: false)
        .getIcon(difficulty: gameRef.getDifficulty);
  }

  Future<void> checkYes() async {
    SpeedEnum currentIcon =
        Provider.of<GoSpeedProvider>(_context!, listen: false).speedIcon;
    if (_speedEnum == currentIcon) {
      await gameRef.correctAnswer();
      resetIcon();
      setSpeed = currentIcon;
    } else {
      await gameRef.incorrectAnswer(currentIcon);
    }
  }

  Future<void> checkNo() async {
    SpeedEnum currentIcon =
        Provider.of<GoSpeedProvider>(_context!, listen: false).speedIcon;
    if (_speedEnum != currentIcon) {
      await gameRef.correctAnswer();
      resetIcon();
      setSpeed = currentIcon;
    } else {
      await gameRef.incorrectAnswer(currentIcon);
    }
  }
}
