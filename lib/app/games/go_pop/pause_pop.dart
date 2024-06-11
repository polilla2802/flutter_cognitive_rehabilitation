import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'package:flutter/material.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/games/go_pop/go_pop.dart';

enum PauseState { Paused, Played }

class PausePop extends SpriteComponent
    with HasGameRef<GoPop>, CollisionCallbacks, Tappable {
  late bool _visible;
  late PauseState _state;

  PausePop({Vector2? position})
      : super(
            anchor: Anchor.center,
            size: Vector2(32, 32),
            position: Vector2.all(0)) {
    _visible = false;
    _state = PauseState.Played;
  }

  set setState(PauseState state) {
    _state = state;
  }

  @override
  Future<void> onLoad() async {
    switch (_state) {
      case PauseState.Paused:
        sprite = await Sprite.load('icons/play-icon-white.png');
        break;
      case PauseState.Played:
        sprite = await Sprite.load('icons/pause-icon-white.png');
        break;
      default:
        sprite = await Sprite.load('icons/pause-icon-white.png');
        break;
    }
  }

  @override
  bool onTapDown(_) {
    if (!_visible) {
      return false;
    }

    switch (_state) {
      case PauseState.Paused:
        gameRef.startTimer();
        setState = PauseState.Played;
        gameRef.setState = GameState.Playing;
        gameRef.resumeBackgroundMusic();
        break;
      case PauseState.Played:
        gameRef.stopTimer();
        setState = PauseState.Paused;
        gameRef.setState = GameState.Paused;
        gameRef.pauseBackgroundMusic();
        break;
      default:
        gameRef.stopTimer();
        setState = PauseState.Played;
        break;
    }
    return true;
  }

  @override
  void renderTree(Canvas canvas) {
    if (_visible) {
      super.renderTree(canvas);
    }
  }

  @override
  void update(double dt) async {
    super.update(dt);
    if (gameRef.isPlaying) {
      sprite = await Sprite.load('icons/pause-icon-white.png');
      _visible = true;
    } else if (gameRef.isPaused) {
      sprite = await Sprite.load('icons/play-icon-white.png');
      _visible = true;
    } else {
      _visible = false;
    }
  }
}
