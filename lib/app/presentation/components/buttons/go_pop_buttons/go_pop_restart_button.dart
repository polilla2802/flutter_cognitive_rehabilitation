import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/common/common_widgets.dart';

class GoPopRestartButton extends StatelessWidget {
  final String text;
  final bool shine;
  final Function()? onPressed;
  const GoPopRestartButton(
      {super.key, this.text = "Text", this.shine = false, this.onPressed});

  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: TextButton(
        style: OutlinedButton.styleFrom(
            elevation: 0,
            foregroundColor: Colors.white, // <- this changes the splash color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            backgroundColor: shine
                ? ConstValues.myBlueColor[600]
                : onPressed == null
                    ? ConstValues.myGreenColor[600]
                    : ConstValues.myGreenColor[600]),
        onPressed: onPressed,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 2),
          child: Text(
            text.toUpperCase(),
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                color: shine
                    ? ConstValues.whiteColor
                    : onPressed == null
                        ? ConstValues.myGreenColor[600]
                        : ConstValues.whiteColor,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                shadows: [
                  Shadow(
                      blurRadius: 3,
                      color: Colors.black,
                      offset: Offset.fromDirection(100))
                ]),
          ),
        ),
      ),
    );
  }
}
