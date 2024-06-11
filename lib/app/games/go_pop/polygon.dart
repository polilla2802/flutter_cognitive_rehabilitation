import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'package:flutter/material.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/providers/providers.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/games/go_pop/go_pop.dart';

enum LowPolygonState { Hex, HexShine, HexRed }

class LowPolygon extends SpriteComponent
    with HasGameRef<GoPop>, CollisionCallbacks, Tappable {
  late bool _visible;
  late double _multiplier;
  late LowPolygonState _state;

  LowPolygon(
      {Vector2? position,
      GameDifficulty difficulty = GameDifficulty.easy,
      double multiplier = 1.0})
      : super(
            anchor: Anchor.center,
            size: Vector2(100, 90),
            position: Vector2.all(0)) {
    _visible = false;
    _multiplier = multiplier;
    switch (difficulty) {
      case GameDifficulty.easy:
        _state = LowPolygonState.Hex;
        break;
      case GameDifficulty.medium:
        _state = LowPolygonState.HexShine;
        break;
      case GameDifficulty.hard:
        _state = LowPolygonState.HexRed;
        break;
      default:
        _state = LowPolygonState.Hex;
        break;
    }
  }

  set setState(LowPolygonState state) {
    _state = state;
  }

  @override
  Future<void> onLoad() async {
    switch (_state) {
      case LowPolygonState.Hex:
        sprite = await Sprite.load('games/go_pop/hex.png');
        break;
      case LowPolygonState.HexShine:
        sprite = await Sprite.load('games/go_pop/hex-shine.png');
        break;
      case LowPolygonState.HexRed:
        sprite = await Sprite.load('games/go_pop/hex-red.png');
        break;
      default:
        sprite = await Sprite.load('games/go_pop/hex.png');
        break;
    }
  }

  @override
  bool onTapDown(_) {
    if (!_visible) {
      return false;
    }

    switch (_state) {
      case LowPolygonState.Hex:
        double doubleScore = gameRef.gameScore.toDouble();
        double result = doubleScore += 100.0 * _multiplier;
        gameRef.setScore = result.toInt();
        gameRef.resetPositions();
        gameRef.playLaser();
        break;
      case LowPolygonState.HexShine:
        double doubleScore = gameRef.gameScore.toDouble();
        double result = doubleScore -= 130.0 * _multiplier;
        if (result <= 0) {
          gameRef.setScore = 0;
        } else {
          gameRef.setScore = result.toInt();
        }
        int newLife = gameRef.lives - 1;
        if (newLife == 0) {
          gameRef.setLives = newLife;
          gameRef.gameOver();
        } else {
          gameRef.setLives = newLife;
          gameRef.resetPositions();
        }
        gameRef.playWrong();
        break;
      case LowPolygonState.HexRed:
        double doubleScore = gameRef.gameScore.toDouble();
        double result = doubleScore -= 130.0 * _multiplier;
        if (result <= 0) {
          gameRef.setScore = 0;
        } else {
          gameRef.setScore = result.toInt();
        }
        int newLife = gameRef.lives - 1;
        if (newLife == 0) {
          gameRef.setLives = newLife;
          gameRef.gameOver();
        } else {
          gameRef.setLives = newLife;
          gameRef.resetPositions();
        }
        gameRef.playWrong();
        break;
      default:
        double doubleScore = gameRef.gameScore.toDouble();
        double result = doubleScore += 100.0 * _multiplier;
        gameRef.setScore = result.toInt();
        gameRef.resetPositions();
        gameRef.playLaser();
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
      _visible = true;
    } else {
      _visible = false;
    }
  }
}
