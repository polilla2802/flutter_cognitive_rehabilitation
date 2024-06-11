import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'package:mobile_app_cognitive_rehabilitation/app/providers/providers.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/common/common_widgets.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/providers/skills/skill_manager.dart'
    as Skill;

class FocusMeter extends StatefulWidget {
  const FocusMeter({super.key});

  @override
  State<FocusMeter> createState() => _FocusMeterState();
}

class _FocusMeterState extends State<FocusMeter> with TickerProviderStateMixin {
  static const String _key = "focus_meter";

  late AnimationController _controller;

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastLinearToSlowEaseIn,
  );
  double _opacity = 0;

  late User? _user;

  late int? _userFocus;
  late Skill.SkillManager? _skillManager;

  final GlobalKey<TooltipState> toolTipKey = GlobalKey<TooltipState>();

  _FocusMeterState() {
    _userFocus = null;
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

  Future<void> _afterBuild() async {
    await _fetchFocus();
    await Future.delayed(const Duration(milliseconds: 100), () async {
      _animate();
    });
  }

  Future<void> _fetchFocus() async {
    print("fetchFocus [USER ID]: ${_user!.uid}");
    _userFocus = await _skillManager!.getFocus(_user!.uid);
    print("userFocus $_userFocus");
    if (_userFocus != null) {
      Provider.of<GameProvider>(context, listen: false).setMyFocus =
          _userFocus!;
      Provider.of<GameProvider>(context, listen: false).setMyFocusReady = true;
    }
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
      children: [toolTip(animation: _animation), focusMeter()],
    ));
  }

  Widget focusMeter() {
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
                          "Focus: ${Provider.of<GameProvider>(context, listen: true).focus}",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold, color: Colors.black),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 8),
                        child: Text(
                          "1000",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold, color: Colors.black),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              child: SfLinearGauge(
                  minimum: 0,
                  maximum: 1000,
                  animationDuration: 2000,
                  animateAxis: false,
                  animateRange: true,
                  minorTicksPerInterval: 0,
                  useRangeColorForAxis: true,
                  maximumLabels: 4,
                  showLabels: false,
                  tickPosition: LinearElementPosition.cross,
                  labelPosition: LinearLabelPosition.outside,
                  axisTrackStyle: LinearAxisTrackStyle(thickness: 10),
                  markerPointers: null,
                  ranges: [
                    LinearGaugeRange(
                        rangeShapeType: LinearRangeShapeType.curve,
                        edgeStyle: LinearEdgeStyle.bothCurve,
                        endValue:
                            Provider.of<GameProvider>(context, listen: true)
                                .focus
                                .toDouble(),
                        color: ConstValues.myPurpleColor,
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
            color: ConstValues.myPurpleColor,
            borderRadius: BorderRadius.all(Radius.circular(15))),
        triggerMode: TooltipTriggerMode.tap,
        textAlign: TextAlign.center,
        message: null,
        richMessage: TextSpan(children: [
          TextSpan(
            text: "Focus ",
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1),
          ),
          TextSpan(
              text:
                  "is the ability to concentrate on problems inside or outside of you in a deliberate way.",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
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
                "assets/images/icons/skills/focus.png",
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
