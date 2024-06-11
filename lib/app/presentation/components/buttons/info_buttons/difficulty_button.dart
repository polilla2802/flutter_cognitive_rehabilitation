import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/common/common_widgets.dart';

class DifficultyButton extends StatelessWidget {
  final String difficulty;
  const DifficultyButton({super.key, this.difficulty = "Easy"});

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
            backgroundColor: ConstValues.myBlackColor),
        onPressed: null,
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Difficulty: $difficulty".toUpperCase(),
                  textAlign: TextAlign.start,
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
                Icon(
                  Icons.fire_extinguisher,
                  color: Colors.white,
                  size: 18,
                )
              ],
            )),
      ),
    );
  }
}
