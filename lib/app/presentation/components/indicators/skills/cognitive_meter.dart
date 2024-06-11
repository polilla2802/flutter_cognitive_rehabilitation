import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'package:mobile_app_cognitive_rehabilitation/app/providers/providers.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/common/common_widgets.dart';

class CognitiveMeter extends StatefulWidget {
  const CognitiveMeter({super.key});

  @override
  State<CognitiveMeter> createState() => _CognitiveMeterState();
}

class _CognitiveMeterState extends State<CognitiveMeter>
    with TickerProviderStateMixin {
  static const String _key = "cognitive_meter";

  late AnimationController _controller;

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastLinearToSlowEaseIn,
  );
  double _opacity = 0;

  late double _userCognitive;
  late int? _userFocus;
  late int? _userLogic;
  late int? _userMemory;
  late int? _userReflex;
  late int? _userResponse;
  late int? _userSpeed;

  final GlobalKey<TooltipState> toolTipKey = GlobalKey<TooltipState>();

  _CognitiveMeterState() {
    _userCognitive = 0;
    _userFocus = null;
    _userLogic = null;
    _userMemory = null;
    _userReflex = null;
    _userResponse = null;
    _userSpeed = null;
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
    await _fetchCognitive();
    await Future.delayed(const Duration(milliseconds: 100), () async {
      _animate();
    });
  }

  Future<void> _fetchCognitive() async {
    _userFocus = Provider.of<GameProvider>(context, listen: false).focus;
    if (_userFocus != null) {
      _userCognitive = _userCognitive + _userFocus!;
    }
    _userLogic = Provider.of<GameProvider>(context, listen: false).logic;
    if (_userLogic != null) {
      _userCognitive = _userCognitive + _userLogic!;
    }
    _userMemory = Provider.of<GameProvider>(context, listen: false).memory;
    if (_userMemory != null) {
      _userCognitive = _userCognitive + _userMemory!;
    }
    _userReflex = Provider.of<GameProvider>(context, listen: false).reflex;
    if (_userReflex != null) {
      _userCognitive = _userCognitive + _userReflex!;
    }
    _userResponse = Provider.of<GameProvider>(context, listen: false).response;
    if (_userResponse != null) {
      _userCognitive = _userCognitive + _userResponse!;
    }
    _userSpeed = Provider.of<GameProvider>(context, listen: false).speed;
    if (_userSpeed != null) {
      _userCognitive = _userCognitive + _userSpeed!;
    }

    _userCognitive = _userCognitive / 6;
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
      children: [toolTip(animation: _animation), cognitiveMeter()],
    ));
  }

  Widget cognitiveMeter() {
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
                          _userCognitive == 0
                              ? "GPI:"
                              : "GPI: ${_userCognitive.toStringAsFixed(2)}",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
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
                  animationDuration: 1500,
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
                        endValue: _userCognitive,
                        color: ConstValues.primaryColor,
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
        showDuration: Duration(seconds: 7),
        decoration: BoxDecoration(
            color: ConstValues.primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(15))),
        triggerMode: TooltipTriggerMode.tap,
        textAlign: TextAlign.center,
        message: null,
        richMessage: TextSpan(children: [
          TextSpan(
            text: "GoCognitive Performance Index (",
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                letterSpacing: 1),
          ),
          TextSpan(
              text: "GPI",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1)),
          TextSpan(
              text:
                  ") is a standardized scale calculated from all your game scores. ",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  letterSpacing: 1)),
          TextSpan(
              text: "GPI ",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1)),
          TextSpan(
              text:
                  "helps you compare your strengths and weaknesses across games that challenge different cognitive abilities.",
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
                "assets/images/logos/brain.png",
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

class CognitiveMeterZero extends StatelessWidget {
  const CognitiveMeterZero({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      children: [toolTip(), cognitiveMeter()],
    ));
  }

  Widget cognitiveMeter() {
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
                      toolTipInfo(),
                      Container(
                        padding: EdgeInsets.only(left: 8),
                        child: Text(
                          "GPI:",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
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
                  animationDuration: 1500,
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
                        endValue: 0,
                        color: ConstValues.primaryColor,
                        position: LinearElementPosition.cross)
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget toolTip() {
    return Opacity(
      opacity: 0,
      child: Tooltip(
        margin: EdgeInsets.only(top: 35, left: 60, right: 16),
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        verticalOffset: -65,
        showDuration: Duration(seconds: 7),
        decoration: BoxDecoration(
            color: ConstValues.primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(15))),
        triggerMode: TooltipTriggerMode.tap,
        textAlign: TextAlign.center,
        message: null,
        richMessage: TextSpan(children: [
          TextSpan(
            text: "GoCognitive Performance Index (",
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                letterSpacing: 1),
          ),
          TextSpan(
              text: "GPI",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1)),
          TextSpan(
              text:
                  ") is a standardized scale calculated from all your game scores. ",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  letterSpacing: 1)),
          TextSpan(
              text: "GPI ",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1)),
          TextSpan(
              text:
                  "helps you compare your strengths and weaknesses across games that challenge different cognitive abilities.",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  letterSpacing: 1)),
        ]),
        child: Image.asset(
          "assets/images/logos/brain.png",
          width: 40,
        ),
      ),
    );
  }

  Widget toolTipInfo() {
    return Opacity(
        opacity: 0,
        child: Icon(
          Icons.info_outline,
          color: Colors.black87,
          size: 20,
        ));
  }
}
