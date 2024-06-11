import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'package:mobile_app_cognitive_rehabilitation/app/providers/providers.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/common/common_widgets.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/providers/skills/skill_manager.dart'
    as Skill;

class ResponseMeter extends StatefulWidget {
  const ResponseMeter({super.key});

  @override
  State<ResponseMeter> createState() => _ResponseMeterState();
}

class _ResponseMeterState extends State<ResponseMeter>
    with TickerProviderStateMixin {
  static const String _key = "reflex_meter";

  late AnimationController _controller;

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastLinearToSlowEaseIn,
  );

  double _opacity = 0;

  late User? _user;

  late int? _userResponse;
  late Skill.SkillManager? _skillManager;

  final GlobalKey<TooltipState> toolTipKey = GlobalKey<TooltipState>();
  final GlobalKey<TooltipState> toolTipKeyInfo = GlobalKey<TooltipState>();

  _ResponseMeterState() {
    _userResponse = null;
    _skillManager = Skill.SkillManager();
    _user = FirebaseAuth.instance.currentUser!;
  }

  Future<void> _fetchResponse() async {
    print("fetchResponse [USER ID]: ${_user!.uid}");
    _userResponse = await _skillManager!.getResponse(_user!.uid);
    print("userResponse $_userResponse");
    if (_userResponse != null) {
      Provider.of<GameProvider>(context, listen: false).setMyResponse =
          _userResponse!;
      Provider.of<GameProvider>(context, listen: false).setMyResponseReady =
          true;
    }
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
    await _fetchResponse();
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
      children: [toolTip(animation: _animation), responseMeter()],
    ));
  }

  Widget responseMeter() {
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
                          "Response: ${Provider.of<GameProvider>(context, listen: true).response}",
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "1000",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            Container(
              child: SfLinearGauge(
                  minimum: 0,
                  maximum: 1000,
                  animateAxis: true,
                  animateRange: true,
                  animationDuration: 2000,
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
                                .response
                                .toDouble(),
                        color: ConstValues.myBlueColor,
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
        showDuration: Duration(seconds: 3),
        decoration: BoxDecoration(
            color: ConstValues.myBlueColor,
            borderRadius: BorderRadius.all(Radius.circular(15))),
        triggerMode: TooltipTriggerMode.tap,
        message: null,
        richMessage: TextSpan(children: [
          TextSpan(
            text: "Response ",
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1),
          ),
          TextSpan(
              text:
                  "is a clearly defined, measurable physical reaction to a stimulus.",
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
                "assets/images/icons/skills/response.png",
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
