import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/common/common_widgets.dart';

class TimeButton extends StatelessWidget {
  final String time;
  const TimeButton({super.key, this.time = "0"});

  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: TextButton(
        style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white, // <- this changes the splash color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            side: BorderSide(width: 2.0, color: Colors.black),
            backgroundColor: ConstValues.myYellowColor),
        onPressed: null,
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            width: double.infinity,
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
      ),
    );
  }
}
