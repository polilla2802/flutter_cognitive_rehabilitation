import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';

import 'package:flutter/material.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/providers/providers.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/common/common_widgets.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/games/go_matrix/go_matrix_screen.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/games/go_matrix/go_matrix_details_screen.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/games/go_matrix/how_to_play_matrix_screen.dart';

class GoMatrixIcon extends StatefulWidget {
  static const String goMatrixIconKey = "go_matrix_icon";
  final bool showStats;
  final bool isInGame;
  final bool showDashboard;

  const GoMatrixIcon(
      {super.key,
      this.showStats = false,
      this.isInGame = false,
      this.showDashboard = false});

  @override
  State<GoMatrixIcon> createState() =>
      _GoMatrixIconState(goMatrixIconKey, showStats, isInGame, showDashboard);
}

class _GoMatrixIconState extends State<GoMatrixIcon> {
  late String _key;
  late bool _showStats;
  late bool _isInGame;
  late bool _showDashboard;

  late User? _user;
  late MatrixManager? _matrixManager;
  late int? _userProgress;
  late int? _userLevel;
  late int? _userExp;
  late int? _userPlayTime;
  late bool? _gameUnlocked;
  late bool _isLoading;

  Color _color = Color.fromRGBO(0, 0, 0, 0.55);
  EdgeInsets _padding = EdgeInsets.symmetric(vertical: 0);
  double _opacity = 0;

  _GoMatrixIconState(String goMatrixIconKey, bool showStats, bool isInGame,
      bool showDashboard) {
    _key = goMatrixIconKey;
    _showStats = showStats;
    _matrixManager = MatrixManager();
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
    _gameUnlocked = await _matrixManager!.getUnlockStatus(_user!.uid);
    print("GoMatrixIcon unlocked $_gameUnlocked");
    if (_gameUnlocked != null) {
      Provider.of<GoMatrixProvider>(context, listen: false).setMyUnlock =
          _gameUnlocked!;
    }
  }

  Future<void> _fetchProgress() async {
    if (Provider.of<GoMatrixProvider>(context, listen: false).gameUnlocked) {
      print("fetchProgress [USER ID]: ${_user!.uid}");
      _userProgress = await _matrixManager!.getHighScore(_user!.uid);
      print("GoMatrixIcon progress $_userProgress");
      if (_userProgress != null) {
        Provider.of<GoMatrixProvider>(context, listen: false).setMyProgress =
            _userProgress!;
      }
    } else {
      Provider.of<GoMatrixProvider>(context, listen: false).setMyProgress = 0;
    }
  }

  Future<void> _fetchPlayTime() async {
    if (Provider.of<GoMatrixProvider>(context, listen: false).gameUnlocked) {
      print("fetchPlayTime [USER ID]: ${_user!.uid}");
      _userPlayTime = await _matrixManager!.getUserPlayTime(_user!.uid);
      print("GoMatrixIcon userPlayTime $_userPlayTime");
      if (_userPlayTime != null) {
        Provider.of<GoMatrixProvider>(context, listen: false).setMyPlayTime =
            _userPlayTime!;
      }
    } else {
      Provider.of<GoMatrixProvider>(context, listen: false).setMyPlayTime = 0;
    }
  }

  Future<void> _fetchLevel() async {
    if (Provider.of<GoMatrixProvider>(context, listen: false).gameUnlocked) {
      print("fetchLevel [USER ID]: ${_user!.uid}");
      _userLevel = await _matrixManager!.getUserLevel(_user!.uid);
      _userExp = await _matrixManager!.getUserExp(_user!.uid);
      print("GoMatrixIcon level $_userLevel");
      print("GoMatrixIcon exp $_userExp");
      if (_userLevel != null) {
        Provider.of<GoMatrixProvider>(context, listen: false).setMyLevel =
            _userLevel!;
      }
      if (_userExp != null) {
        Provider.of<GoMatrixProvider>(context, listen: false).setMyExp =
            _userExp!;
      }
    } else {
      Provider.of<GoMatrixProvider>(context, listen: false).setMyProgress = 0;
      Provider.of<GoMatrixProvider>(context, listen: false).setMyExp = 0;
    }
  }

  Future<void> _goToGoMatrixDetailsScreen() async {
    await Navigator.of(context).pushReplacementNamed(
        GoMatrixDetailsScreen.goMatrixDetailsScreenKey,
        arguments: GoMatrixScreenArgs(
            showDashboard: _showDashboard,
            difficulty: Provider.of<GoMatrixProvider>(context, listen: false)
                .matrixDifficulty));
  }

