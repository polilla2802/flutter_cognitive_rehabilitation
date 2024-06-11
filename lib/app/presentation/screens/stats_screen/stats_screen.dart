import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mobile_app_cognitive_rehabilitation/app/providers/providers.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/titles/dashed_title.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/common/common_widgets.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/game_icons/game_icons.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/indicators/indicators.dart';

class StatsScreen extends StatefulWidget {
  static const String statsScreenKey = "/stats_screen";

  const StatsScreen({Key? key}) : super(key: key);

  @override
  _StatsScreenState createState() => _StatsScreenState(statsScreenKey);
}

class _StatsScreenState extends State<StatsScreen>
    with TickerProviderStateMixin {
  late String? _key;

  double _opacity = 0;

  late AnimationController _controller;

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastLinearToSlowEaseIn,
  );

  _StatsScreenState(String statsScreenKey) {
    _key = statsScreenKey;
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
    _animate();
  }

  void _animate() {
    _controller.forward();
    Provider.of<GameProvider>(context, listen: false).setMyFocusReady = false;
    Provider.of<GameProvider>(context, listen: false).setMyLogicReady = false;
    Provider.of<GameProvider>(context, listen: false).setMyMemoryReady = false;
    Provider.of<GameProvider>(context, listen: false).setMyReflexReady = false;
    Provider.of<GameProvider>(context, listen: false).setMyResponseReady =
        false;
    Provider.of<GameProvider>(context, listen: false).setMySpeedReady = false;
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
          "Stats",
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
                  Icons.query_stats,
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
    return SingleChildScrollView(
      child: Container(child: _buildData()),
    );
  }

  Widget _buildData() {
    return Container(
      color: ConstValues.whiteColor,
      alignment: Alignment.topCenter,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(
        children: [
          Container(
            child: AnimatedOpacity(
              opacity: _opacity,
              duration: Duration(milliseconds: 4000),
              curve: Curves.fastLinearToSlowEaseIn,
              child: Container(
                padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                child: DashedTitle(
                  text: "Cognitive Points",
                ),
              ),
            ),
          ),
          Container(
              margin: EdgeInsets.only(left: 8),
              width: MediaQuery.of(context).size.width,
              child: _buildGPI()),
          Container(
            child: AnimatedOpacity(
              opacity: _opacity,
              duration: Duration(milliseconds: 4000),
              curve: Curves.fastLinearToSlowEaseIn,
              child: Container(
                padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                child: DashedTitle(
                  text: "Skill Points",
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 8),
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Opacity(
                        opacity: .2,
                        child: Image.asset("assets/images/logos/brain.png")),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: EdgeInsets.only(bottom: 16),
                        child: FocusMeter()),
                    Container(
                        padding: EdgeInsets.only(bottom: 16),
                        child: LogicMeter()),
                    Container(
                        padding: EdgeInsets.only(bottom: 16),
                        child: MemoryMeter()),
                    Container(
                        padding: EdgeInsets.only(bottom: 16),
                        child: ReflexMeter()),
                    Container(
                        padding: EdgeInsets.only(bottom: 16),
                        child: ResponseMeter()),
                    Container(child: SpeedMeter()),
                  ],
                ),
              ],
            ),
          ),
          Container(
            child: AnimatedOpacity(
              opacity: _opacity,
              duration: Duration(milliseconds: 2000),
              curve: Curves.fastLinearToSlowEaseIn,
              child: Container(
                padding: EdgeInsets.fromLTRB(12, 16, 12, 0),
                child: DashedTitle(
                  text: "Level Exp",
                ),
              ),
            ),
          ),
          _buildGames()
        ],
      ),
    );
  }

  Widget _buildGPI() {
    if (Provider.of<GameProvider>(context, listen: true).focusReady &&
        Provider.of<GameProvider>(context, listen: true).logicReady &&
        Provider.of<GameProvider>(context, listen: true).memoryReady &&
        Provider.of<GameProvider>(context, listen: true).reflexReady &&
        Provider.of<GameProvider>(context, listen: true).responseReady &&
        Provider.of<GameProvider>(context, listen: true).speedReady) {
      return Container(
          padding: EdgeInsets.only(bottom: 16), child: CognitiveMeter());
    } else {
      return Container(
          padding: EdgeInsets.only(bottom: 16), child: CognitiveMeterZero());
    }
  }

  Widget _buildGames() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 16),
          margin: EdgeInsets.all(0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_gameOne(), _gameTwo(), _gameThree()],
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
    );
  }

  Widget _gameOne() {
    return Flexible(
        child: GoPopIcon(
      showStats: true,
    ));
  }

  Widget _gameTwo() {
    return Flexible(
        child: GoColorIcon(
      showStats: true,
    ));
  }

  Widget _gameThree() {
    return Flexible(
        child: GoSpeedIcon(
      showStats: true,
    ));
  }

  Widget _gameFour() {
    return Flexible(child: GoMatrixIcon(showStats: true));
  }

  @override
  void dispose() {
    print('$_key Dispose invoked');
    _controller.dispose();
    super.dispose();
  }
}
