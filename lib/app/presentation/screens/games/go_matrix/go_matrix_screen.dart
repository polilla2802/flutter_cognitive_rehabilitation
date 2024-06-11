import 'package:flame/game.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

import 'package:flutter/material.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/providers/providers.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/games/go_matrix/go_matrix.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/buttons/buttons.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/indicators/indicators.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/common/common_widgets.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/game_icons/game_icons.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/containers/info_container.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/games/go_matrix/go_matrix_details_screen.dart';

class GoMatrixScreenArgs {
  final int? highScore;
  final bool showDashboard;
  final GoMatrixDifficulty difficulty;

  GoMatrixScreenArgs(
      {this.highScore,
      this.showDashboard = false,
      this.difficulty = GoMatrixDifficulty.Zero});
}

class GoMatrixScreen extends StatefulWidget {
  static const String goMatrixScreenKey = "/go_matrix_screen";
  final int? highScore;
  final bool showDashboard;
  final GoMatrixDifficulty difficulty;

  const GoMatrixScreen(
      {super.key,
      this.highScore,
      this.showDashboard = false,
      this.difficulty = GoMatrixDifficulty.Zero});

  @override
  State<GoMatrixScreen> createState() => GoMatrixScreenState(
      goMatrixScreenKey, highScore, showDashboard, difficulty);
}

