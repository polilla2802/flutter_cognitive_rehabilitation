import 'package:flame/game.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

import 'package:flutter/material.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/providers/providers.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/games/go_color/go_color.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/buttons/buttons.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/common/common_widgets.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/indicators/indicators.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/game_icons/game_icons.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/containers/info_container.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/games/go_color/go_color_details_screen.dart';

class GoColorScreenArgs {
  final int? highScore;
  final int? timesPlayed;
  final bool spanish;
  final bool showDashboard;
  final GoColorDifficulty difficulty;

  GoColorScreenArgs(
      {this.highScore,
      this.timesPlayed,
      this.spanish = false,
      this.showDashboard = false,
      this.difficulty = GoColorDifficulty.Zero});
}

class GoColorScreen extends StatefulWidget {
  static const String goColorScreenKey = "/go_color_screen";
  final int? highScore;
  final int? timesPlayed;
  final bool spanish;
  final bool showDashboard;
  final GoColorDifficulty difficulty;

  const GoColorScreen(
      {super.key,
      this.highScore,
      this.timesPlayed,
      this.spanish = false,
      this.showDashboard = false,
      this.difficulty = GoColorDifficulty.Zero});

  @override
  State<GoColorScreen> createState() => GoColorScreenState(
        goColorScreenKey,
        highScore,
        timesPlayed,
        spanish,
        showDashboard,
        difficulty,
      );
}

