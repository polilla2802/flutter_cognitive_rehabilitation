import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/common/common_widgets.dart';

class PrimaryGoSpeedButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  final Color? color;
  const PrimaryGoSpeedButton(
      {super.key, this.text = "Text", this.onPressed, this.color});

  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: TextButton(
        style: OutlinedButton.styleFrom(
            elevation: 5,
            shadowColor: Colors.black,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            backgroundColor: onPressed == null
                ? ConstValues.myYellowColor[600]
                : ConstValues.goSpeedColor),
        onPressed: onPressed,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            text.toUpperCase(),
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
