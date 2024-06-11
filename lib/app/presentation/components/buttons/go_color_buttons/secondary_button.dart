import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/common/common_widgets.dart';

class SecondaryGoColorButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  const SecondaryGoColorButton({super.key, this.text = "Text", this.onPressed});

  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
            elevation: 5,
            shadowColor: Colors.black,
            foregroundColor: Colors.white10, // <- this changes the splash color
            backgroundColor: Colors.black45,
            side: BorderSide(
                width: 4,
                color: onPressed == null
                    ? ConstValues.myPinkColor[500]!
                    : ConstValues.goColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            )),
        onPressed: onPressed,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Text(
            text.toUpperCase(),
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                color: onPressed == null
                    ? ConstValues.myPinkColor[500]
                    : ConstValues.goColor,
                fontSize: 20,
                fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
