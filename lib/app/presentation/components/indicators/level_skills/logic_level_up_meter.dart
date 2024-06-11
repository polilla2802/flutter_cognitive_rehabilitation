import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';

import 'package:mobile_app_cognitive_rehabilitation/app/providers/providers.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/common/common_widgets.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/providers/skills/skill_manager.dart'
    as Skill;

class LogicLevelUpMeter extends StatefulWidget {
  final int raise;
  const LogicLevelUpMeter({super.key, this.raise = 1});

  @override
  State<LogicLevelUpMeter> createState() => _LogicLevelUpMeterState(raise);
}

class _LogicLevelUpMeterState extends State<LogicLevelUpMeter>
    with TickerProviderStateMixin {
  static const String _key = "logic_level_up_meter";

  late AnimationController _controller;
  late int _raise;

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastLinearToSlowEaseIn,
  );

  double _opacity = 0;

  late User? _user;

  late int? _userLogic;
  late Skill.SkillManager? _skillManager;

  final GlobalKey<TooltipState> tooltipkey = GlobalKey<TooltipState>();

  _LogicLevelUpMeterState(int raise) {
    _raise = raise;
    _userLogic = null;
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
    await _fetchLogic();
    await Future.delayed(const Duration(milliseconds: 100), () async {
      _animate();
    });
    await Future.delayed(const Duration(milliseconds: 300), () async {
      tooltipkey.currentState?.ensureTooltipVisible();
    });
    await Future.delayed(const Duration(seconds: 1), () async {
      tooltipkey.currentState?.deactivate();
    });
  }

  Future<void> _fetchLogic() async {
    print("fetchLogic [USER ID]: ${_user!.uid}");
    _userLogic = await _skillManager!.getLogic(_user!.uid);
    print("userLogic $_userLogic");
    if (_userLogic != null) {
      Provider.of<GameProvider>(context, listen: false).setMyLogic =
          _userLogic!;
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
      children: [toolTip(animation: _animation), logicLevelUpMeter()],
    ));
  }

  Widget logicLevelUpMeter() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(left: 8, right: 16),
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: Duration(milliseconds: 2000),
          curve: Curves.fastLinearToSlowEaseIn,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Logic: ",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold, color: Colors.white),
                          textAlign: TextAlign.left,
                        ),
                        Container(
                            child: AnimatedFlipCounter(
                          textStyle: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold, color: Colors.white),
                          curve: Curves.fastLinearToSlowEaseIn,
                          duration: Duration(milliseconds: 1500),
                          value: Provider.of<GameProvider>(context).logic,
                        )),
                      ],
                    ),
                    Text(
                      "1000",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold, color: Colors.white),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              Container(
                child: SfLinearGauge(
                    minimum: 0,
                    maximum: 1000,
                    animationDuration: 3000,
                    animateAxis: true,
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
                          endValue: Provider.of<GameProvider>(context)
                              .logic
                              .toDouble(),
                          color: ConstValues.myOrangeColor,
                          position: LinearElementPosition.cross)
                    ]),
              ),
            ],
          ),
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
        key: tooltipkey,
        textStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600, color: Colors.white, letterSpacing: 2),
        verticalOffset: -65,
        showDuration: Duration(seconds: 1),
        decoration: BoxDecoration(
            color: ConstValues.myOrangeColor,
            borderRadius: BorderRadius.all(Radius.circular(15))),
        triggerMode: TooltipTriggerMode.tap,
        message: "+ $_raise",
        child: RotationTransition(
          turns: animation!,
          child: ScaleTransition(
            scale: animation,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 1000),
              curve: Curves.fastLinearToSlowEaseIn,
              child: Image.asset(
                "assets/images/icons/skills/logic.png",
                width: 40,
              ),
            ),
          ),
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
