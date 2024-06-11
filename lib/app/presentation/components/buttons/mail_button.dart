import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/common/common_widgets.dart';

class MailButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  const MailButton({super.key, this.text = "Text", this.onPressed});

  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        child: Container(
          child: ElevatedButton.icon(
            icon: const FaIcon(FontAwesomeIcons.solidEnvelope,
                size: 32, color: Colors.white),
            onPressed: onPressed,
            label: Container(
              padding: EdgeInsets.symmetric(vertical: 18),
              child: Text(text,
                  style: GoogleFonts.poppins(
                      color: ConstValues.whiteColor, fontSize: 18)),
            ),
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              )),
              overlayColor: MaterialStateProperty.all(
                Color.fromRGBO(25, 29, 31, .15),
              ),
              alignment: Alignment.center,
              foregroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  return ConstValues.myPinkColor;
                },
              ),
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled))
                    return Color.fromRGBO(239, 77, 119, .7);
                  return ConstValues.pinkColor;
                },
              ),
            ),
          ),
        ));
  }
}

class MailButtonLoading extends StatelessWidget {
  const MailButtonLoading({super.key});

  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: TextButton(
        style: OutlinedButton.styleFrom(
          elevation: 3,
          foregroundColor: Colors.white, // <- this changes the splash color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: Colors.white,
        ),
        onPressed: null,
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: CircularProgressIndicator(
              color: ConstValues.pinkColor,
            )),
      ),
    );
  }
}
