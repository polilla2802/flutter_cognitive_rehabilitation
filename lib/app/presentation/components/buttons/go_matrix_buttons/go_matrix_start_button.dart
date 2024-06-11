import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/common/common_widgets.dart';

class GoMatrixStartButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  const GoMatrixStartButton({super.key, this.text = "Text", this.onPressed});

  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: TextButton(
        style: OutlinedButton.styleFrom(
            elevation: 5,
            foregroundColor: Colors.white, // <- this changes the splash color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            side: BorderSide(width: 2.0, color: Colors.black),
            backgroundColor: onPressed == null
                ? ConstValues.myPurpleColor[600]
                : ConstValues.myPurpleColor),
        onPressed: onPressed,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            text.toUpperCase(),
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                color: onPressed == null ? Colors.white70 : Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
