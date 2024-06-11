import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart' as Material;

import 'package:mobile_app_cognitive_rehabilitation/app/providers/providers.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/games/go_matrix/selector.dart'
    as Selector;
import 'package:mobile_app_cognitive_rehabilitation/app/games/go_matrix/game_panel.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/common/common_widgets.dart';

enum GameState {
  Intro,
  ShowTiles,
  Playing,
  Incorrect,
  Paused,
  GameOver,
  GameReady
}

class GoMatrix extends FlameGame with HasTappables {
  static const description = '''
 In this game the goal is to decide if the meaning of the 
 top word matches the text color of the bottom word.
  ''';

  @override
  Color backgroundColor() => ConstValues.myBlackColor[100]!;

  late bool _visible;
  late bool _win;

  late Vector2 centerPosition;
  late double scale;
  late double srcTileSize;
  late double destTileSize;

  late double tileHeight;
  late double _originalMultiplier;

  late Matrix base;
  late Matrix memoryBase;
  late Selector.Selector selector;

  late List<List<int>> _memory = [];
  late List<List<int>> _matrix = [];
  late Random _random;

  late SpriteSheet _tileset;
  late Image _tilesetImage;

  late bool _touchable;

  late GoMatrixDifficulty _difficulty;

  late Material.BuildContext? _context;
  late GameState _state;

  late GamePanel _gamePanel;

  int _hints = 1;
  bool _gameOver = false;

  GoMatrix(
      {Material.BuildContext? context,
      GoMatrixDifficulty difficulty = GoMatrixDifficulty.Zero,
      int? highScore,
      int lives = 0,
      int tiles = 5,
      int time = 25,
      int level = 0,
      int exp = 0,
      double multiplier = 1.0}) {
    _context = context;
    _difficulty = difficulty;
    _state = GameState.Intro;
    _originalMultiplier = multiplier;
    _win = false;
    _random = Random();
    getScale(getGameDifficultyByMatrixDifficulty(_difficulty));
    srcTileSize = 32.0;
    destTileSize = scale * srcTileSize;
    tileHeight = scale * (8.0);
    fillMatrix(getGameDifficultyByMatrixDifficulty(_difficulty));
    generateRandomMemory(_difficulty);
    _gamePanel = GamePanel(
        lives: lives,
        tiles: tiles,
        time: time,
        level: level,
        exp: exp,
        highScore: highScore,
        context: context,
        multiplier: multiplier,
        difficulty: getGameDifficultyByMatrixDifficulty(_difficulty));
    _touchable = false;
  }

  @override
  Future<void> onLoad() async {
    _tilesetImage =
        await images.load('games/go_matrix/tile_maps/tiles-short.png');
    final selectorImage =
        await images.load('games/go_matrix/tile_maps/selector-short.png');
    _tileset = SpriteSheet(
      image: _tilesetImage,
      srcSize: Vector2.all(srcTileSize),
    );
    memoryBase = Matrix(
      _tileset,
      _memory,
      destTileSize: Vector2.all(destTileSize),
      tileHeight: tileHeight,
      position: centerPosition,
    );
    add(
      base = Matrix(
        _tileset,
        _memory,
        destTileSize: Vector2.all(destTileSize),
        tileHeight: tileHeight,
        position: centerPosition,
      ),
    );
    add(selector = Selector.Selector(destTileSize, selectorImage));
    add(_gamePanel);

    FlameAudio.bgm.initialize();

    Provider.of<GoMatrixProvider>(_context!, listen: false).pauseGame = false;

    Provider.of<GoMatrixProvider>(_context!, listen: false).showPause = false;
  }

  @override
  Future<void> onMount() async {
    disableNavigation();

    if (isIntro) {
      await FlameAudio.play('intro/start.mp3');
      await Future.delayed(const Duration(milliseconds: 1000), () async {
        start();
        await playBackgroundMusic();
        Provider.of<GoMatrixProvider>(_context!, listen: false).showPause =
            true;
      });
    }
  }

