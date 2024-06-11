import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class DashedTitle extends StatelessWidget {
  final String text;
  const DashedTitle({super.key, this.text = "Text"});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.only(bottom: 16),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(bottom: 20),
              child: Text(
                text,
                textAlign: TextAlign.end,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ),
            Positioned(
                top: 40,
                left: 0,
                right: 0,
                child: Divider(
                  color: Colors.black,
                )),
            Positioned(
                top: 40,
                left: 0,
                right: 0,
                child: Divider(
                  color: Colors.black,
                  thickness: 3,
                  indent: 250,
                ))
          ],
        ));
  }
}
