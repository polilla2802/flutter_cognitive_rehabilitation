import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HowToPlayButton extends StatelessWidget {
  final Function()? onPressed;
  final bool spanish;
  const HowToPlayButton({super.key, this.onPressed, this.spanish = false});

  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: TextButton(
        style: OutlinedButton.styleFrom(
            elevation: onPressed == null ? 0 : 5,
            foregroundColor: Colors.white, // <- this changes the splash color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            side: BorderSide(width: 2.0, color: Colors.black45),
            backgroundColor:
                onPressed == null ? Colors.grey[400] : Colors.grey[600]),
        onPressed: onPressed,
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.question_mark,
                  color: Colors.transparent,
                  size: 18,
                ),
                Text(
                  spanish
                      ? "Como Jugar".toUpperCase()
                      : "How To Play".toUpperCase(),
                  textAlign: TextAlign.start,
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
                Icon(
                  Icons.question_mark,
                  color: Colors.white,
                  size: 18,
                )
              ],
            )),
      ),
    );
  }
}
