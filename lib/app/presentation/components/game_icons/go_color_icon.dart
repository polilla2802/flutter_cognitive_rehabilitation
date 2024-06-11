import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';

import 'package:flutter/material.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/providers/providers.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/common/common_widgets.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/games/go_color/go_color_screen.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/games/go_color/go_color_details_screen.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/games/go_color/how_to_play_color_screen.dart';

class GoColorIcon extends StatefulWidget {
  static const String goColorIconKey = "go_color_icon";
  final bool showStats;
  final bool isInGame;
  final bool showDashboard;

  const GoColorIcon(
      {super.key,
      this.showStats = false,
      this.isInGame = false,
      this.showDashboard = false});

  @override
  State<GoColorIcon> createState() =>
      _GoColorIconState(goColorIconKey, showStats, isInGame, showDashboard);
}

class _GoColorIconState extends State<GoColorIcon>
    with TickerProviderStateMixin {
  late String _key;
  late bool _showStats;
  late bool _isInGame;
  late bool _showDashboard;

  late User? _user;
  late ColorManager? _colorManager;
  late int? _userProgress;
  late int? _userLevel;
  late int? _userExp;
  late int? _userPlayTime;
  late bool? _gameUnlocked;
  late bool _isLoading;

  Color _color = Color.fromRGBO(0, 0, 0, 0.55);
  EdgeInsets _padding = EdgeInsets.symmetric(vertical: 0);
  double _opacity = 0;

  _GoColorIconState(String goColorIconKey, bool showStats, bool isInGame,
      bool showDashboard) {
    _key = goColorIconKey;
    _showStats = showStats;
    _colorManager = ColorManager();
    _isInGame = isInGame;
    _showDashboard = showDashboard;
    _user = FirebaseAuth.instance.currentUser!;
    _userProgress = null;
    _userLevel = null;
    _userExp = 0;
    _userPlayTime = null;
    _gameUnlocked = null;
    _isLoading = true;
  }

  @override
  void initState() {
    super.initState();
    print('$_key invoked');
    WidgetsBinding.instance
        .addPostFrameCallback((_) async => await _afterBuild());
  }

  Future<void> _afterBuild() async {
    await _fetchUnlocked();
    await _fetchProgress();
    await _fetchPlayTime();
    await _fetchLevel();
    _animate();
  }

  Future<void> _fetchUnlocked() async {
    print("fetchUnlocked [USER ID]: ${_user!.uid}");
    _gameUnlocked = await _colorManager!.getUnlockStatus(_user!.uid);
    print("GoColorIcon unlocked $_gameUnlocked");
    if (_gameUnlocked != null) {
      Provider.of<GoColorProvider>(context, listen: false).setMyUnlock =
          _gameUnlocked!;
    }
  }

  Future<void> _fetchProgress() async {
    if (Provider.of<GoColorProvider>(context, listen: false).gameUnlocked) {
      print("fetchProgress [USER ID]: ${_user!.uid}");
      _userProgress = await _colorManager!.getHighScore(_user!.uid);
      print("GoColorIcon progress $_userProgress");
      if (_userProgress != null) {
        Provider.of<GoColorProvider>(context, listen: false).setMyProgress =
            _userProgress!;
      }
    } else {
      Provider.of<GoColorProvider>(context, listen: false).setMyProgress = 0;
    }
  }

  Future<void> _fetchPlayTime() async {
    if (Provider.of<GoColorProvider>(context, listen: false).gameUnlocked) {
      print("fetchPlayTime [USER ID]: ${_user!.uid}");
      _userPlayTime = await _colorManager!.getUserPlayTime(_user!.uid);
      print("GoColorIcon userPlayTime $_userPlayTime");
      if (_userPlayTime != null) {
        Provider.of<GoColorProvider>(context, listen: false).setMyPlayTime =
            _userPlayTime!;
      }
    } else {
      Provider.of<GoColorProvider>(context, listen: false).setMyPlayTime = 0;
    }
  }

  Future<void> _fetchLevel() async {
    if (Provider.of<GoColorProvider>(context, listen: false).gameUnlocked) {
      print("fetchLevel [USER ID]: ${_user!.uid}");
      _userLevel = await _colorManager!.getUserLevel(_user!.uid);
      _userExp = await _colorManager!.getUserExp(_user!.uid);
      print("GoColorIcon level $_userLevel");
      print("GoColorIcon exp $_userExp");
      if (_userLevel != null) {
        Provider.of<GoColorProvider>(context, listen: false).setMyLevel =
            _userLevel!;
      }
      if (_userExp != null) {
        Provider.of<GoColorProvider>(context, listen: false).setMyExp =
            _userExp!;
      }
    } else {
      Provider.of<GoColorProvider>(context, listen: false).setMyLevel = 0;
      Provider.of<GoColorProvider>(context, listen: false).setMyExp = 0;
    }
  }

  Future<void> _goToGoColorDetailsScreen(bool spanish) async {
    await Navigator.of(context).pushReplacementNamed(
        GoColorDetailsScreen.goColorDetailsScreenKey,
        arguments: GoColorScreenArgs(
            spanish: spanish,
            showDashboard: _showDashboard,
            difficulty: Provider.of<GoColorProvider>(context, listen: false)
                .colorDifficulty));
  }

  Future<void> _goToHowToPlayScreen(bool spanish) async {
    await Navigator.of(context).pushReplacementNamed(
        HowToPlayColorScreen.howToPlayColorScreenKey,
        arguments: GoColorScreenArgs(
            spanish: spanish,
            showDashboard: _showDashboard,
            difficulty: Provider.of<GoColorProvider>(context, listen: false)
                .colorDifficulty));
  }

  void _animate() {
    setState(() {
      _isLoading = false;
      _color = _isInGame
          ? Color.fromRGBO(0, 0, 0, 0.55)
          : Color.fromRGBO(0, 0, 0, 0.8);
      _padding = EdgeInsets.symmetric(vertical: 8);
      _opacity = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildIcon(context);
  }

  Widget _buildIcon(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: _showStats
            ? null
            : _isLoading
                ? null
                : Provider.of<GoColorProvider>(context).gameUnlocked
                    ? _userPlayTime == 0
                        ? () async => await _goToHowToPlayScreen(false)
                        : () async => await _goToGoColorDetailsScreen(false)
                    : null,
        onLongPress: _showStats
            ? null
            : _isLoading
                ? null
                : Provider.of<GoColorProvider>(context).gameUnlocked
                    ? _userPlayTime == 0
                        ? () async => await _goToHowToPlayScreen(true)
                        : () async => await _goToGoColorDetailsScreen(true)
                    : null,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "LV:",
                  style: GoogleFonts.poppins(
                      color: _isInGame ? ConstValues.whiteColor : Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
                Container(
                    child: AnimatedFlipCounter(
                  textStyle: GoogleFonts.poppins(
                      color: _isInGame ? ConstValues.whiteColor : Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                  curve: Curves.bounceOut,
                  duration: Duration(milliseconds: 1500),
                  value: Provider.of<GoColorProvider>(context).userLevel,
                )),
              ],
            ),
            Container(
              child: Text(
                "GoColor",
                style: GoogleFonts.poppins(
                    color: _isInGame ? ConstValues.whiteColor : Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
            ),
            _showStats
                ? Tooltip(
                    textStyle: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 12),
                    verticalOffset: -103,
                    showDuration: Duration(seconds: 2),
                    decoration: BoxDecoration(
                        color: ConstValues.goColor,
                        borderRadius: BorderRadius.all(Radius.circular(100))),
                    triggerMode: TooltipTriggerMode.tap,
                    message:
                        "HI: ${Provider.of<GoColorProvider>(context).userProgress}",
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                            child: AnimatedContainer(
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Provider.of<GoColorProvider>(context)
                                    .gameUnlocked
                                ? _color
                                : _isInGame
                                    ? Colors.transparent
                                    : Color.fromRGBO(0, 0, 0, 0.55),
                          ),
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          duration: Duration(milliseconds: 1000),
                          curve: Curves.fastLinearToSlowEaseIn,
                          padding: _padding,
                          child: Container(
                            child: SfRadialGauge(axes: [
                              RadialAxis(
                                minimum: 0,
                                maximum: 10000,
                                showLabels: false,
                                showTicks: true,
                                startAngle: 270,
                                endAngle: 270,
                                tickOffset: 65,
                                minorTicksPerInterval: 4,
                                minorTickStyle: MinorTickStyle(
                                    thickness: 2, color: Colors.black54),
                                majorTickStyle: MajorTickStyle(
                                    thickness: 2, color: Colors.black54),
                                pointers: [
                                  RangePointer(
                                      value:
                                          Provider.of<GoColorProvider>(context)
                                                  .gameUnlocked
                                              ? _userExp!.toDouble() * 2
                                              : 0,
                                      cornerStyle: CornerStyle.bothCurve,
                                      width: 0.2,
                                      sizeUnit: GaugeSizeUnit.factor,
                                      enableAnimation: true,
                                      color: ConstValues.goColor)
                                ],
                                axisLineStyle: AxisLineStyle(
                                  thickness: 0.2,
                                  cornerStyle: CornerStyle.bothCurve,
                                  color: Colors.white54,
                                  thicknessUnit: GaugeSizeUnit.factor,
                                ),
                              )
                            ]),
                          ),
                        )),
                        Positioned(
                            child: Provider.of<GoColorProvider>(context)
                                    .gameUnlocked
                                ? Image.asset(
                                    "assets/images/games/go_color/GoColor-icon.png",
                                    width: 45,
                                  )
                                : Icon(Icons.lock,
                                    size: 50, color: ConstValues.goColor)),
                        _userLevel == 100 && _userExp == 5000
                            ? Positioned(
                                child: Container(
                                padding: EdgeInsets.only(bottom: 30, left: 25),
                                child: AnimatedOpacity(
                                  duration: Duration(milliseconds: 1000),
                                  curve: Curves.fastLinearToSlowEaseIn,
                                  opacity: _opacity,
                                  child: Icon(
                                    Icons.auto_awesome,
                                    color: Colors.yellow,
                                    size: 25,
                                  ),
                                ),
                              ))
                            : Container()
                      ],
                    ),
                  )
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                          child: AnimatedContainer(
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color:
                              Provider.of<GoColorProvider>(context).gameUnlocked
                                  ? _color
                                  : Color.fromRGBO(0, 0, 0, 0.55),
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        duration: Duration(milliseconds: 1000),
                        curve: Curves.fastLinearToSlowEaseIn,
                        padding: _padding,
                        child: Container(
                          child: SfRadialGauge(axes: [
                            RadialAxis(
                              minimum: 0,
                              maximum: 10000,
                              showLabels: false,
                              showTicks: true,
                              startAngle: 270,
                              endAngle: 270,
                              tickOffset: 65,
                              minorTicksPerInterval: 4,
                              minorTickStyle: MinorTickStyle(
                                  thickness: 2, color: Colors.black54),
                              majorTickStyle: MajorTickStyle(
                                  thickness: 2, color: Colors.black54),
                              pointers: [
                                RangePointer(
                                    value: Provider.of<GoColorProvider>(context)
                                            .gameUnlocked
                                        ? _userExp!.toDouble() * 2
                                        : 0,
                                    cornerStyle: CornerStyle.bothCurve,
                                    width: 0.2,
                                    sizeUnit: GaugeSizeUnit.factor,
                                    enableAnimation: true,
                                    color: ConstValues.goColor)
                              ],
                              axisLineStyle: AxisLineStyle(
                                thickness: 0.2,
                                cornerStyle: CornerStyle.bothCurve,
                                color: Colors.white54,
                                thicknessUnit: GaugeSizeUnit.factor,
                              ),
                            )
                          ]),
                        ),
                      )),
                      Positioned(
                          child:
                              Provider.of<GoColorProvider>(context).gameUnlocked
                                  ? Image.asset(
                                      "assets/images/games/go_color/GoColor-icon.png",
                                      width: 45,
                                    )
                                  : Icon(Icons.lock,
                                      size: 50, color: ConstValues.goColor)),
                      _userLevel == 100 && _userExp == 5000
                          ? Positioned(
                              child: Container(
                              padding: EdgeInsets.only(bottom: 30, left: 25),
                              child: AnimatedOpacity(
                                duration: Duration(milliseconds: 1000),
                                curve: Curves.fastLinearToSlowEaseIn,
                                opacity: _opacity,
                                child: Icon(
                                  Icons.auto_awesome,
                                  color: Colors.yellow,
                                  size: 25,
                                ),
                              ),
                            ))
                          : Container()
                    ],
                  ),
            Container(
              padding: EdgeInsets.only(top: 4),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _showStats
                      ? Provider.of<GoColorProvider>(context).gameUnlocked
                          ? Text(
                              "Next LV",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color:
                                      _isInGame ? Colors.white : Colors.black38,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            )
                          : Container()
                      : Container(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _showStats
                          ? Provider.of<GoColorProvider>(context).gameUnlocked
                              ? Row(
                                  children: [
                                    AnimatedFlipCounter(
                                      textStyle: TextStyle(
                                          letterSpacing: 0,
                                          color: _isInGame
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                      curve: Curves.fastLinearToSlowEaseIn,
                                      duration: Duration(milliseconds: 1500),
                                      value:
                                          Provider.of<GoColorProvider>(context)
                                              .userExp,
                                    ),
                                    Container(
                                      child: Text(
                                        Provider.of<GoColorProvider>(context)
                                                .gameUnlocked
                                            ? " / 5000"
                                            : "Locked",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: _isInGame
                                                ? Colors.white
                                                : Provider.of<GoColorProvider>(
                                                            context)
                                                        .gameUnlocked
                                                    ? Colors.black
                                                    : Colors.black38,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                )
                              : Container(
                                  child: Text(
                                    Provider.of<GoColorProvider>(context)
                                            .gameUnlocked
                                        ? "HI: ${Provider.of<GoColorProvider>(context).userProgress.toStringAsFixed(0)}"
                                        : "Locked",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: _isInGame
                                            ? Colors.white
                                            : Provider.of<GoColorProvider>(
                                                        context)
                                                    .gameUnlocked
                                                ? Colors.black
                                                : Colors.black38,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                          : Container(
                              child: Text(
                                Provider.of<GoColorProvider>(context)
                                        .gameUnlocked
                                    ? "HI: ${Provider.of<GoColorProvider>(context).userProgress.toStringAsFixed(0)}"
                                    : "Locked",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: _isInGame
                                        ? Colors.white
                                        : Provider.of<GoColorProvider>(context)
                                                .gameUnlocked
                                            ? Colors.black
                                            : Colors.black38,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    print('$_key Dispose invoked');
    super.dispose();
  }
}
