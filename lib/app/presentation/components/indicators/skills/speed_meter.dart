import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'package:mobile_app_cognitive_rehabilitation/app/providers/providers.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/common/common_widgets.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/providers/skills/skill_manager.dart'
    as Skill;

class SpeedMeter extends StatefulWidget {
  const SpeedMeter({super.key});

  @override
  State<SpeedMeter> createState() => _SpeedMeterState();
}

class _SpeedMeterState extends State<SpeedMeter> with TickerProviderStateMixin {
  static const String _key = "speed_meter";

  late AnimationController _controller;

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastLinearToSlowEaseIn,
  );

  double _opacity = 0;

  late User? _user;

  late int? _userSpeed;
  late Skill.SkillManager? _skillManager;

  final GlobalKey<TooltipState> toolTipKey = GlobalKey<TooltipState>();
  final GlobalKey<TooltipState> toolTipKeyInfo = GlobalKey<TooltipState>();

  _SpeedMeterState() {
    _userSpeed = null;
    _skillManager = Skill.SkillManager();
    _user = FirebaseAuth.instance.currentUser!;
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

  Future<void> _fetchSpeed() async {
    print("fetchSpeed [USER ID]: ${_user!.uid}");
    _userSpeed = await _skillManager!.getSpeed(_user!.uid);
    print("userSpeed $_userSpeed");
    if (_userSpeed != null) {
      Provider.of<GameProvider>(context, listen: false).setMySpeed =
          _userSpeed!;
      Provider.of<GameProvider>(context, listen: false).setMySpeedReady = true;
    }
  }

  Future<void> _afterBuild() async {
    await _fetchSpeed();
    await Future.delayed(const Duration(milliseconds: 100), () async {
      _animate();
    });
  }

  void _animate() {
    if (mounted) {
      _controller.forward();
      setState(() {
        _opacity = 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      children: [toolTip(animation: _animation), speedMeter()],
    ));
  }

  Widget speedMeter() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(left: 8, right: 16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      toolTipInfo(animation: _animation),
                      Container(
                        padding: EdgeInsets.only(left: 8),
                        child: Text(
                          "Speed: ${Provider.of<GameProvider>(context, listen: true).speed}",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold, color: Colors.black),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "1000",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, color: Colors.black),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            Container(
              child: SfLinearGauge(
                  minimum: 0,
                  maximum: 1000,
                  animationDuration: 2000,
                  animateAxis: true,
                  animateRange: true,
                  minorTicksPerInterval: 0,
                  useRangeColorForAxis: true,
                  maximumLabels: 4,
                  showLabels: false,
                  tickPosition: LinearElementPosition.cross,
                  labelPosition: LinearLabelPosition.outside,
                  axisTrackStyle: LinearAxisTrackStyle(thickness: 10),
                  ranges: [
                    LinearGaugeRange(
                        rangeShapeType: LinearRangeShapeType.curve,
                        edgeStyle: LinearEdgeStyle.bothCurve,
                        endValue:
                            Provider.of<GameProvider>(context, listen: true)
                                .speed
                                .toDouble(),
                        color: ConstValues.myYellowColor,
                        position: LinearElementPosition.cross)
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget toolTip({Animation<double>? animation}) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 1000),
      curve: Curves.fastLinearToSlowEaseIn,
      opacity: _opacity,
      child: Tooltip(
        key: toolTipKey,
        margin: EdgeInsets.only(top: 35, left: 60, right: 16),
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        verticalOffset: -65,
        showDuration: Duration(seconds: 4),
        decoration: BoxDecoration(
            color: ConstValues.myYellowColor,
            borderRadius: BorderRadius.all(Radius.circular(15))),
        triggerMode: TooltipTriggerMode.tap,
        message: null,
        richMessage: TextSpan(children: [
          TextSpan(
              text: "Processing ",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  letterSpacing: 1)),
          TextSpan(
            text: "Speed ",
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: 1),
          ),
          TextSpan(
              text:
                  " is a cognitive ability that could be defined as the time it takes a person to do a mental task.",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  letterSpacing: 1)),
        ]),
        child: RotationTransition(
          turns: animation!,
          child: ScaleTransition(
            scale: animation,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 1000),
              curve: Curves.fastLinearToSlowEaseIn,
              child: Image.asset(
                "assets/images/icons/skills/speed.png",
                width: 40,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget toolTipInfo({Animation<double>? animation}) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 1000),
      curve: Curves.fastLinearToSlowEaseIn,
      opacity: _opacity,
      child: RotationTransition(
        turns: animation!,
        child: ScaleTransition(
          scale: animation,
          child: AnimatedContainer(
              duration: Duration(milliseconds: 1000),
              curve: Curves.fastLinearToSlowEaseIn,
              child: Icon(
                Icons.info_outline,
                color: Colors.black87,
                size: 20,
              )),
        ),
      ),
    );
  }

  @override
  void dispose() async {
    print('$_key Dispose invoked');
    _controller.dispose();
    super.dispose();
  }
}