class GoColorScreenState extends State<GoColorScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late String _key;
  late GoColor _goColor;
  late int? _highScore;
  late bool _spanish;
  late bool _showDashboard;
  late GoColorDifficulty _difficulty;

  late AnimationController _controller;

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastLinearToSlowEaseIn,
  );

  late VideoPlayerController _videoController;

  late Color _color = Colors.black54;

  GoColorScreenState(String goColorScreenKey, int? highScore, int? timesPlayed,
      bool spanish, bool showDashboard, GoColorDifficulty difficulty) {
    _key = goColorScreenKey;
    _highScore = highScore;
    _spanish = spanish;
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
    _goColor = GoColor(
        level: Provider.of<GoColorProvider>(context, listen: false).userLevel,
        exp: Provider.of<GoColorProvider>(context, listen: false).userExp,
        lives: Provider.of<GoColorProvider>(context, listen: false).lives,
        time: Provider.of<GoColorProvider>(context, listen: false).time,
        multiplier:
            Provider.of<GoColorProvider>(context, listen: false).multiplier,
        difficulty: _difficulty,
        highScore: _highScore,
        context: context,
        spanish: _spanish);
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
          if (_goColor.isMounted) {
            if (_goColor.paused) _goColor.resumeEngine();
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
        if (mounted) if (_goColor.isMounted) if (_goColor.paused == false)
          _goColor.pauseEngine();
        print("paused GoColor");
        break;
      default:
    }
  }

  Future<void> _afterBuild() async {
    _controller.forward();
  }

  Future<void> _goToGoColorDetailsScreen(bool spanish) async {
    await Navigator.of(context).pushReplacementNamed(
        GoColorDetailsScreen.goColorDetailsScreenKey,
        arguments: GoColorScreenArgs(
            difficulty: _difficulty,
            spanish: spanish,
            showDashboard: _showDashboard));
  }

  VideoPlayerController getVideoByDifficulty() {
    switch (_difficulty) {
      case GoColorDifficulty.Zero:
        return VideoPlayerController.asset(
            "assets/video/games/background-0.mp4")
          ..initialize().then((_) {
            // Once the video has been loaded we play the video and set looping to true.
            _videoController.play();
            _videoController.setLooping(true);
            // Ensure the first frame is shown after the video is initialized.
            setState(() {});
          });
      case GoColorDifficulty.One:
        return VideoPlayerController.asset(
            "assets/video/games/background-1.mp4")
          ..initialize().then((_) {
            // Once the video has been loaded we play the video and set looping to true.
            _videoController.play();
            _videoController.setLooping(true);
            // Ensure the first frame is shown after the video is initialized.
            setState(() {});
          });
      case GoColorDifficulty.Two:
        return VideoPlayerController.asset(
            "assets/video/games/background-2.mp4")
          ..initialize().then((_) {
            // Once the video has been loaded we play the video and set looping to true.
            _videoController.play();
            _videoController.setLooping(true);
            // Ensure the first frame is shown after the video is initialized.
            setState(() {});
          });
      case GoColorDifficulty.Three:
        return VideoPlayerController.asset(
            "assets/video/games/background-3.mp4")
          ..initialize().then((_) {
            // Once the video has been loaded we play the video and set looping to true.
            _videoController.play();
            _videoController.setLooping(true);
            // Ensure the first frame is shown after the video is initialized.
            setState(() {});
          });
      case GoColorDifficulty.Four:
        return VideoPlayerController.asset(
            "assets/video/games/background-4.mp4")
          ..initialize().then((_) {
            // Once the video has been loaded we play the video and set looping to true.
            _videoController.play();
            _videoController.setLooping(true);
            // Ensure the first frame is shown after the video is initialized.
            setState(() {});
          });
      case GoColorDifficulty.Five:
        return VideoPlayerController.asset(
            "assets/video/games/background-5.mp4")
          ..initialize().then((_) {
            // Once the video has been loaded we play the video and set looping to true.
            _videoController.play();
            _videoController.setLooping(true);
            // Ensure the first frame is shown after the video is initialized.
            setState(() {});
          });
      case GoColorDifficulty.Six:
        return VideoPlayerController.asset(
            "assets/video/games/background-6.mp4")
          ..initialize().then((_) {
            // Once the video has been loaded we play the video and set looping to true.
            _videoController.play();
            _videoController.setLooping(true);
            // Ensure the first frame is shown after the video is initialized.
            setState(() {});
          });
      case GoColorDifficulty.Seven:
        return VideoPlayerController.asset(
            "assets/video/games/background-7.mp4")
          ..initialize().then((_) {
            // Once the video has been loaded we play the video and set looping to true.
            _videoController.play();
            _videoController.setLooping(true);
            // Ensure the first frame is shown after the video is initialized.
            setState(() {});
          });
      case GoColorDifficulty.Eight:
        return VideoPlayerController.asset(
            "assets/video/games/background-8.mp4")
          ..initialize().then((_) {
            // Once the video has been loaded we play the video and set looping to true.
            _videoController.play();
            _videoController.setLooping(true);
            // Ensure the first frame is shown after the video is initialized.
            setState(() {});
          });
      case GoColorDifficulty.Nine:
        return VideoPlayerController.asset(
            "assets/video/games/background-9.mp4")
          ..initialize().then((_) {
            // Once the video has been loaded we play the video and set looping to true.
            _videoController.play();
            _videoController.setLooping(true);
            // Ensure the first frame is shown after the video is initialized.
            setState(() {});
          });
      case GoColorDifficulty.Ten:
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
              leading: Provider.of<GoColorProvider>(context).navigation
                  ? BackArrow(
                      onTap: () async =>
                          await _goToGoColorDetailsScreen(_spanish),
                      color: ConstValues.goColor)
                  : Container(),
              title: Text(
                "GoColor",
                style: GoogleFonts.poppins(
                    fontSize: 24,
                    color: ConstValues.goColor,
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
                        "assets/images/games/go_color/GoColor-icon.png",
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
      children: [
        Expanded(
            child: Container(
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    VideoPlayer(_videoController),
                    Positioned(
                      child: GameWidget(game: _goColor),
                    ),
                    Positioned(
                        child: Container(
                      child: _buildOpacity(),
                    )),
                    _goColor.getState == GameState.GameReady
                        ? Positioned(
                            child: Container(
                            padding: EdgeInsets.only(bottom: 40),
                            child: _buildLevelIndicator(),
                          ))
                        : Container(),
                    _goColor.getState == GameState.GameReady
                        ? Container()
                        : Provider.of<GoColorProvider>(context).navigation
                            ? _buildRestartButton()
                            : Container(),
                    _buildButtons()
                  ],
                )))
      ],
    ));
  }

  Widget _buildOpacity() {
    return _goColor.getState == GameState.GameReady
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
                    GoColorIcon(showStats: true, isInGame: true),
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
            margin: EdgeInsets.only(bottom: 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 150,
                  child: GoColorRestartButton(
                    text: _spanish ? "Juego Nuevo" : "New Game",
                    onPressed: () async => await _goColor.restart(),
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
                  child: GoColorRestartButton(
                    text: _spanish ? "Juego Nuevo" : "New Game",
                    onPressed: () async => await _goColor.restart(),
                  ),
                )
              ],
            )),
      ),
    );
  }

  Widget _buildButtons() {
    return Provider.of<GoColorProvider>(context).enabled
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
                        child: SecondaryGoColorButton(
                          text: "No",
                          onPressed:
                              Provider.of<GoColorProvider>(context).enabled
                                  ? () async => await _goColor.no()
                                  : null,
                        ),
                      ),
                      Container(
                        width: 16,
                        height: 0,
                      ),
                      Flexible(
                        child: PrimaryGoColorButton(
                          text: _spanish ? "Si" : "Yes",
                          onPressed:
                              Provider.of<GoColorProvider>(context).enabled
                                  ? () async => await _goColor.yes()
                                  : null,
                        ),
                      ),
                    ],
                  )),
            ),
          )
        : Container();
  }

  List<Widget> _getRaiseLevels() {
    switch (getGameDifficultyByColorDifficulty(_difficulty)) {
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
              child: _buildFocusMeter(4)),
        ];
      case GameDifficulty.hard:
        return [
          Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _buildResponseMeter(8)),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _buildFocusMeter(5)),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _buildLogicMeter(6)),
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
    return _goColor.getState == GameState.GameReady
        ? ResponseLevelUpMeter(raise: raise)
        : Container();
  }

  Widget _buildFocusMeter(int raise) {
    return _goColor.getState == GameState.GameReady
        ? FocusLevelUpMeter(raise: raise)
        : Container();
  }

  Widget _buildLogicMeter(int raise) {
    return _goColor.getState == GameState.GameReady
        ? LogicLevelUpMeter(raise: raise)
        : Container();
  }

  Widget _buildTBICard() {
    return _goColor.getState == GameState.GameReady
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
    _goColor.disposeGame();
    _goColor.pauseEngine();
    super.dispose();
  }
}
