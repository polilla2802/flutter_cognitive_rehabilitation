import 'package:flame/game.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

import 'package:flutter/material.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/providers/providers.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/games/go_pop/go_pop.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/buttons/buttons.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/indicators/indicators.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/common/common_widgets.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/game_icons/game_icons.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/containers/info_container.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/games/go_pop/go_pop_details_screen.dart';

class GoPopScreenArgs {
  final int? highScore;
  final bool shine;
  final bool showDashboard;
  final GoPopDifficulty difficulty;

  GoPopScreenArgs(
      {this.highScore,
      this.shine = false,
      this.showDashboard = false,
      this.difficulty = GoPopDifficulty.Zero});
}

class GoPopScreen extends StatefulWidget {
  static const String goPopScreenKey = "/go_pop_screen";
  final int? highScore;
  final bool shine;
  final bool showDashboard;
  final GoPopDifficulty difficulty;

  const GoPopScreen(
      {super.key,
      this.highScore,
      this.shine = false,
      this.showDashboard = false,
      this.difficulty = GoPopDifficulty.Zero});

  @override
  State<GoPopScreen> createState() => GoPopScreenState(
      goPopScreenKey, highScore, shine, showDashboard, difficulty);
}

class GoPopScreenState extends State<GoPopScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late String _key;
  late GoPop _goPop;
  late int? _highScore;
  late bool _shine;
  late bool _showDashboard;
  late GoPopDifficulty _difficulty;

  late AnimationController _controller;

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastLinearToSlowEaseIn,
  );

  late VideoPlayerController _videoController;

  late Color _color = Colors.black54;

  GoPopScreenState(String goPopScreenKey, int? highScore, bool shine,
      bool showDashboard, GoPopDifficulty difficulty) {
    _key = goPopScreenKey;
    _highScore = highScore;
    _shine = shine;
    _showDashboard = showDashboard;
    _difficulty = difficulty;
  }

  @override
  void initState() {
    super.initState();
    print("$_key invoked");
    _videoController = getVideoByDifficulty();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    _goPop = GoPop(
        level: Provider.of<GoPopProvider>(context, listen: false).userLevel,
        exp: Provider.of<GoPopProvider>(context, listen: false).userExp,
        lives: Provider.of<GoPopProvider>(context, listen: false).lives,
        time: Provider.of<GoPopProvider>(context, listen: false).time,
        multiplier:
            Provider.of<GoPopProvider>(context, listen: false).multiplier,
        difficulty: _difficulty,
        highScore: _highScore,
        shine: _shine,
        context: context);
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance
        .addPostFrameCallback((_) async => await _afterBuild());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        print("resumed GoPop");
        if (mounted) {
          if (_goPop.paused) _goPop.resumeEngine();
        }
        break;
      case AppLifecycleState.detached:
        print("detached");
        break;
      case AppLifecycleState.inactive:
        print("inactive");
        break;
      case AppLifecycleState.paused:
        if (_goPop.paused == false) _goPop.pauseEngine();
        print("paused GoPop");
        break;
      default:
    }
  }

  Future<void> _afterBuild() async {
    _controller.forward();
  }

  Future<void> _goToGoPopDetailsScreen(bool shine) async {
    await Navigator.of(context).pushReplacementNamed(
        GoPopDetailsScreen.goPopDetailsScreenKey,
        arguments: GoPopScreenArgs(
            difficulty: _difficulty,
            shine: shine,
            showDashboard: _showDashboard));
  }

  VideoPlayerController getVideoByDifficulty() {
    switch (_difficulty) {
      case GoPopDifficulty.Zero:
        return VideoPlayerController.asset(
            "assets/video/games/background-0.mp4")
          ..initialize().then((_) {
            // Once the video has been loaded we play the video and set looping to true.
            _videoController.play();
            _videoController.setLooping(true);
            // Ensure the first frame is shown after the video is initialized.
            setState(() {});
          });
      case GoPopDifficulty.One:
        return VideoPlayerController.asset(
            "assets/video/games/background-1.mp4")
          ..initialize().then((_) {
            // Once the video has been loaded we play the video and set looping to true.
            _videoController.play();
            _videoController.setLooping(true);
            // Ensure the first frame is shown after the video is initialized.
            setState(() {});
          });
      case GoPopDifficulty.Two:
        return VideoPlayerController.asset(
            "assets/video/games/background-2.mp4")
          ..initialize().then((_) {
            // Once the video has been loaded we play the video and set looping to true.
            _videoController.play();
            _videoController.setLooping(true);
            // Ensure the first frame is shown after the video is initialized.
            setState(() {});
          });
      case GoPopDifficulty.Three:
        return VideoPlayerController.asset(
            "assets/video/games/background-3.mp4")
          ..initialize().then((_) {
            // Once the video has been loaded we play the video and set looping to true.
            _videoController.play();
            _videoController.setLooping(true);
            // Ensure the first frame is shown after the video is initialized.
            setState(() {});
          });
      case GoPopDifficulty.Four:
        return VideoPlayerController.asset(
            "assets/video/games/background-4.mp4")
          ..initialize().then((_) {
            // Once the video has been loaded we play the video and set looping to true.
            _videoController.play();
            _videoController.setLooping(true);
            // Ensure the first frame is shown after the video is initialized.
            setState(() {});
          });
      case GoPopDifficulty.Five:
        return VideoPlayerController.asset(
            "assets/video/games/background-5.mp4")
          ..initialize().then((_) {
            // Once the video has been loaded we play the video and set looping to true.
            _videoController.play();
            _videoController.setLooping(true);
            // Ensure the first frame is shown after the video is initialized.
            setState(() {});
          });
      case GoPopDifficulty.Six:
        return VideoPlayerController.asset(
            "assets/video/games/background-6.mp4")
          ..initialize().then((_) {
            // Once the video has been loaded we play the video and set looping to true.
            _videoController.play();
            _videoController.setLooping(true);
            // Ensure the first frame is shown after the video is initialized.
            setState(() {});
          });
      case GoPopDifficulty.Seven:
        return VideoPlayerController.asset(
            "assets/video/games/background-7.mp4")
          ..initialize().then((_) {
            // Once the video has been loaded we play the video and set looping to true.
            _videoController.play();
            _videoController.setLooping(true);
            // Ensure the first frame is shown after the video is initialized.
            setState(() {});
          });
      case GoPopDifficulty.Eight:
        return VideoPlayerController.asset(
            "assets/video/games/background-8.mp4")
          ..initialize().then((_) {
            // Once the video has been loaded we play the video and set looping to true.
            _videoController.play();
            _videoController.setLooping(true);
            // Ensure the first frame is shown after the video is initialized.
            setState(() {});
          });
      case GoPopDifficulty.Nine:
        return VideoPlayerController.asset(
            "assets/video/games/background-9.mp4")
          ..initialize().then((_) {
            // Once the video has been loaded we play the video and set looping to true.
            _videoController.play();
            _videoController.setLooping(true);
            // Ensure the first frame is shown after the video is initialized.
            setState(() {});
          });
      case GoPopDifficulty.Ten:
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
              leading: Provider.of<GoPopProvider>(context).navigation
                  ? BackArrow(
                      onTap: () async => await _goToGoPopDetailsScreen(_shine),
                      color: _shine
                          ? ConstValues.goShineColor
                          : ConstValues.goPopColor,
                    )
                  : Container(),
              title: Text(
                _shine ? "GoShine" : "GoPop",
                style: GoogleFonts.poppins(
                    fontSize: 24,
                    color: _shine
                        ? ConstValues.goShineColor
                        : ConstValues.goPopColor,
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
                      child: _shine
                          ? Image.asset(
                              "assets/images/games/go_pop/shine.png",
                              width: 30,
                            )
                          : Image.asset(
                              "assets/images/games/go_pop/hex.png",
                              width: 30,
                            ),
                    ),
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
            child: Container(
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    VideoPlayer(_videoController),
                    Positioned(
                      child: GameWidget(game: _goPop),
                    ),
                    Positioned(
                        child: Container(
                      child: _buildOpacity(),
                    )),
                    _goPop.getState == GameState.GameReady
                        ? Positioned(
                            child: Container(
                            padding: EdgeInsets.only(bottom: 40),
                            child: _buildLevelIndicator(),
                          ))
                        : Container(),
                    _goPop.getState == GameState.GameReady
                        ? Container()
                        : Provider.of<GoPopProvider>(context).navigation
                            ? _buildRestartButton()
                            : Container(),
                  ],
                )))
      ],
    ));
  }

  Widget _buildOpacity() {
    return _goPop.getState == GameState.GameReady
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
                    GoPopIcon(showStats: true, isInGame: true),
                    ..._getRaiseLevels(),
                    _buildTBICard()
                  ],
                )),
          ),
        ),
      ],
    );
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
                  child: GoPopRestartButton(
                    text: "New Game",
                    shine: _shine,
                    onPressed: () async => await _goPop.restart(),
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
                  child: GoPopRestartButton(
                    text: "New Game",
                    shine: _shine,
                    onPressed: () async => await _goPop.restart(),
                  ),
                )
              ],
            )),
      ),
    );
  }

  List<Widget> _getRaiseLevels() {
    switch (getGameDifficultyByPopDifficulty(_difficulty)) {
      case GameDifficulty.easy:
        return [
          Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _buildReflexMeter(2)),
        ];

      case GameDifficulty.medium:
        return [
          Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _buildReflexMeter(4)),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _buildFocusMeter(3)),
        ];
      case GameDifficulty.hard:
        return [
          Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _buildReflexMeter(8)),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _buildFocusMeter(5)),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _buildSpeedMeter(6)),
        ];
      default:
        return [
          Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _buildReflexMeter(2)),
        ];
    }
  }

  Widget _buildReflexMeter(int raise) {
    return _goPop.getState == GameState.GameReady
        ? ReflexLevelUpMeter(raise: raise)
        : Container();
  }

  Widget _buildFocusMeter(int raise) {
    return _goPop.getState == GameState.GameReady
        ? FocusLevelUpMeter(raise: raise)
        : Container();
  }

  Widget _buildSpeedMeter(int raise) {
    return _goPop.getState == GameState.GameReady
        ? SpeedLevelUpMeter(raise: raise)
        : Container();
  }

  Widget _buildTBICard() {
    return _goPop.getState == GameState.GameReady
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
    _videoController.dispose();
    _controller.dispose();
    _goPop.disposeGame();
    _goPop.pauseEngine();
    super.dispose();
  }
}
