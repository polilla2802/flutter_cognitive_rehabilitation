import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/common/common_widgets.dart';

class BlueButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  const BlueButton({super.key, this.text = "Text", this.onPressed});

  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: TextButton(
        style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white, // <- this changes the splash color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: onPressed == null
                ? ConstValues.myBlueColor[600]
                : ConstValues.blueColor),
        onPressed: onPressed,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
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

class BlueButtonLoading extends StatelessWidget {
  const BlueButtonLoading({super.key});

  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: TextButton(
        style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white, // <- this changes the splash color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: ConstValues.myBlueColor[600]),
        onPressed: null,
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: CircularProgressIndicator(
              color: Colors.white,
            )),
      ),
    );
  }
}