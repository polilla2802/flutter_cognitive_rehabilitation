import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'package:flutter/material.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/providers/providers.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/buttons/buttons.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/games/games_screen.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/titles/dashed_title.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/common/common_widgets.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/games/go_matrix/go_matrix_screen.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/dashboard_screen/dashboard_screen.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/containers/go_matrix_info_container.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/games/go_matrix/how_to_play_matrix_screen.dart';

class GoMatrixDetailsScreen extends StatefulWidget {
  static const String goMatrixDetailsScreenKey = "/go_matrix_details_screen";
  final bool showDashboard;
  final GoMatrixDifficulty difficulty;

  const GoMatrixDetailsScreen(
      {super.key,
      this.showDashboard = false,
      this.difficulty = GoMatrixDifficulty.Zero});

  @override
  State<GoMatrixDetailsScreen> createState() => GoMatrixDetailsScreenState(
      goMatrixDetailsScreenKey, showDashboard, difficulty);
}

class GoMatrixDetailsScreenState extends State<GoMatrixDetailsScreen>
    with TickerProviderStateMixin {
  late String _key;
  late bool _showDashboard;
  late GoMatrixDifficulty _difficulty;

  late User? _user;
  late MatrixManager? _matrixManager;

  double _opacity = 0;

  late AnimationController _controller;

  late double _widgetPointerValue;

  int _userLevel = 0;
  int _userExp = 0;

  bool loaded = false;

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastLinearToSlowEaseIn,
  );

  GoMatrixDetailsScreenState(String goMatrixDetailsScreenKey,
      bool showDashboard, GoMatrixDifficulty difficulty) {
    _key = goMatrixDetailsScreenKey;
    _showDashboard = showDashboard;
    _difficulty = difficulty;
    _widgetPointerValue = getLevelByMatrixDifficulty(_difficulty);
    _user = FirebaseAuth.instance.currentUser!;
    _matrixManager = MatrixManager();
  }

  @override
  void initState() {
    super.initState();
    print("$_key invoked");
    _controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    WidgetsBinding.instance
        .addPostFrameCallback((_) async => await _afterBuild());
  }

  Future<void> _afterBuild() async {
    _animate();
    await _setGameProgress();
    await _setGameDifficulty(_difficulty);
    setState(() {
      loaded = true;
    });
  }

  Future<void> _goToGoMatrixScreen() async {
    await Navigator.of(context)
        .pushReplacementNamed(GoMatrixScreen.goMatrixScreenKey,
            arguments: GoMatrixScreenArgs(
              showDashboard: _showDashboard,
              difficulty: _difficulty,
              highScore: Provider.of<GoMatrixProvider>(context, listen: false)
                  .userProgress,
            ));
  }

  Future<void> _goToHowToPlayScreen() async {
    await Navigator.of(context).pushReplacementNamed(
        HowToPlayMatrixScreen.howToPlayMatrixScreenKey,
        arguments: GoMatrixScreenArgs(
            difficulty: _difficulty, showDashboard: _showDashboard));
  }

  Future<void> _goToGamesScreen() async {
    await Navigator.of(context).pushReplacementNamed(
      GamesScreen.gamesScreenKey,
    );
  }

  Future<void> _goToDashboardScreen() async {
    await Navigator.of(context)
        .pushReplacementNamed(DashboardScreen.dashboardScreenKey);
  }

  Future<void> _setGameProgress() async {
    int? userLevel = await _matrixManager!.getUserLevel(_user!.uid);
    print("userLevel $userLevel");
    if (userLevel != null) {
      Provider.of<GoMatrixProvider>(context, listen: false).setMyLevel =
          userLevel;
      _userLevel = userLevel;
    }
    int? userExp = await _matrixManager!.getUserExp(_user!.uid);
    print("userExp $userExp");
    if (userExp != null) {
      Provider.of<GoMatrixProvider>(context, listen: false).setMyExp = userExp;
      _userExp = userExp;
    }
    int? userProgress = await _matrixManager!.getHighScore(_user!.uid);
    print("progress $userProgress");
    if (userProgress != null) {
      Provider.of<GoMatrixProvider>(context, listen: false).setMyProgress =
          userProgress;
    }
    int? userPlayTime = await _matrixManager!.getUserPlayTime(_user!.uid);
    print("progress $userPlayTime");
    if (userPlayTime != null) {
      Provider.of<GoMatrixProvider>(context, listen: false).setMyPlayTime =
          userPlayTime;
    }
  }

  Future<void> _setGameDifficulty(GoMatrixDifficulty difficulty) async {
    Provider.of<GoMatrixProvider>(context, listen: false).setMyDifficulty =
        difficulty;
    switch (difficulty) {
      case GoMatrixDifficulty.Zero:
        print("set zero");
        _difficulty = GoMatrixDifficulty.Zero;
        Provider.of<GoMatrixProvider>(context, listen: false).setMyTime = 30;
        Provider.of<GoMatrixProvider>(context, listen: false).setMyLives = 0;
        Provider.of<GoMatrixProvider>(context, listen: false).setMyTiles = 3;
        Provider.of<GoMatrixProvider>(context, listen: false).setMyMultiplier =
            0.5;
        break;
      case GoMatrixDifficulty.One:
        print("set one");
        _difficulty = GoMatrixDifficulty.One;
        Provider.of<GoMatrixProvider>(context, listen: false).setMyTime = 28;
        Provider.of<GoMatrixProvider>(context, listen: false).setMyLives = 0;
        Provider.of<GoMatrixProvider>(context, listen: false).setMyTiles = 4;
        Provider.of<GoMatrixProvider>(context, listen: false).setMyMultiplier =
            0.8;
        break;
      case GoMatrixDifficulty.Two:
        print("set two");
        _difficulty = GoMatrixDifficulty.Two;
        Provider.of<GoMatrixProvider>(context, listen: false).setMyTime = 25;
        Provider.of<GoMatrixProvider>(context, listen: false).setMyLives = 0;
        Provider.of<GoMatrixProvider>(context, listen: false).setMyTiles = 5;
        Provider.of<GoMatrixProvider>(context, listen: false).setMyMultiplier =
            1.0;
        break;
      case GoMatrixDifficulty.Three:
        print("set three");
        _difficulty = GoMatrixDifficulty.Three;
        Provider.of<GoMatrixProvider>(context, listen: false).setMyTime = 24;
        Provider.of<GoMatrixProvider>(context, listen: false).setMyLives = 5;
        Provider.of<GoMatrixProvider>(context, listen: false).setMyTiles = 5;
        Provider.of<GoMatrixProvider>(context, listen: false).setMyMultiplier =
            1.2;
        break;
      case GoMatrixDifficulty.Four:
        print("set four");
        _difficulty = GoMatrixDifficulty.Four;
        Provider.of<GoMatrixProvider>(context, listen: false).setMyTime = 23;
        Provider.of<GoMatrixProvider>(context, listen: false).setMyLives = 4;
        Provider.of<GoMatrixProvider>(context, listen: false).setMyTiles = 6;
        Provider.of<GoMatrixProvider>(context, listen: false).setMyMultiplier =
            1.3;
        break;
      case GoMatrixDifficulty.Five:
        print("set five");
        _difficulty = GoMatrixDifficulty.Five;
        Provider.of<GoMatrixProvider>(context, listen: false).setMyTime = 22;
        Provider.of<GoMatrixProvider>(context, listen: false).setMyLives = 3;
        Provider.of<GoMatrixProvider>(context, listen: false).setMyTiles = 7;
        Provider.of<GoMatrixProvider>(context, listen: false).setMyMultiplier =
            1.4;
        break;
      case GoMatrixDifficulty.Six:
        print("set six");
        _difficulty = GoMatrixDifficulty.Six;
        Provider.of<GoMatrixProvider>(context, listen: false).setMyTime = 21;
        Provider.of<GoMatrixProvider>(context, listen: false).setMyLives = 2;
        Provider.of<GoMatrixProvider>(context, listen: false).setMyTiles = 8;
        Provider.of<GoMatrixProvider>(context, listen: false).setMyMultiplier =
            1.5;
        break;
      case GoMatrixDifficulty.Seven:
        print("set seven");
        _difficulty = GoMatrixDifficulty.Seven;
        Provider.of<GoMatrixProvider>(context, listen: false).setMyTime = 20;
        Provider.of<GoMatrixProvider>(context, listen: false).setMyLives = 1;
        Provider.of<GoMatrixProvider>(context, listen: false).setMyTiles = 7;
        Provider.of<GoMatrixProvider>(context, listen: false).setMyMultiplier =
            1.6;
        break;
      case GoMatrixDifficulty.Eight:
        print("set eight");
        _difficulty = GoMatrixDifficulty.Eight;
        Provider.of<GoMatrixProvider>(context, listen: false).setMyTime = 18;
        Provider.of<GoMatrixProvider>(context, listen: false).setMyLives = 1;
        Provider.of<GoMatrixProvider>(context, listen: false).setMyTiles = 8;
        Provider.of<GoMatrixProvider>(context, listen: false).setMyMultiplier =
            1.7;
        break;
      case GoMatrixDifficulty.Nine:
        print("set nine");
        _difficulty = GoMatrixDifficulty.Nine;
        Provider.of<GoMatrixProvider>(context, listen: false).setMyTime = 16;
        Provider.of<GoMatrixProvider>(context, listen: false).setMyLives = 1;
        Provider.of<GoMatrixProvider>(context, listen: false).setMyTiles = 9;
        Provider.of<GoMatrixProvider>(context, listen: false).setMyMultiplier =
            1.8;
        break;
      case GoMatrixDifficulty.Ten:
        print("set ten");
        _difficulty = GoMatrixDifficulty.Ten;
        Provider.of<GoMatrixProvider>(context, listen: false).setMyTime = 15;
        Provider.of<GoMatrixProvider>(context, listen: false).setMyLives = 1;
        Provider.of<GoMatrixProvider>(context, listen: false).setMyTiles = 10;
        Provider.of<GoMatrixProvider>(context, listen: false).setMyMultiplier =
            2.0;
        break;
      default:
        print("set zero");
        _difficulty = GoMatrixDifficulty.Zero;
        Provider.of<GoMatrixProvider>(context, listen: false).setMyTime = 25;
        Provider.of<GoMatrixProvider>(context, listen: false).setMyLives = 0;
        Provider.of<GoMatrixProvider>(context, listen: false).setMyTiles = 5;
        Provider.of<GoMatrixProvider>(context, listen: false).setMyMultiplier =
            2.0;
        break;
    }
  }

  void _animate() {
    _controller.forward();
    setState(() {
      _opacity = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _showDashboard
            ? await _goToDashboardScreen()
            : await _goToGamesScreen();
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: ConstValues.blackColor,
            leading: BackArrow(
              onTap: () async => _showDashboard
                  ? await _goToDashboardScreen()
                  : await _goToGamesScreen(),
              color: ConstValues.goMatrixColor,
            ),
            title: Text(
              "GoMatrix",
              style: GoogleFonts.poppins(
                  fontSize: 24,
                  color: ConstValues.goMatrixColor,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.none),
            ),
            actions: [
              RotationTransition(
                turns: _animation,
                child: ScaleTransition(
                  scale: _animation,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Image.asset(
                          "assets/images/games/go_matrix/tile_maps/purple.png",
                          width: 30,
                        ),
                      ),
                      _userLevel == 100 && _userExp == 15000
                          ? Positioned(
                              top: 10,
                              right: 15,
                              child: AnimatedOpacity(
                                duration: Duration(milliseconds: 1000),
                                curve: Curves.fastLinearToSlowEaseIn,
                                opacity: _opacity,
                                child: Icon(
                                  Icons.auto_awesome,
                                  color: Colors.yellow,
                                  size: 15,
                                ),
                              ))
                          : Container()
                    ],
                  ),
                ),
              )
            ],
          ),
          body: _buildBody()),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
        child: Container(
      alignment: Alignment.center,
      color: ConstValues.whiteColor,
      padding: EdgeInsets.only(top: 0, right: 16, bottom: 16, left: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(children: [
            loaded
                ? Container(
                    padding: EdgeInsets.only(top: 8),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("LV: $_userLevel",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: ConstValues.blackColor))
                        ]),
                  )
                : Container(
                    padding: EdgeInsets.only(top: 8),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: ConstValues.blackColor))
                        ]),
                  ),
            Container(
              child: AnimatedOpacity(
                opacity: _opacity,
                duration: Duration(milliseconds: 2000),
                curve: Curves.fastLinearToSlowEaseIn,
                child: Container(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Image.asset(
                    "assets/images/logos/GoMatrix-logo.png",
                    width: 200,
                  ),
                ),
              ),
            ),
            AnimatedOpacity(
              opacity: _opacity,
              duration: Duration(milliseconds: 2000),
              curve: Curves.fastLinearToSlowEaseIn,
              child: Container(
                child: DashedTitle(
                  text: "Description",
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "In this game the goal is to remember the position of the purple tiles, try not to touch the tiles that were not marked at first, you have a chance of revealing the tiles once again with the 'HINT' button. Try to beat your own record.",
                textAlign: TextAlign.justify,
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
            AnimatedOpacity(
              opacity: _opacity,
              duration: Duration(milliseconds: 2000),
              curve: Curves.fastLinearToSlowEaseIn,
              child: Container(
                child: DashedTitle(
                  text: "Difficulty",
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 16),
              child: SfLinearGauge(
                  minimum: 0,
                  maximum: 10,
                  animateAxis: false,
                  animateRange: false,
                  minorTicksPerInterval: 0,
                  useRangeColorForAxis: true,
                  maximumLabels: 4,
                  tickPosition: LinearElementPosition.cross,
                  labelPosition: LinearLabelPosition.outside,
                  axisTrackStyle: LinearAxisTrackStyle(thickness: 10),
                  markerPointers: [
                    LinearShapePointer(
                        width: 20,
                        height: 20,
                        value: _widgetPointerValue,
                        shapeType: LinearShapePointerType.triangle,
                        position: LinearElementPosition.inside,
                        onChanged: (value) async {
                          if (value < 1) {
                            setState(() {
                              _widgetPointerValue = 0.0;
                            });
                            await _setGameDifficulty(GoMatrixDifficulty.Zero);
                          } else {
                            String roundValue = value.toStringAsExponential(0);
                            setState(() {
                              _widgetPointerValue = double.parse(roundValue);
                            });
                            if (_widgetPointerValue == 1.0) {
                              await _setGameDifficulty(GoMatrixDifficulty.One);
                            } else if (_widgetPointerValue == 2.0) {
                              await _setGameDifficulty(GoMatrixDifficulty.Two);
                            } else if (_widgetPointerValue == 3.0) {
                              await _setGameDifficulty(
                                  GoMatrixDifficulty.Three);
                            } else if (_widgetPointerValue == 4.0) {
                              await _setGameDifficulty(GoMatrixDifficulty.Four);
                            } else if (_widgetPointerValue == 5.0) {
                              await _setGameDifficulty(GoMatrixDifficulty.Five);
                            } else if (_widgetPointerValue == 6.0) {
                              await _setGameDifficulty(GoMatrixDifficulty.Six);
                            } else if (_widgetPointerValue == 7.0) {
                              await _setGameDifficulty(
                                  GoMatrixDifficulty.Seven);
                            } else if (_widgetPointerValue == 8.0) {
                              await _setGameDifficulty(
                                  GoMatrixDifficulty.Eight);
                            } else if (_widgetPointerValue == 9.0) {
                              await _setGameDifficulty(GoMatrixDifficulty.Nine);
                            } else if (_widgetPointerValue == 10.0) {
                              await _setGameDifficulty(GoMatrixDifficulty.Ten);
                            }
                          }
                        },
                        color: _widgetPointerValue < 3
                            ? ConstValues.myGreenColor
                            : _widgetPointerValue < 7
                                ? ConstValues.myOrangeColor
                                : Colors.red),
                  ],
                  ranges: [
                    LinearGaugeRange(
                        rangeShapeType: LinearRangeShapeType.curve,
                        edgeStyle: LinearEdgeStyle.bothCurve,
                        endValue: _widgetPointerValue,
                        color: _widgetPointerValue < 3
                            ? ConstValues.myGreenColor
                            : _widgetPointerValue < 7
                                ? ConstValues.myOrangeColor
                                : Colors.red,
                        position: LinearElementPosition.cross)
                  ]),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 8),
              child: GoMatrixStartButton(
                text: "Start",
                onPressed: () async => await _goToGoMatrixScreen(),
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 16),
              child: HowToPlayButton(
                onPressed: () async => await _goToHowToPlayScreen(),
              ),
            ),
            AnimatedOpacity(
              opacity: _opacity,
              duration: Duration(milliseconds: 2000),
              curve: Curves.fastLinearToSlowEaseIn,
              child: Container(
                child: DashedTitle(
                  text: "Improves",
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [..._getRaiseLevels()],
              ),
            ),
            AnimatedOpacity(
              opacity: _opacity,
              duration: Duration(milliseconds: 2000),
              curve: Curves.fastLinearToSlowEaseIn,
              child: Container(
                padding: EdgeInsets.only(bottom: 8),
                child: DashedTitle(
                  text: "Game Details",
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 32),
              child: GoMatrixInfoContainer(
                score: Provider.of<GoMatrixProvider>(context, listen: false)
                    .userProgress,
                xp: Provider.of<GoMatrixProvider>(context, listen: false)
                    .userExp,
                timesPlayed:
                    Provider.of<GoMatrixProvider>(context, listen: false)
                        .userPlayTime,
                lives: Provider.of<GoMatrixProvider>(context, listen: false)
                            .lives ==
                        0
                    ? "Infinite"
                    : "${Provider.of<GoMatrixProvider>(context, listen: false).lives}",
                time:
                    "${Provider.of<GoMatrixProvider>(context, listen: false).time}",
                tiles:
                    Provider.of<GoMatrixProvider>(context, listen: false).tiles,
                difficulty: _widgetPointerValue,
                multiplier:
                    Provider.of<GoMatrixProvider>(context, listen: false)
                        .multiplier,
              ),
            ),
          ]),
        ],
      ),
    ));
  }

  List<Widget> _getRaiseLevels() {
    switch (getGameDifficultyByMatrixDifficulty(
        Provider.of<GoMatrixProvider>(context, listen: false)
            .matrixDifficulty)) {
      case GameDifficulty.easy:
        return [
          Container(child: memoryToolTip(animation: _animation, raise: 4)),
        ];

      case GameDifficulty.medium:
        return [
          Container(child: memoryToolTip(animation: _animation, raise: 5)),
          Container(
              padding: EdgeInsets.only(left: 16),
              child: focusToolTip(animation: _animation, raise: 3)),
        ];
      case GameDifficulty.hard:
        return [
          Container(child: memoryToolTip(animation: _animation, raise: 8)),
          Container(
              padding: EdgeInsets.only(left: 16),
              child: focusToolTip(animation: _animation, raise: 4)),
          Container(
              padding: EdgeInsets.only(left: 16),
              child: logicToolTip(animation: _animation, raise: 7)),
        ];
      default:
        return [
          Container(child: memoryToolTip(animation: _animation, raise: 8)),
        ];
    }
  }

  @override
  void dispose() async {
    print('$_key Dispose invoked');
    _controller.dispose();
    super.dispose();
  }
}
