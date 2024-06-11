import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'package:flutter/material.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/providers/providers.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/buttons/buttons.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/games/games_screen.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/titles/dashed_title.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/common/common_widgets.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/games/go_speed/go_speed_screen.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/dashboard_screen/dashboard_screen.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/containers/go_speed_info_container.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/games/go_speed/how_to_play_speed_screen.dart';

class GoSpeedDetailsScreen extends StatefulWidget {
  static const String goSpeedDetailsScreenKey = "/go_speed_details_screen";
  final bool showDashboard;
  final GoSpeedDifficulty difficulty;

  const GoSpeedDetailsScreen(
      {super.key,
      this.showDashboard = false,
      this.difficulty = GoSpeedDifficulty.Zero});

  @override
  State<GoSpeedDetailsScreen> createState() => GoSpeedDetailsScreenState(
      goSpeedDetailsScreenKey, showDashboard, difficulty);
}

class GoSpeedDetailsScreenState extends State<GoSpeedDetailsScreen>
    with TickerProviderStateMixin {
  late String _key;
  late bool _showDashboard;
  late GoSpeedDifficulty _difficulty;

  late User? _user;
  late SpeedManager? _speedManager;

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

  GoSpeedDetailsScreenState(String goSpeedDetailsScreenKey, bool showDashboard,
      GoSpeedDifficulty difficulty) {
    _key = goSpeedDetailsScreenKey;
    _showDashboard = showDashboard;
    _difficulty = difficulty;
    _widgetPointerValue = getLevelBySpeedDifficulty(_difficulty);
    _user = FirebaseAuth.instance.currentUser!;
    _speedManager = SpeedManager();
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

  Future<void> _goToGoSpeedScreen() async {
    await Navigator.of(context).pushReplacementNamed(
        GoSpeedScreen.goSpeedScreenKey,
        arguments: GoSpeedScreenArgs(
          showDashboard: _showDashboard,
          difficulty: _difficulty,
          highScore:
              Provider.of<GoSpeedProvider>(context, listen: false).userProgress,
          timesPlayed:
              Provider.of<GoSpeedProvider>(context, listen: false).userPlayTime,
        ));
  }

  Future<void> _goToHowToPlayScreen() async {
    await Navigator.of(context).pushReplacementNamed(
        HowToPlaySpeedScreen.howToPlaySpeedScreenKey,
        arguments: GoSpeedScreenArgs(
            difficulty: _difficulty, showDashboard: _showDashboard));
  }

  Future<void> _goToGamesScreen() async {
    await Navigator.of(context)
        .pushReplacementNamed(GamesScreen.gamesScreenKey);
  }

  Future<void> _goToDashboardScreen() async {
    await Navigator.of(context)
        .pushReplacementNamed(DashboardScreen.dashboardScreenKey);
  }

  Future<void> _setGameProgress() async {
    int? userLevel = await _speedManager!.getUserLevel(_user!.uid);
    print("userLevel $userLevel");
    if (userLevel != null) {
      Provider.of<GoSpeedProvider>(context, listen: false).setMyLevel =
          userLevel;
      _userLevel = userLevel;
    }
    int? userExp = await _speedManager!.getUserExp(_user!.uid);
    print("userExp $userExp");
    if (userExp != null) {
      Provider.of<GoSpeedProvider>(context, listen: false).setMyExp = userExp;
      _userExp = userExp;
    }
    int? userProgress = await _speedManager!.getHighScore(_user!.uid);
    print("progress $userProgress");
    if (userProgress != null) {
      Provider.of<GoSpeedProvider>(context, listen: false).setMyProgress =
          userProgress;
    }
    int? userPlayTime = await _speedManager!.getUserPlayTime(_user!.uid);
    print("progress $userPlayTime");
    if (userPlayTime != null) {
      Provider.of<GoSpeedProvider>(context, listen: false).setMyPlayTime =
          userPlayTime;
    }
  }

  Future<void> _setGameDifficulty(GoSpeedDifficulty difficulty) async {
    Provider.of<GoSpeedProvider>(context, listen: false).setMyDifficulty =
        difficulty;
    switch (difficulty) {
      case GoSpeedDifficulty.Zero:
        print("set zero");
        _difficulty = GoSpeedDifficulty.Zero;
        Provider.of<GoSpeedProvider>(context, listen: false).setMyTime = 30;
        Provider.of<GoSpeedProvider>(context, listen: false).setMyLives = 0;
        Provider.of<GoSpeedProvider>(context, listen: false).setMyMultiplier =
            0.5;
        break;
      case GoSpeedDifficulty.One:
        print("set one");
        _difficulty = GoSpeedDifficulty.One;
        Provider.of<GoSpeedProvider>(context, listen: false).setMyTime = 28;
        Provider.of<GoSpeedProvider>(context, listen: false).setMyLives = 0;
        Provider.of<GoSpeedProvider>(context, listen: false).setMyMultiplier =
            0.8;
        break;
      case GoSpeedDifficulty.Two:
        print("set two");
        _difficulty = GoSpeedDifficulty.Two;
        Provider.of<GoSpeedProvider>(context, listen: false).setMyTime = 25;
        Provider.of<GoSpeedProvider>(context, listen: false).setMyLives = 0;
        Provider.of<GoSpeedProvider>(context, listen: false).setMyMultiplier =
            1.0;
        break;
      case GoSpeedDifficulty.Three:
        print("set three");
        _difficulty = GoSpeedDifficulty.Three;
        Provider.of<GoSpeedProvider>(context, listen: false).setMyTime = 24;
        Provider.of<GoSpeedProvider>(context, listen: false).setMyLives = 5;
        Provider.of<GoSpeedProvider>(context, listen: false).setMyMultiplier =
            1.2;
        break;
      case GoSpeedDifficulty.Four:
        print("set four");
        _difficulty = GoSpeedDifficulty.Four;
        Provider.of<GoSpeedProvider>(context, listen: false).setMyTime = 23;
        Provider.of<GoSpeedProvider>(context, listen: false).setMyLives = 4;
        Provider.of<GoSpeedProvider>(context, listen: false).setMyMultiplier =
            1.3;
        break;
      case GoSpeedDifficulty.Five:
        print("set five");
        _difficulty = GoSpeedDifficulty.Five;
        Provider.of<GoSpeedProvider>(context, listen: false).setMyTime = 22;
        Provider.of<GoSpeedProvider>(context, listen: false).setMyLives = 3;
        Provider.of<GoSpeedProvider>(context, listen: false).setMyMultiplier =
            1.4;
        break;
      case GoSpeedDifficulty.Six:
        print("set six");
        _difficulty = GoSpeedDifficulty.Six;
        Provider.of<GoSpeedProvider>(context, listen: false).setMyTime = 21;
        Provider.of<GoSpeedProvider>(context, listen: false).setMyLives = 2;
        Provider.of<GoSpeedProvider>(context, listen: false).setMyMultiplier =
            1.5;
        break;
      case GoSpeedDifficulty.Seven:
        print("set seven");
        _difficulty = GoSpeedDifficulty.Seven;
        Provider.of<GoSpeedProvider>(context, listen: false).setMyTime = 20;
        Provider.of<GoSpeedProvider>(context, listen: false).setMyLives = 1;
        Provider.of<GoSpeedProvider>(context, listen: false).setMyMultiplier =
            1.6;
        break;
      case GoSpeedDifficulty.Eight:
        print("set eight");
        _difficulty = GoSpeedDifficulty.Eight;
        Provider.of<GoSpeedProvider>(context, listen: false).setMyTime = 18;
        Provider.of<GoSpeedProvider>(context, listen: false).setMyLives = 1;
        Provider.of<GoSpeedProvider>(context, listen: false).setMyMultiplier =
            1.7;
        break;
      case GoSpeedDifficulty.Nine:
        print("set nine");
        _difficulty = GoSpeedDifficulty.Nine;
        Provider.of<GoSpeedProvider>(context, listen: false).setMyTime = 16;
        Provider.of<GoSpeedProvider>(context, listen: false).setMyLives = 1;
        Provider.of<GoSpeedProvider>(context, listen: false).setMyMultiplier =
            1.8;
        break;
      case GoSpeedDifficulty.Ten:
        print("set ten");
        _difficulty = GoSpeedDifficulty.Ten;
        Provider.of<GoSpeedProvider>(context, listen: false).setMyTime = 15;
        Provider.of<GoSpeedProvider>(context, listen: false).setMyLives = 1;
        Provider.of<GoSpeedProvider>(context, listen: false).setMyMultiplier =
            2.0;
        break;
      default:
        print("set zero");
        _difficulty = GoSpeedDifficulty.Zero;
        Provider.of<GoSpeedProvider>(context, listen: false).setMyTime = 25;
        Provider.of<GoSpeedProvider>(context, listen: false).setMyLives = 0;
        Provider.of<GoSpeedProvider>(context, listen: false).setMyMultiplier =
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
              color: ConstValues.goSpeedColor,
            ),
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
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Image.asset(
                            "assets/images/games/go_speed/GoSpeed-icon.png",
                            width: 30,
                          )),
                      _userLevel == 100 && _userExp == 5000
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
                    padding: EdgeInsets.only(bottom: 32),
                    child: Image.asset(
                      "assets/images/logos/GoSpeed-logo.png",
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
                  "In this game the main goal is to decide if the current symbol match the previous symbol. Try to beat your own record.",
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
                              await _setGameDifficulty(GoSpeedDifficulty.Zero);
                            } else {
                              String roundValue =
                                  value.toStringAsExponential(0);
                              setState(() {
                                _widgetPointerValue = double.parse(roundValue);
                              });
                              if (_widgetPointerValue == 1.0) {
                                await _setGameDifficulty(GoSpeedDifficulty.One);
                              } else if (_widgetPointerValue == 2.0) {
                                await _setGameDifficulty(GoSpeedDifficulty.Two);
                              } else if (_widgetPointerValue == 3.0) {
                                await _setGameDifficulty(
                                    GoSpeedDifficulty.Three);
                              } else if (_widgetPointerValue == 4.0) {
                                await _setGameDifficulty(
                                    GoSpeedDifficulty.Four);
                              } else if (_widgetPointerValue == 5.0) {
                                await _setGameDifficulty(
                                    GoSpeedDifficulty.Five);
                              } else if (_widgetPointerValue == 6.0) {
                                await _setGameDifficulty(GoSpeedDifficulty.Six);
                              } else if (_widgetPointerValue == 7.0) {
                                await _setGameDifficulty(
                                    GoSpeedDifficulty.Seven);
                              } else if (_widgetPointerValue == 8.0) {
                                await _setGameDifficulty(
                                    GoSpeedDifficulty.Eight);
                              } else if (_widgetPointerValue == 9.0) {
                                await _setGameDifficulty(
                                    GoSpeedDifficulty.Nine);
                              } else if (_widgetPointerValue == 10.0) {
                                await _setGameDifficulty(GoSpeedDifficulty.Ten);
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
                child: GoSpeedStartButton(
                  text: "Start",
                  onPressed: () async => await _goToGoSpeedScreen(),
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
                  child: GoSpeedInfoContainer(
                    score: Provider.of<GoSpeedProvider>(context, listen: false)
                        .userProgress,
                    xp: Provider.of<GoSpeedProvider>(context, listen: false)
                        .userExp,
                    lives: Provider.of<GoSpeedProvider>(context, listen: false)
                                .lives ==
                            0
                        ? "Infinite"
                        : "${Provider.of<GoSpeedProvider>(context, listen: false).lives}",
                    time:
                        "${Provider.of<GoSpeedProvider>(context, listen: false).time}",
                    difficulty: _widgetPointerValue,
                    timesPlayed:
                        Provider.of<GoSpeedProvider>(context, listen: false)
                            .userPlayTime,
                    multiplier:
                        Provider.of<GoSpeedProvider>(context, listen: false)
                            .multiplier,
                  ))
            ]),
          ],
        ),
      )),
    );
  }

  List<Widget> _getRaiseLevels() {
    switch (getGameDifficultyBySpeedDifficulty(
        Provider.of<GoSpeedProvider>(context, listen: false).speedDifficulty)) {
      case GameDifficulty.easy:
        return [
          Container(child: speedToolTip(animation: _animation, raise: 3)),
        ];

      case GameDifficulty.medium:
        return [
          Container(child: speedToolTip(animation: _animation, raise: 5)),
          Container(
              padding: EdgeInsets.only(left: 16),
              child: memoryToolTip(animation: _animation, raise: 5)),
        ];
      case GameDifficulty.hard:
        return [
          Container(child: speedToolTip(animation: _animation, raise: 8)),
          Container(
              padding: EdgeInsets.only(left: 16),
              child: memoryToolTip(animation: _animation, raise: 6)),
          Container(
              padding: EdgeInsets.only(left: 16),
              child: responseToolTip(animation: _animation, raise: 5)),
        ];
      default:
        return [
          Container(child: speedToolTip(animation: _animation, raise: 3)),
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
