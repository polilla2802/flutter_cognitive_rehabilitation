import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/common/common_widgets.dart';

class BlueSecondaryButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  const BlueSecondaryButton({super.key, this.text = "Text", this.onPressed});

  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white10, // <- this changes the splash color
            side: BorderSide(
                width: 3,
                color: onPressed == null
                    ? ConstValues.myBlueColor[500]!
                    : ConstValues.myBlueColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            )),
        onPressed: onPressed,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Text(
            text.toUpperCase(),
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                color: onPressed == null
                    ? ConstValues.myBlueColor[500]
                    : ConstValues.myBlueColor,
                fontSize: 18,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

class BlueSecondaryButtonLoading extends StatelessWidget {
  const BlueSecondaryButtonLoading({super.key});

  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
            side: BorderSide(width: 3, color: ConstValues.myBlueColor[500]!),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            )),
        onPressed: null,
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: CircularProgressIndicator(
              color: ConstValues.myBlueColor[500],
            )),
      ),
    );
  }
}
