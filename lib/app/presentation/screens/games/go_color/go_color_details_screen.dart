import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'package:flutter/material.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/providers/providers.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/buttons/buttons.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/games/games_screen.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/titles/dashed_title.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/common/common_widgets.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/games/go_color/go_color_screen.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/dashboard_screen/dashboard_screen.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/containers/go_color_info_container.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/games/go_color/how_to_play_color_screen.dart';

class GoColorDetailsScreen extends StatefulWidget {
  static const String goColorDetailsScreenKey = "/go_color_details_screen";
  final bool spanish;
  final bool showDashboard;
  final GoColorDifficulty difficulty;

  const GoColorDetailsScreen(
      {super.key,
      this.spanish = false,
      this.showDashboard = false,
      this.difficulty = GoColorDifficulty.Zero});

  @override
  State<GoColorDetailsScreen> createState() => GoColorDetailsScreenState(
      goColorDetailsScreenKey, spanish, showDashboard, difficulty);
}

class GoColorDetailsScreenState extends State<GoColorDetailsScreen>
    with TickerProviderStateMixin {
  late String _key;
  late bool _spanish;
  late bool _showDashboard;
  late GoColorDifficulty _difficulty;

  late User? _user;
  late ColorManager? _colorManager;

  late AnimationController _controller;

  late double _widgetPointerValue;

  late int _userLevel;
  late int _userExp;

  double _opacity = 0;
  bool _loaded = false;

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastLinearToSlowEaseIn,
  );

  GoColorDetailsScreenState(
    String goColorDetailsScreenKey,
    bool spanish,
    bool showDashboard,
    GoColorDifficulty difficulty,
  ) {
    _key = goColorDetailsScreenKey;
    _spanish = spanish;
    _showDashboard = showDashboard;
    _difficulty = difficulty;
    _userLevel = 0;
    _userExp = 0;
    _widgetPointerValue = getLevelByColorDifficulty(_difficulty);
    _user = FirebaseAuth.instance.currentUser!;
    _colorManager = ColorManager();
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
      _loaded = true;
    });
  }

  Future<void> _goToGoColorScreen(bool spanish) async {
    await Navigator.of(context).pushReplacementNamed(
        GoColorScreen.goColorScreenKey,
        arguments: GoColorScreenArgs(
            difficulty: _difficulty,
            highScore: Provider.of<GoColorProvider>(context, listen: false)
                .userProgress,
            spanish: _spanish,
            showDashboard: _showDashboard));
  }

  Future<void> _goToHowToPlayScreen(bool spanish) async {
    await Navigator.of(context).pushReplacementNamed(
        HowToPlayColorScreen.howToPlayColorScreenKey,
        arguments: GoColorScreenArgs(
            difficulty: _difficulty,
            spanish: spanish,
            showDashboard: _showDashboard));
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
    int? userLevel = await _colorManager!.getUserLevel(_user!.uid);
    print("userLevel $userLevel");
    if (userLevel != null) {
      Provider.of<GoColorProvider>(context, listen: false).setMyLevel =
          userLevel;
      _userLevel = userLevel;
    }
    int? userExp = await _colorManager!.getUserExp(_user!.uid);
    print("userExp $userExp");
    if (userExp != null) {
      Provider.of<GoColorProvider>(context, listen: false).setMyExp = userExp;
      _userExp = userExp;
    }
    int? userProgress = await _colorManager!.getHighScore(_user!.uid);
    print("progress $userProgress");
    if (userProgress != null) {
      Provider.of<GoColorProvider>(context, listen: false).setMyProgress =
          userProgress;
    }
    int? userPlayTime = await _colorManager!.getUserPlayTime(_user!.uid);
    print("progress $userPlayTime");
    if (userPlayTime != null) {
      Provider.of<GoColorProvider>(context, listen: false).setMyPlayTime =
          userPlayTime;
    }
  }

  Future<void> _setGameDifficulty(GoColorDifficulty difficulty) async {
    Provider.of<GoColorProvider>(context, listen: false).setMyDifficulty =
        difficulty;
    switch (difficulty) {
      case GoColorDifficulty.Zero:
        print("set zero");
        _difficulty = GoColorDifficulty.Zero;
        Provider.of<GoColorProvider>(context, listen: false).setMyTime = 30;
        Provider.of<GoColorProvider>(context, listen: false).setMyLives = 0;
        Provider.of<GoColorProvider>(context, listen: false).setMyMultiplier =
            0.5;
        break;
      case GoColorDifficulty.One:
        print("set one");
        _difficulty = GoColorDifficulty.One;
        Provider.of<GoColorProvider>(context, listen: false).setMyTime = 28;
        Provider.of<GoColorProvider>(context, listen: false).setMyLives = 0;
        Provider.of<GoColorProvider>(context, listen: false).setMyMultiplier =
            0.80;
        break;
      case GoColorDifficulty.Two:
        print("set two");
        _difficulty = GoColorDifficulty.Two;
        Provider.of<GoColorProvider>(context, listen: false).setMyTime = 25;
        Provider.of<GoColorProvider>(context, listen: false).setMyLives = 0;
        Provider.of<GoColorProvider>(context, listen: false).setMyMultiplier =
            1.0;
        break;
      case GoColorDifficulty.Three:
        print("set three");
        _difficulty = GoColorDifficulty.Three;
        Provider.of<GoColorProvider>(context, listen: false).setMyTime = 24;
        Provider.of<GoColorProvider>(context, listen: false).setMyLives = 5;
        Provider.of<GoColorProvider>(context, listen: false).setMyMultiplier =
            1.2;
        break;
      case GoColorDifficulty.Four:
        print("set four");
        _difficulty = GoColorDifficulty.Four;
        Provider.of<GoColorProvider>(context, listen: false).setMyTime = 23;
        Provider.of<GoColorProvider>(context, listen: false).setMyLives = 4;
        Provider.of<GoColorProvider>(context, listen: false).setMyMultiplier =
            1.3;
        break;
      case GoColorDifficulty.Five:
        print("set five");
        _difficulty = GoColorDifficulty.Five;
        Provider.of<GoColorProvider>(context, listen: false).setMyTime = 22;
        Provider.of<GoColorProvider>(context, listen: false).setMyLives = 3;
        Provider.of<GoColorProvider>(context, listen: false).setMyMultiplier =
            1.4;
        break;
      case GoColorDifficulty.Six:
        print("set six");
        _difficulty = GoColorDifficulty.Six;
        Provider.of<GoColorProvider>(context, listen: false).setMyTime = 21;
        Provider.of<GoColorProvider>(context, listen: false).setMyLives = 2;
        Provider.of<GoColorProvider>(context, listen: false).setMyMultiplier =
            1.5;
        break;
      case GoColorDifficulty.Seven:
        print("set seven");
        _difficulty = GoColorDifficulty.Seven;
        Provider.of<GoColorProvider>(context, listen: false).setMyTime = 20;
        Provider.of<GoColorProvider>(context, listen: false).setMyLives = 1;
        Provider.of<GoColorProvider>(context, listen: false).setMyMultiplier =
            1.6;
        break;
      case GoColorDifficulty.Eight:
        print("set eight");
        _difficulty = GoColorDifficulty.Eight;
        Provider.of<GoColorProvider>(context, listen: false).setMyTime = 18;
        Provider.of<GoColorProvider>(context, listen: false).setMyLives = 1;
        Provider.of<GoColorProvider>(context, listen: false).setMyMultiplier =
            1.7;
        break;
      case GoColorDifficulty.Nine:
        print("set nine");
        _difficulty = GoColorDifficulty.Nine;
        Provider.of<GoColorProvider>(context, listen: false).setMyTime = 16;
        Provider.of<GoColorProvider>(context, listen: false).setMyLives = 1;
        Provider.of<GoColorProvider>(context, listen: false).setMyMultiplier =
            1.8;
        break;
      case GoColorDifficulty.Ten:
        print("set ten");
        _difficulty = GoColorDifficulty.Ten;
        Provider.of<GoColorProvider>(context, listen: false).setMyTime = 15;
        Provider.of<GoColorProvider>(context, listen: false).setMyLives = 1;
        Provider.of<GoColorProvider>(context, listen: false).setMyMultiplier =
            2.0;
        break;
      default:
        print("set zero");
        _difficulty = GoColorDifficulty.Zero;
        Provider.of<GoColorProvider>(context, listen: false).setMyTime = 25;
        Provider.of<GoColorProvider>(context, listen: false).setMyLives = 0;
        Provider.of<GoColorProvider>(context, listen: false).setMyMultiplier =
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
              color: ConstValues.goColor,
            ),
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
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Image.asset(
                            "assets/images/games/go_color/GoColor-icon.png",
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
      alignment: Alignment.center,
      color: ConstValues.whiteColor,
      padding: EdgeInsets.only(top: 0, right: 16, bottom: 16, left: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(children: [
            _loaded
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
                    "assets/images/logos/GoColor-logo.png",
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
                "In this game the goal is to decide if the meaning of the top word matches the text color of the bottom word. Try to beat your own record.",
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
                            await _setGameDifficulty(GoColorDifficulty.Zero);
                          } else {
                            String roundValue = value.toStringAsExponential(0);
                            setState(() {
                              _widgetPointerValue = double.parse(roundValue);
                            });
                            if (_widgetPointerValue == 1.0) {
                              await _setGameDifficulty(GoColorDifficulty.One);
                            } else if (_widgetPointerValue == 2.0) {
                              await _setGameDifficulty(GoColorDifficulty.Two);
                            } else if (_widgetPointerValue == 3.0) {
                              await _setGameDifficulty(GoColorDifficulty.Three);
                            } else if (_widgetPointerValue == 4.0) {
                              await _setGameDifficulty(GoColorDifficulty.Four);
                            } else if (_widgetPointerValue == 5.0) {
                              await _setGameDifficulty(GoColorDifficulty.Five);
                            } else if (_widgetPointerValue == 6.0) {
                              await _setGameDifficulty(GoColorDifficulty.Six);
                            } else if (_widgetPointerValue == 7.0) {
                              await _setGameDifficulty(GoColorDifficulty.Seven);
                            } else if (_widgetPointerValue == 8.0) {
                              await _setGameDifficulty(GoColorDifficulty.Eight);
                            } else if (_widgetPointerValue == 9.0) {
                              await _setGameDifficulty(GoColorDifficulty.Nine);
                            } else if (_widgetPointerValue == 10.0) {
                              await _setGameDifficulty(GoColorDifficulty.Ten);
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
              child: GoColorStartButton(
                text: _spanish ? "Empieza" : "Start",
                onPressed: () async => await _goToGoColorScreen(_spanish),
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 16),
              child: HowToPlayButton(
                spanish: _spanish,
                onPressed: () async => await _goToHowToPlayScreen(_spanish),
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
                child: GoColorInfoContainer(
                  score: Provider.of<GoColorProvider>(context, listen: false)
                      .userProgress,
                  xp: Provider.of<GoColorProvider>(context, listen: false)
                      .userExp,
                  lives: Provider.of<GoColorProvider>(context, listen: false)
                              .lives ==
                          0
                      ? "Infinite"
                      : "${Provider.of<GoColorProvider>(context, listen: false).lives}",
                  time:
                      "${Provider.of<GoColorProvider>(context, listen: false).time}",
                  difficulty: _widgetPointerValue,
                  timesPlayed:
                      Provider.of<GoColorProvider>(context, listen: false)
                          .userPlayTime,
                  multiplier:
                      Provider.of<GoColorProvider>(context, listen: false)
                          .multiplier,
                ))
          ]),
        ],
      ),
    ));
  }

  List<Widget> _getRaiseLevels() {
    switch (getGameDifficultyByColorDifficulty(
        Provider.of<GoColorProvider>(context, listen: false).colorDifficulty)) {
      case GameDifficulty.easy:
        return [
          Container(child: responseToolTip(animation: _animation, raise: 3)),
        ];

      case GameDifficulty.medium:
        return [
          Container(child: responseToolTip(animation: _animation, raise: 5)),
          Container(
              padding: EdgeInsets.only(left: 16),
              child: focusToolTip(animation: _animation, raise: 4)),
        ];
      case GameDifficulty.hard:
        return [
          Container(child: responseToolTip(animation: _animation, raise: 8)),
          Container(
              padding: EdgeInsets.only(left: 16),
              child: focusToolTip(animation: _animation, raise: 5)),
          Container(
              padding: EdgeInsets.only(left: 16),
              child: logicToolTip(animation: _animation, raise: 6)),
        ];
      default:
        return [
          Container(child: responseToolTip(animation: _animation, raise: 3)),
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