class GoMatrixScreenState extends State<GoMatrixScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late String _key;
  late GoMatrix _goMatrix;
  late int? _highScore;
  late bool _showDashboard;
  late GoMatrixDifficulty _difficulty;

  late AnimationController _controller;

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastLinearToSlowEaseIn,
  );

  late VideoPlayerController _videoController;

  late Color _color = Colors.black54;

  GoMatrixScreenState(String goMatrixScreenKey, int? highScore,
      bool showDashboard, GoMatrixDifficulty difficulty) {
    _key = goMatrixScreenKey;
    _showDashboard = showDashboard;
    _difficulty = difficulty;
    _highScore = highScore;
  }

  @override
  void initState() {
    super.initState();
    print("$_key invoked");
    _videoController = getVideoByDifficulty();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    _goMatrix = GoMatrix(
      context: context,
      difficulty: _difficulty,
      highScore: _highScore,
      lives: Provider.of<GoMatrixProvider>(context, listen: false).lives,
      level: Provider.of<GoMatrixProvider>(context, listen: false).userLevel,
      exp: Provider.of<GoMatrixProvider>(context, listen: false).userExp,
      tiles: Provider.of<GoMatrixProvider>(context, listen: false).tiles,
      time: Provider.of<GoMatrixProvider>(context, listen: false).time,
      multiplier:
          Provider.of<GoMatrixProvider>(context, listen: false).multiplier,
    );
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance
        .addPostFrameCallback((_) async => await _afterBuild());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        print("resumed GoMatrix");
        if (mounted) {
          if (_goMatrix.paused) _goMatrix.resumeEngine();
        }
        break;
      case AppLifecycleState.detached:
        print("detached");
        break;
      case AppLifecycleState.inactive:
        print("inactive");
        break;
      case AppLifecycleState.paused:
        if (_goMatrix.paused == false) _goMatrix.pauseEngine();
        print("paused GoMatrix");
        break;
      default:
    }
  }

  Future<void> _afterBuild() async {
    _controller.forward();
  }

  Future<void> _goToGoMatrixDetailsScreen() async {
    await Navigator.of(context)
        .pushReplacementNamed(GoMatrixDetailsScreen.goMatrixDetailsScreenKey,
            arguments: GoMatrixScreenArgs(
              showDashboard: _showDashboard,
              difficulty: _difficulty,
            ));
  }

  VideoPlayerController getVideoByDifficulty() {
    switch (_difficulty) {
      case GoMatrixDifficulty.Zero:
        return VideoPlayerController.asset(
            "assets/video/games/background-0.mp4")
          ..initialize().then((_) {
            // Once the video has been loaded we play the video and set looping to true.
            _videoController.play();
            _videoController.setLooping(true);
            // Ensure the first frame is shown after the video is initialized.
            setState(() {});
          });
      case GoMatrixDifficulty.One:
        return VideoPlayerController.asset(
            "assets/video/games/background-1.mp4")
          ..initialize().then((_) {
            // Once the video has been loaded we play the video and set looping to true.
            _videoController.play();
            _videoController.setLooping(true);
            // Ensure the first frame is shown after the video is initialized.
            setState(() {});
          });
      case GoMatrixDifficulty.Two:
        return VideoPlayerController.asset(
            "assets/video/games/background-2.mp4")
          ..initialize().then((_) {
            // Once the video has been loaded we play the video and set looping to true.
            _videoController.play();
            _videoController.setLooping(true);
            // Ensure the first frame is shown after the video is initialized.
            setState(() {});
          });
      case GoMatrixDifficulty.Three:
        return VideoPlayerController.asset(
            "assets/video/games/background-3.mp4")
          ..initialize().then((_) {
            // Once the video has been loaded we play the video and set looping to true.
            _videoController.play();
            _videoController.setLooping(true);
            // Ensure the first frame is shown after the video is initialized.
            setState(() {});
          });
      case GoMatrixDifficulty.Four:
        return VideoPlayerController.asset(
            "assets/video/games/background-4.mp4")
          ..initialize().then((_) {
            // Once the video has been loaded we play the video and set looping to true.
            _videoController.play();
            _videoController.setLooping(true);
            // Ensure the first frame is shown after the video is initialized.
            setState(() {});
          });
      case GoMatrixDifficulty.Five:
        return VideoPlayerController.asset(
            "assets/video/games/background-5.mp4")
          ..initialize().then((_) {
            // Once the video has been loaded we play the video and set looping to true.
            _videoController.play();
            _videoController.setLooping(true);
            // Ensure the first frame is shown after the video is initialized.
            setState(() {});
          });
      case GoMatrixDifficulty.Six:
        return VideoPlayerController.asset(
            "assets/video/games/background-6.mp4")
          ..initialize().then((_) {
            // Once the video has been loaded we play the video and set looping to true.
            _videoController.play();
            _videoController.setLooping(true);
            // Ensure the first frame is shown after the video is initialized.
            setState(() {});
          });
      case GoMatrixDifficulty.Seven:
        return VideoPlayerController.asset(
            "assets/video/games/background-7.mp4")
          ..initialize().then((_) {
            // Once the video has been loaded we play the video and set looping to true.
            _videoController.play();
            _videoController.setLooping(true);
            // Ensure the first frame is shown after the video is initialized.
            setState(() {});
          });
      case GoMatrixDifficulty.Eight:
        return VideoPlayerController.asset(
            "assets/video/games/background-8.mp4")
          ..initialize().then((_) {
            // Once the video has been loaded we play the video and set looping to true.
            _videoController.play();
            _videoController.setLooping(true);
            // Ensure the first frame is shown after the video is initialized.
            setState(() {});
          });
      case GoMatrixDifficulty.Nine:
        return VideoPlayerController.asset(
            "assets/video/games/background-9.mp4")
          ..initialize().then((_) {
            // Once the video has been loaded we play the video and set looping to true.
            _videoController.play();
            _videoController.setLooping(true);
            // Ensure the first frame is shown after the video is initialized.
            setState(() {});
          });
      case GoMatrixDifficulty.Ten:
        return VideoPlayerController.asset(
            "assets/video/games/background-10.mp4")
          ..initialize().then((_) {
            // Once the video has been loaded we play the video and set looping to true.
            _videoController.play();
            _videoController.setLooping(true);
            // Ensure the first frame is shown after the video is initialized.
            setState(() {});
          });
      default:
        return VideoPlayerController.asset(
            "assets/video/games/background-1.mp4")
          ..initialize().then((_) {
            // Once the video has been loaded we play the video and set looping to true.
            _videoController.play();
            _videoController.setLooping(true);
            // Ensure the first frame is shown after the video is initialized.
            setState(() {});
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: ConstValues.blackColor,
              centerTitle: true,
              leading: Provider.of<GoMatrixProvider>(context).navigation
                  ? BackArrow(
                      onTap: () async => await _goToGoMatrixDetailsScreen(),
                      color: ConstValues.myPurpleColor,
                    )
                  : Container(),
              title: Text(
                "GoMatrix",
                style: GoogleFonts.poppins(
                    fontSize: 24,
                    color: ConstValues.myPurpleColor,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.none),
              ),
              actions: [
                RotationTransition(
                  turns: _animation,
                  child: ScaleTransition(
                    scale: _animation,
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Image.asset(
                          "assets/images/games/go_matrix/tile_maps/purple.png",
                          width: 30,
                        )),
                  ),
                )
              ],
            ),
            body: _buildBody()),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
        child: Column(
      children: [
        Expanded(
            child: Container(
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    VideoPlayer(_videoController),
                    Positioned(
                      child: GameWidget(game: _goMatrix),
                    ),
                    Positioned(
                        child: Container(
                      child: _buildOpacity(),
                    )),
                    _goMatrix.getState == GameState.GameReady
                        ? Positioned(
                            child: Container(
                            padding: EdgeInsets.only(bottom: 40),
                            child: _buildLevelIndicator(),
                          ))
                        : Container(),
                    _goMatrix.getState == GameState.GameReady
                        ? Container()
                        : Provider.of<GoMatrixProvider>(context).navigation
                            ? _buildRestartButton()
                            : Container(),
                    getGameDifficultyByMatrixDifficulty(_difficulty) ==
                            GameDifficulty.easy
                        ? Container()
                        : Provider.of<GoMatrixProvider>(context).navigation
                            ? _buildHintButton()
                            : Container(),
                    Provider.of<GoMatrixProvider>(context).visiblePause
                        ? _buildPauseButton()
                        : Container(),
                  ],
                )))
      ],
    ));
  }

  Widget _buildOpacity() {
    return _goMatrix.getState == GameState.GameReady
        ? Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: _color,
          )
        : Container();
  }

  Widget _buildLevelIndicator() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.only(top: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildRestartButtonCenter(),
                    GoMatrixIcon(showStats: true, isInGame: true),
                    ..._getRaiseLevels(),
                    _buildTBICard(),
                  ],
                )),
          ),
        ),
      ],
    );
  }

  List<Widget> _getRaiseLevels() {
    switch (getGameDifficultyByMatrixDifficulty(_difficulty)) {
      case GameDifficulty.easy:
        return [
          Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _buildMemoryMeter(4)),
        ];

      case GameDifficulty.medium:
        return [
          Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _buildMemoryMeter(5)),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _buildFocusMeter(3)),
        ];
      case GameDifficulty.hard:
        return [
          Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _buildMemoryMeter(8)),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _buildFocusMeter(4)),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _buildLogicMeter(7)),
        ];
      default:
        return [
          Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _buildMemoryMeter(4)),
        ];
    }
  }

  Widget _buildMemoryMeter(int raise) {
    return _goMatrix.getState == GameState.GameReady
        ? MemoryLevelUpMeter(raise: raise)
        : Container();
  }

  Widget _buildFocusMeter(int raise) {
    return _goMatrix.getState == GameState.GameReady
        ? FocusLevelUpMeter(raise: raise)
        : Container();
  }

  Widget _buildLogicMeter(int raise) {
    return _goMatrix.getState == GameState.GameReady
        ? LogicLevelUpMeter(raise: raise)
        : Container();
  }

  Widget _buildRestartButton() {
    return Container(
      padding: EdgeInsets.only(top: 8, left: 16),
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 150,
                  child: GoMatrixRestartButton(
                    text: "New Game",
                    onPressed: () => _goMatrix.restart(),
                  ),
                )
              ],
            )),
      ),
    );
  }

  Widget _buildRestartButtonCenter() {
    return Container(
      padding: EdgeInsets.only(bottom: 16),
      child: Align(
        alignment: Alignment.center,
        child: Container(
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 150,
                  child: GoMatrixRestartButton(
                    text: "New Game",
                    onPressed: () => _goMatrix.restart(),
                  ),
                )
              ],
            )),
      ),
    );
  }

  Widget _buildHintButton() {
    if (Provider.of<GoMatrixProvider>(context).hints != 0) {
      return Container(
        padding: EdgeInsets.only(top: 60, left: 16),
        child: Align(
          alignment: Alignment.topLeft,
          child: Container(
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    child: GoMatrixRestartButton(
                      text: "Hint",
                      onPressed: () => _goMatrix.hint(),
                    ),
                  )
                ],
              )),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildPauseButton() {
    return Provider.of<GoMatrixProvider>(context).paused
        ? GestureDetector(
            onTap: () => _goMatrix.resumeGame(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                    padding: EdgeInsets.only(top: 16, right: 8),
                    child: Image.asset(
                      "assets/images/icons/play-icon-white.png",
                      width: 32,
                    )),
              ],
            ),
          )
        : GestureDetector(
            onTap: () => _goMatrix.pauseGame(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                    padding: EdgeInsets.only(top: 16, right: 8),
                    child: Image.asset(
                      "assets/images/icons/pause-icon-white.png",
                      width: 32,
                    )),
              ],
            ),
          );
  }

  Widget _buildTBICard() {
    return _goMatrix.getState == GameState.GameReady
        ? Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Provider.of<TBIProvider>(context).effect == null
                ? Container()
                : InfoContainer(
                    title: Provider.of<TBIProvider>(context, listen: true)
                        .effect!
                        .title,
                    description: Provider.of<TBIProvider>(context, listen: true)
                        .effect!
                        .description!))
        : Container();
  }

  @override
  void dispose() async {
    print('$_key Dispose invoked');
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    _goMatrix.disposeGame();
    _goMatrix.pauseEngine();
    super.dispose();
  }
}
