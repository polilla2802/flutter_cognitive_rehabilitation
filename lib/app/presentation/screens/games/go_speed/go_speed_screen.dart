import 'package:flame/game.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

import 'package:flutter/material.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/providers/providers.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/games/go_speed/go_speed.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/buttons/buttons.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/indicators/indicators.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/common/common_widgets.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/game_icons/game_icons.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/containers/info_container.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/games/go_speed/go_speed_details_screen.dart';

class GoSpeedScreenArgs {
  final int? highScore;
  final int? timesPlayed;
  final bool showDashboard;
  final GoSpeedDifficulty difficulty;

  GoSpeedScreenArgs({
    this.highScore,
    this.timesPlayed,
    this.showDashboard = false,
    this.difficulty = GoSpeedDifficulty.Zero,
  });
}

class GoSpeedScreen extends StatefulWidget {
  static const String goSpeedScreenKey = "/go_speed_screen";
  final int? highScore;
  final int? timesPlayed;
  final bool showDashboard;
  final GoSpeedDifficulty difficulty;

  const GoSpeedScreen(
      {super.key,
      this.highScore,
      this.timesPlayed,
      this.showDashboard = false,
      this.difficulty = GoSpeedDifficulty.Zero});

  @override
  State<GoSpeedScreen> createState() => GoSpeedScreenState(
      goSpeedScreenKey, highScore, timesPlayed, showDashboard, difficulty);
}

