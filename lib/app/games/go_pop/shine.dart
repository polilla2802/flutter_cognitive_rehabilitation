import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'package:flutter/material.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/providers/providers.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/games/go_pop/go_pop.dart';

enum ShineState { Shine, ShinePop, ShineRed }

class Shine extends SpriteComponent
    with HasGameRef<GoPop>, CollisionCallbacks, Tappable {
  late bool _visible;
  late double _multiplier;
  late ShineState _state;

  Shine(
      {Vector2? position,
      GameDifficulty difficulty = GameDifficulty.easy,
      double multiplier = 1.0})
      : super(
          anchor: Anchor.center,
          size: Vector2(100, 110),
          position: position ?? Vector2.all(0),
        ) {
    _visible = false;
    _multiplier = multiplier;
    switch (difficulty) {
      case GameDifficulty.easy:
        _state = ShineState.Shine;
        break;
      case GameDifficulty.medium:
        _state = ShineState.ShinePop;
        break;
      case GameDifficulty.hard:
        _state = ShineState.ShineRed;
        break;
      default:
        _state = ShineState.Shine;
        break;
    }
  }

  set setState(ShineState state) {
    _state = state;
  }

  @override
  Future<void> onLoad() async {
    switch (_state) {
      case ShineState.Shine:
        sprite = await Sprite.load('games/go_pop/shine.png');
        break;
      case ShineState.ShinePop:
        sprite = await Sprite.load('games/go_pop/shine-pop.png');
        break;
      case ShineState.ShineRed:
        sprite = await Sprite.load('games/go_pop/shine-red.png');
        break;
      default:
        sprite = await Sprite.load('games/go_pop/shine.png');
        break;
    }
  }

  @override
  bool onTapDown(_) {
    if (!_visible) {
      return false;
    }

    switch (_state) {
      case ShineState.Shine:
        double doubleScore = gameRef.gameScore.toDouble();
        double result = doubleScore += 100.0 * _multiplier;
        gameRef.setScore = result.toInt();
        gameRef.resetPositions();
        gameRef.playShine();
        break;
      case ShineState.ShinePop:
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
        gameRef.playWrongFox1();
        break;
      case ShineState.ShineRed:
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
        gameRef.playWrongFox2();
        break;
      default:
        double doubleScore = gameRef.gameScore.toDouble();
        double result = doubleScore += 100.0 * _multiplier;
        gameRef.setScore = result.toInt();
        gameRef.setScore = gameRef.gameScore += 1;
        gameRef.resetPositions();
        gameRef.playShine();
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
