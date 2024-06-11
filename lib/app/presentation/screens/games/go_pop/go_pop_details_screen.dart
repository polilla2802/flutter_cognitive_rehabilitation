import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'package:flutter/material.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/providers/providers.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/buttons/buttons.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/games/games_screen.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/titles/dashed_title.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/common/common_widgets.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/games/go_pop/go_pop_screen.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/dashboard_screen/dashboard_screen.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/containers/go_pop_info_container.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/games/go_pop/how_to_play_pop_screen.dart';

class GoPopDetailsScreen extends StatefulWidget {
  static const String goPopDetailsScreenKey = "/go_pop_details_screen";
  final bool shine;
  final bool showDashboard;
  final GoPopDifficulty difficulty;

  const GoPopDetailsScreen(
      {super.key,
      this.shine = false,
      this.showDashboard = false,
      this.difficulty = GoPopDifficulty.Zero});

  @override
  State<GoPopDetailsScreen> createState() => GoPopDetailsScreenState(
      goPopDetailsScreenKey, shine, showDashboard, difficulty);
}

class GoPopDetailsScreenState extends State<GoPopDetailsScreen>
    with TickerProviderStateMixin {
  late String _key;
  late bool _shine;
  late bool _showDashboard;
  late GoPopDifficulty _difficulty;

  late User? _user;
  late PopManager? _popManager;

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

  GoPopDetailsScreenState(String goPopDetailsScreenKey, bool shine,
      bool showDashboard, GoPopDifficulty difficulty) {
    _key = goPopDetailsScreenKey;
    _difficulty = difficulty;
    _widgetPointerValue = getLevelByPopDifficulty(_difficulty);
    _shine = shine;
    _showDashboard = showDashboard;
    _user = FirebaseAuth.instance.currentUser!;
    _popManager = PopManager();
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

  Future<void> _goToGoPopScreen(bool shine) async {
    await Navigator.of(context).pushReplacementNamed(GoPopScreen.goPopScreenKey,
        arguments: GoPopScreenArgs(
            difficulty: _difficulty,
            highScore:
                Provider.of<GoPopProvider>(context, listen: false).userProgress,
            shine: shine,
            showDashboard: _showDashboard));
  }

  Future<void> _goToHowToPlayScreen() async {
    await Navigator.of(context).pushReplacementNamed(
        HowToPlayPopScreen.howToPlayPopScreenKey,
        arguments: GoPopScreenArgs(
            difficulty: _difficulty,
            shine: _shine,
            showDashboard: _showDashboard));
  }

  Future<void> _goToDashboardScreen() async {
    await Navigator.of(context)
        .pushReplacementNamed(DashboardScreen.dashboardScreenKey);
  }

  Future<void> _goToGamesScreen() async {
    await Navigator.of(context).pushReplacementNamed(
      GamesScreen.gamesScreenKey,
    );
  }

  Future<void> _setGameProgress() async {
    int? userLevel = await _popManager!.getUserLevel(_user!.uid);
    print("userLevel $userLevel");
    if (userLevel != null) {
      Provider.of<GoPopProvider>(context, listen: false).setMyLevel = userLevel;
      _userLevel = userLevel;
    }
    int? userExp = await _popManager!.getUserExp(_user!.uid);
    print("userExp $userExp");
    if (userExp != null) {
      Provider.of<GoPopProvider>(context, listen: false).setMyExp = userExp;
      _userExp = userExp;
    }
    int? userProgress = await _popManager!.getHighScore(_user!.uid);
    print("progress $userProgress");
    if (userProgress != null) {
      Provider.of<GoPopProvider>(context, listen: false).setMyProgress =
          userProgress;
    }
    int? userPlayTime = await _popManager!.getUserPlayTime(_user!.uid);
    print("progress $userPlayTime");
    if (userPlayTime != null) {
      Provider.of<GoPopProvider>(context, listen: false).setMyPlayTime =
          userPlayTime;
    }
  }

  Future<void> _setGameDifficulty(GoPopDifficulty difficulty) async {
    Provider.of<GoPopProvider>(context, listen: false).setMyDifficulty =
        difficulty;
    switch (difficulty) {
      case GoPopDifficulty.Zero:
        print("set zero");
        _difficulty = GoPopDifficulty.Zero;
        Provider.of<GoPopProvider>(context, listen: false).setMyTime = 30;
        Provider.of<GoPopProvider>(context, listen: false).setMyLives = 0;
        Provider.of<GoPopProvider>(context, listen: false).setMyMultiplier =
            0.5;
        break;
      case GoPopDifficulty.One:
        print("set one");
        _difficulty = GoPopDifficulty.One;
        Provider.of<GoPopProvider>(context, listen: false).setMyTime = 28;
        Provider.of<GoPopProvider>(context, listen: false).setMyLives = 0;
        Provider.of<GoPopProvider>(context, listen: false).setMyMultiplier =
            0.8;
        break;
      case GoPopDifficulty.Two:
        print("set two");
        _difficulty = GoPopDifficulty.Two;
        Provider.of<GoPopProvider>(context, listen: false).setMyTime = 25;
        Provider.of<GoPopProvider>(context, listen: false).setMyLives = 0;
        Provider.of<GoPopProvider>(context, listen: false).setMyMultiplier =
            1.0;
        break;
      case GoPopDifficulty.Three:
        print("set three");
        _difficulty = GoPopDifficulty.Three;
        Provider.of<GoPopProvider>(context, listen: false).setMyTime = 24;
        Provider.of<GoPopProvider>(context, listen: false).setMyLives = 5;
        Provider.of<GoPopProvider>(context, listen: false).setMyMultiplier =
            1.2;
        break;
      case GoPopDifficulty.Four:
        print("set four");
        _difficulty = GoPopDifficulty.Four;
        Provider.of<GoPopProvider>(context, listen: false).setMyTime = 23;
        Provider.of<GoPopProvider>(context, listen: false).setMyLives = 4;
        Provider.of<GoPopProvider>(context, listen: false).setMyMultiplier =
            1.3;
        break;
      case GoPopDifficulty.Five:
        print("set five");
        _difficulty = GoPopDifficulty.Five;
        Provider.of<GoPopProvider>(context, listen: false).setMyTime = 22;
        Provider.of<GoPopProvider>(context, listen: false).setMyLives = 3;
        Provider.of<GoPopProvider>(context, listen: false).setMyMultiplier =
            1.4;
        break;
      case GoPopDifficulty.Six:
        print("set six");
        _difficulty = GoPopDifficulty.Six;
        Provider.of<GoPopProvider>(context, listen: false).setMyTime = 21;
        Provider.of<GoPopProvider>(context, listen: false).setMyLives = 2;
        Provider.of<GoPopProvider>(context, listen: false).setMyMultiplier =
            1.5;
        break;
      case GoPopDifficulty.Seven:
        print("set seven");
        _difficulty = GoPopDifficulty.Seven;
        Provider.of<GoPopProvider>(context, listen: false).setMyTime = 20;
        Provider.of<GoPopProvider>(context, listen: false).setMyLives = 1;
        Provider.of<GoPopProvider>(context, listen: false).setMyMultiplier =
            1.6;
        break;
      case GoPopDifficulty.Eight:
        print("set eight");
        _difficulty = GoPopDifficulty.Eight;
        Provider.of<GoPopProvider>(context, listen: false).setMyTime = 18;
        Provider.of<GoPopProvider>(context, listen: false).setMyLives = 1;
        Provider.of<GoPopProvider>(context, listen: false).setMyMultiplier =
            1.7;
        break;
      case GoPopDifficulty.Nine:
        print("set nine");
        _difficulty = GoPopDifficulty.Nine;
        Provider.of<GoPopProvider>(context, listen: false).setMyTime = 16;
        Provider.of<GoPopProvider>(context, listen: false).setMyLives = 1;
        Provider.of<GoPopProvider>(context, listen: false).setMyMultiplier =
            1.8;
        break;
      case GoPopDifficulty.Ten:
        print("set ten");
        _difficulty = GoPopDifficulty.Ten;
        Provider.of<GoPopProvider>(context, listen: false).setMyTime = 15;
        Provider.of<GoPopProvider>(context, listen: false).setMyLives = 1;
        Provider.of<GoPopProvider>(context, listen: false).setMyMultiplier =
            2.0;
        break;
      default:
        print("set zero");
        _difficulty = GoPopDifficulty.Zero;
        Provider.of<GoPopProvider>(context, listen: false).setMyTime = 25;
        Provider.of<GoPopProvider>(context, listen: false).setMyLives = 0;
        Provider.of<GoPopProvider>(context, listen: false).setMyMultiplier =
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
              color: _shine ? ConstValues.goShineColor : ConstValues.goPopColor,
            ),
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
                  child: Stack(alignment: Alignment.center, children: [
                    Container(
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
                    _userLevel == 100 && _userExp == 10000
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
                  ]),
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
          child: Container(
        alignment: Alignment.center,
        color: ConstValues.whiteColor,
        padding: EdgeInsets.only(top: 0, right: 16, bottom: 16, left: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      "assets/images/logos/GoPop-logo.png",
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
                  "In this game the goal is to tap the green hexagon as fast as possible before time runs out!, each time you tap the hexagon, it changes position! So watch out! Try to beat your own record.",
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
                              await _setGameDifficulty(GoPopDifficulty.Zero);
                            } else {
                              String roundValue =
                                  value.toStringAsExponential(0);
                              setState(() {
                                _widgetPointerValue = double.parse(roundValue);
                              });
                              if (_widgetPointerValue == 1.0) {
                                await _setGameDifficulty(GoPopDifficulty.One);
                              } else if (_widgetPointerValue == 2.0) {
                                await _setGameDifficulty(GoPopDifficulty.Two);
                              } else if (_widgetPointerValue == 3.0) {
                                await _setGameDifficulty(GoPopDifficulty.Three);
                              } else if (_widgetPointerValue == 4.0) {
                                await _setGameDifficulty(GoPopDifficulty.Four);
                              } else if (_widgetPointerValue == 5.0) {
                                await _setGameDifficulty(GoPopDifficulty.Five);
                              } else if (_widgetPointerValue == 6.0) {
                                await _setGameDifficulty(GoPopDifficulty.Six);
                              } else if (_widgetPointerValue == 7.0) {
                                await _setGameDifficulty(GoPopDifficulty.Seven);
                              } else if (_widgetPointerValue == 8.0) {
                                await _setGameDifficulty(GoPopDifficulty.Eight);
                              } else if (_widgetPointerValue == 9.0) {
                                await _setGameDifficulty(GoPopDifficulty.Nine);
                              } else if (_widgetPointerValue == 10.0) {
                                await _setGameDifficulty(GoPopDifficulty.Ten);
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
                child: GoPopStartButton(
                  text: "Start",
                  shine: _shine,
                  onPressed: () async => await _goToGoPopScreen(_shine),
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
                  children: [
                    ..._getRaiseLevels(),
                  ],
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
                child: GoPopInfoContainer(
                  shine: _shine,
                  score: Provider.of<GoPopProvider>(context, listen: false)
                      .userProgress,
                  xp: Provider.of<GoPopProvider>(context, listen: false)
                      .userExp,
                  lives: Provider.of<GoPopProvider>(context, listen: false)
                              .lives ==
                          0
                      ? "Infinite"
                      : "${Provider.of<GoPopProvider>(context, listen: false).lives}",
                  time:
                      "${Provider.of<GoPopProvider>(context, listen: false).time}",
                  difficulty: _widgetPointerValue,
                  timesPlayed:
                      Provider.of<GoPopProvider>(context, listen: false)
                          .userPlayTime,
                  multiplier: Provider.of<GoPopProvider>(context, listen: false)
                      .multiplier,
                ),
              ),
            ]),
          ],
        ),
      )),
    );
  }

  List<Widget> _getRaiseLevels() {
    switch (getGameDifficultyByPopDifficulty(
        Provider.of<GoPopProvider>(context, listen: false).popDifficulty)) {
      case GameDifficulty.easy:
        return [
          Container(child: reflexToolTip(animation: _animation, raise: 2)),
        ];

      case GameDifficulty.medium:
        return [
          Container(child: reflexToolTip(animation: _animation, raise: 4)),
          Container(
              padding: EdgeInsets.only(left: 16),
              child: focusToolTip(animation: _animation, raise: 3)),
        ];
      case GameDifficulty.hard:
        return [
          Container(child: reflexToolTip(animation: _animation, raise: 8)),
          Container(
              padding: EdgeInsets.only(left: 16),
              child: focusToolTip(animation: _animation, raise: 5)),
          Container(
              padding: EdgeInsets.only(left: 16),
              child: speedToolTip(animation: _animation, raise: 6)),
        ];
      default:
        return [
          Container(child: focusToolTip(animation: _animation, raise: 5)),
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