  Future<void> _goToHowToPlayScreen() async {
    await Navigator.of(context).pushReplacementNamed(
        HowToPlayMatrixScreen.howToPlayMatrixScreenKey,
        arguments: GoMatrixScreenArgs(
            showDashboard: _showDashboard,
            difficulty: Provider.of<GoMatrixProvider>(context, listen: false)
                .matrixDifficulty));
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
                : Provider.of<GoMatrixProvider>(context).gameUnlocked
                    ? _userPlayTime == 0
                        ? () async => await _goToHowToPlayScreen()
                        : () async => await _goToGoMatrixDetailsScreen()
                    : null,
        onLongPress: _showStats
            ? null
            : _isLoading
                ? null
                : Provider.of<GoMatrixProvider>(context).gameUnlocked
                    ? _userPlayTime == 0
                        ? () async => await _goToHowToPlayScreen()
                        : () async => await _goToGoMatrixDetailsScreen()
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
                  value: Provider.of<GoMatrixProvider>(context).userLevel,
                )),
              ],
            ),
            Container(
              child: Text(
                "GoMatrix",
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
                        color: ConstValues.goMatrixColor,
                        borderRadius: BorderRadius.all(Radius.circular(100))),
                    triggerMode: TooltipTriggerMode.tap,
                    message:
                        "HI: ${Provider.of<GoMatrixProvider>(context).userProgress}",
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                            child: AnimatedContainer(
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Provider.of<GoMatrixProvider>(context)
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
                                maximum: 15000,
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
                                          Provider.of<GoMatrixProvider>(context)
                                                  .gameUnlocked
                                              ? _userExp!.toDouble()
                                              : 0,
                                      cornerStyle: CornerStyle.bothCurve,
                                      width: 0.2,
                                      sizeUnit: GaugeSizeUnit.factor,
                                      enableAnimation: true,
                                      color: ConstValues.goMatrixColor)
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
                            child: Provider.of<GoMatrixProvider>(context)
                                    .gameUnlocked
                                ? Image.asset(
                                    "assets/images/games/go_matrix/tile_maps/purple.png",
                                    width: 45,
                                  )
                                : Icon(Icons.lock,
                                    size: 50,
                                    color: ConstValues.goMatrixColor)),
                        _userLevel == 100 && _userExp == 15000
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
                          color: Provider.of<GoMatrixProvider>(context)
                                  .gameUnlocked
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
                              maximum: 15000,
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
                                        Provider.of<GoMatrixProvider>(context)
                                                .gameUnlocked
                                            ? _userExp!.toDouble()
                                            : 0,
                                    cornerStyle: CornerStyle.bothCurve,
                                    width: 0.2,
                                    sizeUnit: GaugeSizeUnit.factor,
                                    enableAnimation: true,
                                    color: ConstValues.goMatrixColor)
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
                          child: Provider.of<GoMatrixProvider>(context)
                                  .gameUnlocked
                              ? Image.asset(
                                  "assets/images/games/go_matrix/tile_maps/purple.png",
                                  width: 45,
                                )
                              : Icon(Icons.lock,
                                  size: 50, color: ConstValues.goMatrixColor)),
                      _userLevel == 100 && _userExp == 15000
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
                      ? Provider.of<GoMatrixProvider>(context).gameUnlocked
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
                          ? Provider.of<GoMatrixProvider>(context).gameUnlocked
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
                                          Provider.of<GoMatrixProvider>(context)
                                              .userExp,
                                    ),
                                    Container(
                                      child: Text(
                                        Provider.of<GoMatrixProvider>(context)
                                                .gameUnlocked
                                            ? " / 15000"
                                            : "Locked",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: _isInGame
                                                ? Colors.white
                                                : Provider.of<GoMatrixProvider>(
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
                                    Provider.of<GoMatrixProvider>(context)
                                            .gameUnlocked
                                        ? "HI: ${Provider.of<GoMatrixProvider>(context).userProgress.toStringAsFixed(0)}"
                                        : "Locked",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: _isInGame
                                            ? Colors.white
                                            : Provider.of<GoMatrixProvider>(
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
                                Provider.of<GoMatrixProvider>(context)
                                        .gameUnlocked
                                    ? "HI: ${Provider.of<GoMatrixProvider>(context).userProgress.toStringAsFixed(0)}"
                                    : "Locked",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: _isInGame
                                        ? Colors.white
                                        : Provider.of<GoMatrixProvider>(context)
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
