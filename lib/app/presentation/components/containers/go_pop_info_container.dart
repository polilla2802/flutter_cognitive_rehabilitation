import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/common/common_widgets.dart';

class GoPopInfoContainer extends StatelessWidget {
  final int score;
  final int xp;
  final String lives;
  final String time;
  final double difficulty;
  final int timesPlayed;
  final bool shine;
  final double multiplier;
  final Function()? onPressed;

  const GoPopInfoContainer(
      {super.key,
      this.score = 0,
      this.xp = 0,
      this.lives = "0",
      this.time = "0",
      this.difficulty = 0.0,
      this.timesPlayed = 0,
      this.shine = false,
      this.multiplier = 1.0,
      this.onPressed});

  String _getMultiplier() {
    return multiplier.toStringAsFixed(1);
  }

  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: TextButton(
        style: OutlinedButton.styleFrom(
            elevation: 0,
            foregroundColor: Colors.white, // <- this changes the splash color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            side: shine
                ? BorderSide(width: 2.0, color: ConstValues.goShineColor)
                : BorderSide(width: 2.0, color: Colors.black),
            backgroundColor: shine
                ? ConstValues.myBlueColor[50]
                : ConstValues.myGreenColor[600]),
        onPressed: onPressed,
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "High Score: $score".toUpperCase(),
                          textAlign: TextAlign.start,
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.black,
                          size: 18,
                        )
                      ],
                    )),
                Container(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Lives: $lives".toUpperCase(),
                          textAlign: TextAlign.start,
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                        Icon(
                          Icons.person_add,
                          color: Colors.black,
                          size: 18,
                        )
                      ],
                    )),
                Container(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Time: $time Seconds".toUpperCase(),
                          textAlign: TextAlign.start,
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                        Icon(
                          Icons.hourglass_bottom,
                          color: Colors.black,
                          size: 18,
                        )
                      ],
                    )),
                Container(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Difficulty: ${difficulty.toStringAsFixed(0)}"
                              .toUpperCase(),
                          textAlign: TextAlign.start,
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                        Icon(
                          Icons.fire_extinguisher,
                          color: Colors.black,
                          size: 18,
                        )
                      ],
                    )),
                Container(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Times Played: $timesPlayed".toUpperCase(),
                          textAlign: TextAlign.start,
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                        Icon(
                          Icons.gamepad,
                          color: Colors.black,
                          size: 18,
                        )
                      ],
                    )),
                Container(
                    padding: EdgeInsets.only(bottom: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Score Multiplier: X${_getMultiplier()}"
                              .toUpperCase(),
                          textAlign: TextAlign.start,
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                        Icon(
                          Icons.multiline_chart_sharp,
                          color: Colors.black,
                          size: 18,
                        )
                      ],
                    )),
                Container(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Next LV:".toUpperCase(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "$xp / 10000".toUpperCase(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 8,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Stack(
                          children: [
                            Container(
                              child: SfLinearGauge(
                                  minimum: 0,
                                  maximum: 10000,
                                  animationDuration: 3000,
                                  animateAxis: true,
                                  animateRange: true,
                                  minorTicksPerInterval: 0,
                                  useRangeColorForAxis: true,
                                  maximumLabels: 3,
                                  showLabels: true,
                                  tickPosition: LinearElementPosition.cross,
                                  axisLabelStyle: GoogleFonts.poppins(
                                      fontSize: 10,
                                      letterSpacing: 0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  labelPosition: LinearLabelPosition.outside,
                                  axisTrackStyle: LinearAxisTrackStyle(
                                    thickness: 10,
                                  ),
                                  ranges: [
                                    LinearGaugeRange(
                                        rangeShapeType:
                                            LinearRangeShapeType.curve,
                                        edgeStyle: LinearEdgeStyle.bothCurve,
                                        endValue: xp.toDouble(),
                                        color: ConstValues.myBlackColor,
                                        position: LinearElementPosition.cross)
                                  ]),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Icon(
                      Icons.bar_chart,
                      color: Colors.black,
                      size: 18,
                    )
                  ],
                )),
              ],
            )),
      ),
    );
  }
}
