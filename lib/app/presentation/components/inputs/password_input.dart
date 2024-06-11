import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/common/common_widgets.dart';

class PasswordInput extends StatelessWidget {
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputAction? textInputAction;

  const PasswordInput(
      {super.key,
      this.onSaved,
      this.validator,
      this.obscureText = false,
      this.textInputAction = TextInputAction.next});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        style: GoogleFonts.poppins(color: ConstValues.blackColor, fontSize: 18),
        cursorColor: ConstValues.pinkColor,
        obscureText: obscureText,
        onSaved: onSaved,
        validator: validator,
        keyboardType: TextInputType.visiblePassword,
        textInputAction: textInputAction,
        decoration: InputDecoration(
            hintText: 'Password', hintStyle: GoogleFonts.poppins(fontSize: 16)),
      ),
    );
  }
}
