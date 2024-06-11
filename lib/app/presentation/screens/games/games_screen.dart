import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/titles/dashed_title.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/common/common_widgets.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/game_icons/game_icons.dart';

class GamesScreen extends StatefulWidget {
  static const String gamesScreenKey = "/games_screen";

  const GamesScreen({Key? key}) : super(key: key);

  @override
  _GamesScreenState createState() => _GamesScreenState(gamesScreenKey);
}

class _GamesScreenState extends State<GamesScreen>
    with TickerProviderStateMixin {
  late String? _key;

  double _opacity = 0;

  late AnimationController _controller;

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastLinearToSlowEaseIn,
  );

  _GamesScreenState(String gamesScreenKey) {
    _key = gamesScreenKey;
  }

  @override
  void initState() {
    super.initState();
    print('$_key invoked');
    _controller = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    WidgetsBinding.instance
        .addPostFrameCallback((_) async => await _afterBuild());
  }

  Future<void> _afterBuild() async {
    await Future.delayed(const Duration(milliseconds: 500), () {
      _animate();
    });
  }

  void _animate() {
    _controller.forward();
    setState(() {
      _opacity = 1;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: BackArrow(
          onTap: Navigator.of(context).pop,
          color: ConstValues.blueColor,
        ),
        elevation: 0,
        title: Text(
          "Games",
          style: GoogleFonts.poppins(
              fontSize: 24,
              color: ConstValues.blackColor,
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
                child: Icon(
                  Icons.gamepad,
                  size: 32,
                  color: ConstValues.pinkColor,
                ),
              ),
            ),
          )
        ],
      ),
      body: _buildBody(context));

  Widget _buildBody(BuildContext context) {
    return _buildGames();
  }

  Widget _buildGames() {
    return Container(
      color: ConstValues.whiteColor,
      alignment: Alignment.center,
      child: Stack(
        children: [
          Positioned.fill(
            top: -100,
            child: Align(
              alignment: Alignment.center,
              child: Opacity(
                  opacity: .2,
                  child: Container(
                    padding: EdgeInsets.only(bottom: 100),
                    child: Image.asset(
                      "assets/images/logos/brain.png",
                      width: 300,
                    ),
                  )),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Column(
              children: [
                AnimatedOpacity(
                  opacity: _opacity,
                  duration: Duration(milliseconds: 2000),
                  curve: Curves.fastLinearToSlowEaseIn,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: DashedTitle(
                      text: "Intro Games",
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 8),
                  margin: EdgeInsets.all(0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [_gameOne(), _gameTwo(), _gameThree()],
                  ),
                ),
                AnimatedOpacity(
                  opacity: _opacity,
                  duration: Duration(milliseconds: 2000),
                  curve: Curves.fastLinearToSlowEaseIn,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: DashedTitle(
                      text: "Memory Games",
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _gameFour(),
                      Flexible(child: Container()),
                      Flexible(child: Container())
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _gameOne() {
    return Flexible(child: GoPopIcon());
  }

  Widget _gameTwo() {
    return Flexible(child: GoColorIcon());
  }

  Widget _gameThree() {
    return Flexible(child: GoSpeedIcon());
  }

  Widget _gameFour() {
    return Flexible(child: GoMatrixIcon());
  }

  @override
  void dispose() {
    print('$_key Dispose invoked');
    _controller.dispose();
    super.dispose();
  }
}