  @override
  bool onTapDown(int id, TapDownInfo _) {
    if (!_touchable) {
      return false;
    }

    if (getState == GameState.Playing && _win == false) {
      final screenPosition = _.eventPosition.game;
      final block = memoryBase.getBlock(screenPosition);
      bool containsBlock = memoryBase.containsBlock(block);
      if (containsBlock) {
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
          _gamePanel.setMultiplier = _originalMultiplier;
          base..matrix = _memory;
          setState = GameState.ShowTiles;
          _gamePanel.incorrect();
        } else if (blockValue == 2) {
        } else {
          _memory[block.y][block.x] = 0;
          memoryBase..matrix[block.y][block.x] = 0;
          base..matrix[block.y][block.x] = 0;
          FlameAudio.play('games/go_pop/laser.mp3');
          _gamePanel.correct();
          _win = checkWin(getGameDifficultyByMatrixDifficulty(_difficulty));
          if (_win) {
            _gamePanel.winMatrix();
            FlameAudio.play('correct_answer/correct.mp3');
            newMatrix();
          }
        }
      } else {
        selector.show = false;
      }
    }
    return false;
  }

  @override
  void update(double dt) {
    if (isIntro) {
      _visible = true;
      _touchable = false;
      selector.show = false;
    } else if (isPlaying) {
      base..matrix = _matrix;
      _visible = true;
      _touchable = true;
    } else if (isIncorrect) {
      _visible = true;
      _touchable = false;
    } else if (isShowingTiles) {
      _visible = true;
      _touchable = false;
      selector.show = false;
    } else if (isGameReady) {
      _visible = false;
      _touchable = false;
      enableNavigation();
      selector.show = false;
      _hints = 0;
    } else if (isPaused) {
      selector.show = false;
    } else {
      _visible = false;
      _touchable = false;
      selector.show = false;
      _hints = 0;
    }
    super.update(dt);
  }

  @override
  void onGameResize(Vector2? size) {
    centerPosition = Vector2(size!.x / 2, size.y / 2 - 100);
    super.onGameResize(size);
  }

  void generateRandomMemory(GoMatrixDifficulty difficulty) {
    switch (difficulty) {
      case GoMatrixDifficulty.Zero:
        List<int> randList = [];
        List<int> baseMatrix = [];
        int tileNumber = 9;
        int randomNumbers = 3;

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
        int chunkSize = 3;
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
      case GoMatrixDifficulty.One:
        List<int> randList = [];
        List<int> baseMatrix = [];
        int tileNumber = 9;
        int randomNumbers = 4;

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
        int chunkSize = 3;
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
      case GoMatrixDifficulty.Two:
        List<int> randList = [];
        List<int> baseMatrix = [];
        int tileNumber = 9;
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
        int chunkSize = 3;
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
      case GoMatrixDifficulty.Three:
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
      case GoMatrixDifficulty.Four:
        List<int> randList = [];
        List<int> baseMatrix = [];
        int tileNumber = 16;
        int randomNumbers = 6;

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
      case GoMatrixDifficulty.Five:
        List<int> randList = [];
        List<int> baseMatrix = [];
        int tileNumber = 16;
        int randomNumbers = 7;

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
      case GoMatrixDifficulty.Six:
        List<int> randList = [];
        List<int> baseMatrix = [];
        int tileNumber = 16;
        int randomNumbers = 8;

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
      case GoMatrixDifficulty.Seven:
        List<int> randList = [];
        List<int> baseMatrix = [];
        int tileNumber = 25;
        int randomNumbers = 7;

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
        int chunkSize = 5;
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
      case GoMatrixDifficulty.Eight:
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
        print(_memory);
        break;
      case GoMatrixDifficulty.Nine:
        List<int> randList = [];
        List<int> baseMatrix = [];
        int tileNumber = 25;
        int randomNumbers = 9;

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
        int chunkSize = 5;
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
      case GoMatrixDifficulty.Ten:
        List<int> randList = [];
        List<int> baseMatrix = [];
        int tileNumber = 25;
        int randomNumbers = 10;

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
        int chunkSize = 5;
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
      default:
        List<int> randList = [];
        List<int> baseMatrix = [];
        int tileNumber = 9;
        int randomNumbers = 3;

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
        int chunkSize = 3;
        for (var i = 0; i < baseMatrix.length; i += chunkSize) {
          chunks.add(baseMatrix.sublist(
              i,
              i + chunkSize > baseMatrix.length
                  ? baseMatrix.length
                  : i + chunkSize));
        }
        _memory = chunks;
        print(_memory);
    }
  }

  void fillMatrix(GameDifficulty difficulty) {
    switch (difficulty) {
      case GameDifficulty.easy:
        for (var i = 0; i < 3; i++) {
          List<int> row = List.generate(3, (i) => 1);
          _matrix.add(row);
        }
        break;
      case GameDifficulty.medium:
        for (var i = 0; i < 4; i++) {
          List<int> row = List.generate(4, (i) => 1);
          _matrix.add(row);
        }
        break;
      case GameDifficulty.hard:
        for (var i = 0; i < 5; i++) {
          List<int> row = List.generate(5, (i) => 1);
          _matrix.add(row);
        }
        break;
      default:
    }
  }

  void getScale(GameDifficulty difficulty) {
    switch (difficulty) {
      case GameDifficulty.easy:
        scale = 3.0;
        break;
      case GameDifficulty.medium:
        scale = 2.7;
        break;
      case GameDifficulty.hard:
        scale = 2.2;
        break;
      default:
    }
  }

  bool get isIntro => _state == GameState.Intro;
  bool get isShowingTiles => _state == GameState.ShowTiles;
  bool get isPlaying => _state == GameState.Playing;
  bool get isIncorrect => _state == GameState.Incorrect;
  bool get isPaused => _state == GameState.Paused;
  bool get isGameOver => _state == GameState.GameOver;
  bool get isGameReady => _state == GameState.GameReady;
  GameState get getState => _state;

  set setState(GameState state) {
    _state = state;
  }

  Future<void> playBackgroundMusic() async {
    switch (_difficulty) {
      case GoMatrixDifficulty.Zero:
        await FlameAudio.bgm.play('bg_music/bg-v0.mp3', volume: 0.5);
        break;
      case GoMatrixDifficulty.One:
        await FlameAudio.bgm.play('bg_music/bg-v1.mp3', volume: 0.5);
        break;
      case GoMatrixDifficulty.Two:
        await FlameAudio.bgm.play('bg_music/bg-v2.mp3', volume: 0.5);
        break;
      case GoMatrixDifficulty.Three:
        await FlameAudio.bgm.play('bg_music/bg-v3.mp3', volume: 0.5);
        break;
      case GoMatrixDifficulty.Four:
        await FlameAudio.bgm.play('bg_music/bg-v4.mp3', volume: 0.5);
        break;
      case GoMatrixDifficulty.Five:
        await FlameAudio.bgm.play('bg_music/bg-v5.mp3', volume: 0.5);
        break;
      case GoMatrixDifficulty.Six:
        await FlameAudio.bgm.play('bg_music/bg-v6.mp3', volume: 0.5);
        break;
      case GoMatrixDifficulty.Seven:
        await FlameAudio.bgm.play('bg_music/bg-v7.mp3', volume: 0.5);
        break;
      case GoMatrixDifficulty.Eight:
        await FlameAudio.bgm.play('bg_music/bg-v8.mp3', volume: 0.5);
        break;
      case GoMatrixDifficulty.Nine:
        await FlameAudio.bgm.play('bg_music/bg-v9.mp3', volume: 0.5);
        break;
      case GoMatrixDifficulty.Ten:
        await FlameAudio.bgm.play('bg_music/bg-v10.mp3', volume: 0.5);
        break;
      default:
        await FlameAudio.bgm.play('bg_music/bg-v0.mp3', volume: 0.5);
    }
  }

  Future<void> pauseBackgroundMusic() async {
    await FlameAudio.bgm.pause();
  }

  Future<void> resumeBackgroundMusic() async {
    await FlameAudio.bgm.resume();
  }

  Future<void> newMatrix() async {
    _win = false;
    _gamePanel.setTiles =
        Provider.of<GoMatrixProvider>(_context!, listen: false).tiles;
    setState = GameState.ShowTiles;
    _matrix.clear();
    _memory.clear();
    generateRandomMemory(_difficulty);
    fillMatrix(getGameDifficultyByMatrixDifficulty(_difficulty));
    base..matrix = _memory;
    memoryBase..matrix = _memory;
    selector.show = false;
    selector.position = Vector2.all(0);
    await Future.delayed(const Duration(milliseconds: 1000), () async {
      if (_gameOver == false) {
        setState = GameState.Playing;
        Provider.of<GoMatrixProvider>(_context!, listen: false).showPause =
            true;
        if (_hints != 0) {
          Provider.of<GoMatrixProvider>(_context!, listen: false).setMyHints =
              1;
        } else {}
      } else {}
    });
  }

  Future<void> restart() async {
    await FlameAudio.play('intro/start.mp3');
    Provider.of<GoMatrixProvider>(_context!, listen: false).showPause = true;
    Provider.of<GoMatrixProvider>(_context!, listen: false).setMyHints = 0;
    enableNavigation();
    _gamePanel.setMultiplier = _originalMultiplier;
    setState = GameState.ShowTiles;
    _gamePanel.setRecord = RecordState.oldRecord;
    _win = false;
    _gameOver = false;
    _hints = 1;
    _matrix.clear();
    _memory.clear();
    generateRandomMemory(_difficulty);
    fillMatrix(getGameDifficultyByMatrixDifficulty(_difficulty));
    base..matrix = _memory;
    memoryBase..matrix = _memory;
    selector.show = false;
    selector.position = Vector2.all(0);
    _gamePanel.reset();
  }

  Future<void> gameOver() async {
    _gameOver = true;
    selector.show = false;
    Provider.of<GoMatrixProvider>(_context!, listen: false).showPause = false;
    Provider.of<GoMatrixProvider>(_context!, listen: false).setMyHints = 0;
    disableNavigation();
    getRandomEffect();
    await _gamePanel.addRecord();
    enableNavigation();
  }

  Future<void> hint() async {
    _hints = 0;
    Provider.of<GoMatrixProvider>(_context!, listen: false).setMyHints = 0;
    base..matrix = _memory;
    setState = GameState.ShowTiles;
    await Future.delayed(const Duration(milliseconds: 300), () async {
      base..matrix = _matrix;
      setState = GameState.Playing;
    });
  }

  bool checkWin(GameDifficulty difficulty) {
    switch (difficulty) {
      case GameDifficulty.easy:
        for (var i = 0; i < 3; i++) {
          if (_memory[i].contains(3)) {
            return false;
          }
        }
        return true;
      case GameDifficulty.medium:
        for (var i = 0; i < 4; i++) {
          if (_memory[i].contains(3)) {
            return false;
          }
        }
        return true;
      case GameDifficulty.hard:
        for (var i = 0; i < 5; i++) {
          if (_memory[i].contains(3)) {
            return false;
          }
        }
        return true;
      default:
        for (var i = 0; i < 3; i++) {
          if (_memory[i].contains(3)) {
            return false;
          }
        }
        return true;
    }
  }

  void start() {
    enableNavigation();
    Provider.of<GoMatrixProvider>(_context!, listen: false).setMyHints = 0;
    setState = GameState.ShowTiles;
    _gamePanel.setRecord = RecordState.oldRecord;
    _gamePanel.reset();
  }

  void startTimer() {
    _gamePanel.startTimer();
  }

  void stopTimer() {
    _gamePanel.stopTimer();
  }

  void resumeTimer() {
    _gamePanel.resumeTimer();
  }

  void resetTimer() {
    _gamePanel.resetTimer();
  }

  void enableNavigation() {
    Provider.of<GoMatrixProvider>(_context!, listen: false).enableNavigation();
  }

  void disableNavigation() {
    Provider.of<GoMatrixProvider>(_context!, listen: false).disableNavigation();
  }

  void getRandomEffect() {
    Provider.of<TBIProvider>(_context!, listen: false).getRandomEffect();
  }

  void disposeGame() {
    FlameAudio.bgm.dispose();
    _gamePanel.stopTimer();
  }

  void resumeGame() {
    Provider.of<GoMatrixProvider>(_context!, listen: false).pauseGame = false;
    resumeTimer();
    setState = GameState.Playing;
    resumeBackgroundMusic();
    enableNavigation();
  }

  void pauseGame() {
    Provider.of<GoMatrixProvider>(_context!, listen: false).pauseGame = true;
    stopTimer();
    setState = GameState.Paused;
    pauseBackgroundMusic();
    disableNavigation();
  }
}

class Matrix extends IsometricTileMapComponent with HasGameRef<GoMatrix> {
  bool visible = true;

  Matrix(SpriteSheet tileset, List<List<int>> matrix,
      {Vector2? destTileSize, double? tileHeight, Vector2? position})
      : super(tileset, matrix,
            destTileSize: destTileSize,
            tileHeight: tileHeight,
            position: position);

  @override
  void update(double dt) {
    if (gameRef.isIntro) {
      visible = false;
    } else if (gameRef.isPlaying) {
      visible = true;
    } else if (gameRef.isIncorrect) {
      visible = true;
    } else if (gameRef.isShowingTiles) {
      visible = true;
    } else if (gameRef.isGameReady) {
      visible = false;
    } else {
      visible = false;
    }
    super.update(dt);
  }

  @override
  void renderTree(Canvas canvas) {
    if (visible) {
      super.renderTree(canvas);
    }
  }
}
