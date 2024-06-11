import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/common/common_widgets.dart';

class GoSpeedStartButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  const GoSpeedStartButton({super.key, this.text = "Text", this.onPressed});

  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: TextButton(
        style: OutlinedButton.styleFrom(
            elevation: 5,
            foregroundColor: Colors.black, // <- this changes the splash color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            side: BorderSide(width: 2.0, color: Colors.black),
            backgroundColor: onPressed == null
                ? ConstValues.myYellowColor[600]
                : ConstValues.myYellowColor),
        onPressed: onPressed,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            text.toUpperCase(),
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                color: onPressed == null ? Colors.black45 : Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