class GoSpeedScreenState extends State<GoSpeedScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late String _key;
  late GoSpeed _goSpeed;
  late int? _highScore;
  late bool _showDashboard;
  late GoSpeedDifficulty _difficulty;

  late Color _color = Colors.black54;

  late AnimationController _controller;

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastLinearToSlowEaseIn,
  );

  late VideoPlayerController _videoController;

  GoSpeedScreenState(String goSpeedScreenKey, int? highScore, int? timesPlayed,
      bool showDashboard, GoSpeedDifficulty difficulty) {
    _key = goSpeedScreenKey;
    _highScore = highScore;
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
    _goSpeed = GoSpeed(
        lives: Provider.of<GoSpeedProvider>(context, listen: false).lives,
        time: Provider.of<GoSpeedProvider>(context, listen: false).time,
        multiplier:
            Provider.of<GoSpeedProvider>(context, listen: false).multiplier,
        difficulty: _difficulty,
        highScore: _highScore,
        context: context);
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance
        .addPostFrameCallback((_) async => await _afterBuild());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        print("resumed goColor");
        if (mounted) {
          if (_goSpeed.isMounted) {
            if (_goSpeed.paused) _goSpeed.resumeEngine();
          }
        }
        break;
      case AppLifecycleState.detached:
        print("detached");
        break;
      case AppLifecycleState.inactive:
        print("inactive");
        break;
      case AppLifecycleState.paused:
        if (mounted) if (_goSpeed.isMounted) if (_goSpeed.paused == false)
          _goSpeed.pauseEngine();
        print("paused GoColor");
        break;
      default:
    }
  }

  Future<void> _afterBuild() async {
    _controller.forward();
  }

  Future<void> _goToGoSpeedDetailsScreen() async {
    await Navigator.of(context).pushReplacementNamed(
        GoSpeedDetailsScreen.goSpeedDetailsScreenKey,
        arguments: GoSpeedScreenArgs(
            difficulty: _difficulty, showDashboard: _showDashboard));
  }

  VideoPlayerController getVideoByDifficulty() {
    switch (_difficulty) {
      case GoSpeedDifficulty.Zero:
        return VideoPlayerController.asset(
            "assets/video/games/background-0.mp4")
          ..initialize().then((_) {
            // Once the video has been loaded we play the video and set looping to true.
            _videoController.play();
            _videoController.setLooping(true);
            // Ensure the first frame is shown after the video is initialized.
            setState(() {});
          });
      case GoSpeedDifficulty.One:
        return VideoPlayerController.asset(
            "assets/video/games/background-1.mp4")
          ..initialize().then((_) {
            // Once the video has been loaded we play the video and set looping to true.
            _videoController.play();
            _videoController.setLooping(true);
            // Ensure the first frame is shown after the video is initialized.
            setState(() {});
          });
      case GoSpeedDifficulty.Two:
        return VideoPlayerController.asset(
            "assets/video/games/background-2.mp4")
          ..initialize().then((_) {
            // Once the video has been loaded we play the video and set looping to true.
            _videoController.play();
            _videoController.setLooping(true);
            // Ensure the first frame is shown after the video is initialized.
            setState(() {});
          });
      case GoSpeedDifficulty.Three:
        return VideoPlayerController.asset(
            "assets/video/games/background-3.mp4")
          ..initialize().then((_) {
            // Once the video has been loaded we play the video and set looping to true.
            _videoController.play();
            _videoController.setLooping(true);
            // Ensure the first frame is shown after the video is initialized.
            setState(() {});
          });
      case GoSpeedDifficulty.Four:
        return VideoPlayerController.asset(
            "assets/video/games/background-4.mp4")
          ..initialize().then((_) {
            // Once the video has been loaded we play the video and set looping to true.
            _videoController.play();
            _videoController.setLooping(true);
            // Ensure the first frame is shown after the video is initialized.
            setState(() {});
          });
      case GoSpeedDifficulty.Five:
        return VideoPlayerController.asset(
            "assets/video/games/background-5.mp4")
          ..initialize().then((_) {
            // Once the video has been loaded we play the video and set looping to true.
            _videoController.play();
            _videoController.setLooping(true);
            // Ensure the first frame is shown after the video is initialized.
            setState(() {});
          });
      case GoSpeedDifficulty.Six:
        return VideoPlayerController.asset(
            "assets/video/games/background-6.mp4")
          ..initialize().then((_) {
            // Once the video has been loaded we play the video and set looping to true.
            _videoController.play();
            _videoController.setLooping(true);
            // Ensure the first frame is shown after the video is initialized.
            setState(() {});
          });
      case GoSpeedDifficulty.Seven:
        return VideoPlayerController.asset(
            "assets/video/games/background-7.mp4")
          ..initialize().then((_) {
            // Once the video has been loaded we play the video and set looping to true.
            _videoController.play();
            _videoController.setLooping(true);
            // Ensure the first frame is shown after the video is initialized.
            setState(() {});
          });
      case GoSpeedDifficulty.Eight:
        return VideoPlayerController.asset(
            "assets/video/games/background-8.mp4")
          ..initialize().then((_) {
            // Once the video has been loaded we play the video and set looping to true.
            _videoController.play();
            _videoController.setLooping(true);
            // Ensure the first frame is shown after the video is initialized.
            setState(() {});
          });
      case GoSpeedDifficulty.Nine:
        return VideoPlayerController.asset(
            "assets/video/games/background-9.mp4")
          ..initialize().then((_) {
            // Once the video has been loaded we play the video and set looping to true.
            _videoController.play();
            _videoController.setLooping(true);
            // Ensure the first frame is shown after the video is initialized.
            setState(() {});
          });
      case GoSpeedDifficulty.Ten:
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
              backgroundColor: ConstValues.myBlackColor,
              centerTitle: true,
              leading: Provider.of<GoSpeedProvider>(context).navigation
                  ? BackArrow(
                      onTap: () async => await _goToGoSpeedDetailsScreen(),
                      color: ConstValues.goSpeedColor)
                  : Container(),
              title: Text(
                "GoSpeed",
                style: GoogleFonts.poppins(
                    fontSize: 24,
                    color: ConstValues.goSpeedColor,
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
                          "assets/images/games/go_speed/GoSpeed-icon.png",
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
                      child: GameWidget(game: _goSpeed),
                    ),
                    _buildIcon(),
                    _buildButtons(),
                    Positioned(
                        child: Container(
                      child: _buildOpacity(),
                    )),
                    _goSpeed.getState == GameState.GameReady
                        ? Positioned(
                            child: Container(
                            padding: EdgeInsets.only(bottom: 40),
                            child: _buildLevelIndicator(),
                          ))
                        : Container(),
                    _goSpeed.getState == GameState.GameReady
                        ? Container()
                        : Provider.of<GoSpeedProvider>(context).navigation
                            ? _buildRestartButton()
                            : Container(),
                  ],
                )))
      ],
    ));
  }

  Widget _buildOpacity() {
    return _goSpeed.getState == GameState.GameReady
        ? Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: _color,
          )
        : Container();
  }

  Widget _buildIcon() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Align(
        alignment: Alignment.center,
        child: Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 200),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Provider.of<GoSpeedProvider>(context).gameState ==
                            GameState.Intro ||
                        Provider.of<GoSpeedProvider>(context).gameState ==
                            GameState.Playing
                    ? Provider.of<GoSpeedProvider>(context).icon != null
                        ? Container(
                            decoration: BoxDecoration(
                              color: HexColor.fromHex("#191D1F"),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 8,
                                  offset: Offset(0, 0),
                                ),
                              ],
                            ),
                            width: 200,
                            height: 200,
                            child: Provider.of<GoSpeedProvider>(context).icon!)
                        : Container(
                            decoration: BoxDecoration(
                              color: HexColor.fromHex("#191D1F"),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 8,
                                  offset: Offset(0, 0),
                                ),
                              ],
                            ),
                            width: 200,
                            height: 200,
                            child: Icon(
                              Icons.cancel,
                              color: Colors.red,
                              size: 150,
                            ))
                    : Container()
              ],
            )),
      ),
    );
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
                    GoSpeedIcon(showStats: true, isInGame: true),
                    ..._getRaiseLevels(),
                    _buildTBICard(),
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
                  child: GoSpeedRestartButton(
                    text: "New Game",
                    onPressed: () async => await _goSpeed.intro(),
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
                  child: GoSpeedRestartButton(
                    text: "New Game",
                    onPressed: () async => await _goSpeed.intro(),
                  ),
                )
              ],
            )),
      ),
    );
  }

  List<Widget> _getRaiseLevels() {
    switch (getGameDifficultyBySpeedDifficulty(_difficulty)) {
      case GameDifficulty.easy:
        return [
          Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _buildResponseMeter(3)),
        ];

      case GameDifficulty.medium:
        return [
          Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _buildResponseMeter(5)),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _buildMemoryMeter(5)),
        ];
      case GameDifficulty.hard:
        return [
          Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _buildResponseMeter(8)),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _buildMemoryMeter(6)),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _buildSpeedMeter(5))
        ];
      default:
        return [
          Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _buildResponseMeter(3)),
        ];
    }
  }

  Widget _buildResponseMeter(int raise) {
    return _goSpeed.getState == GameState.GameReady
        ? ResponseLevelUpMeter(raise: raise)
        : Container();
  }

  Widget _buildMemoryMeter(int raise) {
    return _goSpeed.getState == GameState.GameReady
        ? MemoryLevelUpMeter(raise: raise)
        : Container();
  }

  Widget _buildSpeedMeter(int raise) {
    return _goSpeed.getState == GameState.GameReady
        ? SpeedLevelUpMeter(raise: raise)
        : Container();
  }

  Widget _buildButtons() {
    return Provider.of<GoSpeedProvider>(context).enabled
        ? Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 45),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: SecondaryGoSpeedButton(
                          text: "No",
                          onPressed:
                              Provider.of<GoSpeedProvider>(context).enabled
                                  ? () async => await _goSpeed.no()
                                  : null,
                        ),
                      ),
                      Container(
                        width: 16,
                        height: 0,
                      ),
                      Flexible(
                        child: PrimaryGoSpeedButton(
                          text: "Yes",
                          onPressed:
                              Provider.of<GoSpeedProvider>(context).enabled
                                  ? () async => await _goSpeed.yes()
                                  : null,
                        ),
                      ),
                    ],
                  )),
            ),
          )
        : Container();
  }

  Widget _buildTBICard() {
    return _goSpeed.getState == GameState.GameReady
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
  void dispose() {
    print('$_key Dispose invoked');
    _controller.dispose();
    _goSpeed.disposeGame();
    _goSpeed.pauseEngine();
    super.dispose();
  }
}
