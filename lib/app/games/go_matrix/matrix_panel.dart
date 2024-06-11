import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/sprite.dart';
import 'package:flame_audio/flame_audio.dart';

import 'package:mobile_app_cognitive_rehabilitation/app/providers/providers.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/games/go_matrix/go_matrix.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/games/go_matrix/selector.dart'
    as Selector;

class MatrixPanel extends Component with HasGameRef<GoMatrix>, Tappable {
  late bool _visible;
  late bool _win;

  late Vector2 centerPosition;
  late GameDifficulty _difficulty;
  late double scale;
  late double srcTileSize;
  late double destTileSize;

  late bool _halfSize;
  late double tileHeight;
  late String suffix;

  late IsometricTileMapComponent base;
  late IsometricTileMapComponent memoryBase;
  late Selector.Selector selector;

  late List<List<int>> _memory = [];
  late List<List<int>> _matrix = [];
  late Random _random;

  late SpriteSheet _tileset;
  late Image _tilesetImage;
  late Image _selectorImage;

  late bool _touchable;

  MatrixPanel(
      {GameDifficulty difficulty = GameDifficulty.easy,
      Image? tilesetImage,
      Image? selectorImage}) {
    _tilesetImage = tilesetImage!;
    _selectorImage = selectorImage!;
    _visible = false;
    _halfSize = true;
    _win = false;
    _difficulty = difficulty;
    _random = Random();
    getScale(_difficulty);
    srcTileSize = 32.0;
    suffix = _halfSize ? '-short' : '';
    destTileSize = scale * srcTileSize;
    tileHeight = scale * (_halfSize ? 8.0 : 16.0);
    fillMatrix(_difficulty);
    generateRandomMemory(_difficulty);
    _touchable = false;
  }

  void generateRandomMemory(GameDifficulty difficulty) {
    switch (difficulty) {
      case GameDifficulty.easy:
        List<int> randList = [];
        List<int> baseMatrix = [];
        int tileNumber = 16;
        int randomNumbers = 5;

        baseMatrix = List.generate(tileNumber, (i) => 1);

        while (randList.length < randomNumbers) {
          int randomNumber = _random.nextInt(tileNumber);
          if (!randList.contains(randomNumber)) {
            randList.add(randomNumber);
          }
        }

        for (var i = 0; i < randList.length; i++) {
          baseMatrix[randList[i]] = 3;
        }

        List<List<int>> chunks = [];
        int chunkSize = 4;
        for (var i = 0; i < baseMatrix.length; i += chunkSize) {
          chunks.add(baseMatrix.sublist(
              i,
              i + chunkSize > baseMatrix.length
                  ? baseMatrix.length
                  : i + chunkSize));
        }
        _memory = chunks;
        print(_memory);
        break;
      case GameDifficulty.medium:
        List<int> randList = [];
        List<int> baseMatrix = [];
        int tileNumber = 25;
        int randomNumbers = 8;
        baseMatrix = List.generate(tileNumber, (i) => 1);

        while (randList.length < randomNumbers) {
          int randomNumber = _random.nextInt(tileNumber);
          if (!randList.contains(randomNumber)) {
            randList.add(randomNumber);
          }
        }

        for (var i = 0; i < randList.length; i++) {
          print(randList[i]);
          baseMatrix[randList[i]] = 3;
        }

        List<List<int>> chunks = [];
        int chunkSize = 5;
        for (var i = 0; i < baseMatrix.length; i += chunkSize) {
          chunks.add(baseMatrix.sublist(
              i,
              i + chunkSize > baseMatrix.length
                  ? baseMatrix.length
                  : i + chunkSize));
        }
        _memory = chunks;
        break;
      case GameDifficulty.hard:
        List<int> randList = [];
        List<int> baseMatrix = [];
        int tileNumber = 36;
        int randomNumbers = 10;
        baseMatrix = List.generate(tileNumber, (i) => 1);

        while (randList.length < randomNumbers) {
          int randomNumber = _random.nextInt(tileNumber);
          if (!randList.contains(randomNumber)) {
            randList.add(randomNumber);
          }
        }

        for (var i = 0; i < randList.length; i++) {
          print(randList[i]);
          baseMatrix[randList[i]] = 3;
        }

        List<List<int>> chunks = [];
        int chunkSize = 6;
        for (var i = 0; i < baseMatrix.length; i += chunkSize) {
          chunks.add(baseMatrix.sublist(
              i,
              i + chunkSize > baseMatrix.length
                  ? baseMatrix.length
                  : i + chunkSize));
        }
        _memory = chunks;
        break;
      default:
    }
  }

