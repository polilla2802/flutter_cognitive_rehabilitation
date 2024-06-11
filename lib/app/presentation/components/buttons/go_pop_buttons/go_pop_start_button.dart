import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/common/common_widgets.dart';

class GoPopStartButton extends StatelessWidget {
  final String text;
  final bool shine;
  final Function()? onPressed;
  const GoPopStartButton(
      {super.key, this.text = "Text", this.shine = false, this.onPressed});

  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: TextButton(
        style: OutlinedButton.styleFrom(
            elevation: shine ? 0 : 5,
            foregroundColor: Colors.white, // <- this changes the splash color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            side: shine
                ? BorderSide(width: 2.0, color: ConstValues.goShineColor)
                : BorderSide(width: 2.0, color: Colors.black),
            backgroundColor: shine
                ? ConstValues.myBlueColor[50]
                : onPressed == null
                    ? ConstValues.myGreenColor[600]
                    : ConstValues.myGreenColor),
        onPressed: onPressed,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            text.toUpperCase(),
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                color: shine
                    ? ConstValues.myBlueColor[500]
                    : onPressed == null
                        ? Colors.white70
                        : Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