  void fillMatrix(GameDifficulty difficulty) {
    switch (difficulty) {
      case GameDifficulty.easy:
        for (var i = 0; i < 4; i++) {
          List<int> row = List.generate(4, (i) => 1);
          _matrix.add(row);
        }
        break;
      case GameDifficulty.medium:
        for (var i = 0; i < 5; i++) {
          List<int> row = List.generate(5, (i) => 1);
          _matrix.add(row);
        }
        break;
      case GameDifficulty.hard:
        for (var i = 0; i < 6; i++) {
          List<int> row = List.generate(6, (i) => 1);
          _matrix.add(row);
        }
        break;
      default:
    }
  }

  @override
  Future<void> onLoad() async {
    _tileset = SpriteSheet(
      image: _tilesetImage,
      srcSize: Vector2.all(srcTileSize),
    );
    memoryBase = IsometricTileMapComponent(
      _tileset,
      _memory,
      destTileSize: Vector2.all(destTileSize),
      tileHeight: tileHeight,
      position: centerPosition,
    );
    add(
      base = IsometricTileMapComponent(
        _tileset,
        _memory,
        destTileSize: Vector2.all(destTileSize),
        tileHeight: tileHeight,
        position: centerPosition,
      ),
    );
    add(selector = Selector.Selector(destTileSize, _selectorImage));

    _touchable = true;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (gameRef.isPlaying) {
      _visible = true;
      _touchable = true;
    } else if (gameRef.isShowingTiles) {
      _visible = true;
      _touchable = true;
    } else {
      _visible = false;
      _touchable = true;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  @override
  void renderTree(Canvas canvas) {
    if (_visible) {
      super.renderTree(canvas);
    }
  }

  @override
  void onGameResize(Vector2? size) {
    centerPosition = Vector2(size!.x / 2, size.y / 2 - 100);
    super.onGameResize(size);
  }

  @override
  bool onTapDown(_) {
    print("tapped");
    if (!_touchable) {
      return false;
    }

    if (gameRef.getState == GameState.Playing && _win == false) {
      final screenPosition = _.eventPosition.game;
      final block = memoryBase.getBlock(screenPosition);
      bool containsBlock = memoryBase.containsBlock(block);
      if (!containsBlock) {
        selector.show = false;
        return false;
      }
      selector.show = true;
      selector.position
          .setFrom(centerPosition + memoryBase.getBlockRenderPosition(block));
      int blockValue = memoryBase.blockValue(Block(block.x, block.y));
      if (blockValue == 0) {
      } else if (blockValue == 1) {
        _touchable = false;
        _memory[block.y][block.x] = 2;
        memoryBase..matrix[block.y][block.x] = 2;
        base..matrix[block.y][block.x] = 2;
        FlameAudio.play('wrong_answer/wrong.mp3');
        Future.delayed(const Duration(milliseconds: 1000), () async {
          _touchable = true;
        });
      } else if (blockValue == 2) {
      } else {
        _touchable = true;
        _memory[block.y][block.x] = 0;
        memoryBase..matrix[block.y][block.x] = 0;
        base..matrix[block.y][block.x] = 0;
        FlameAudio.play('games/go_pop/laser.mp3');
      }
    }
    return false;
  }

  void getScale(GameDifficulty difficulty) {
    switch (_difficulty) {
      case GameDifficulty.easy:
        scale = 2.6;
        break;
      case GameDifficulty.medium:
        scale = 2.2;
        break;
      case GameDifficulty.hard:
        scale = 1.8;
        break;
      default:
    }
  }
}
