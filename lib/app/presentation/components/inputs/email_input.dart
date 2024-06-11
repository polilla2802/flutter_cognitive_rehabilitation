import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/common/common_widgets.dart';

class EmailInput extends StatelessWidget {
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;

  const EmailInput({super.key, this.onSaved, this.validator});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        style: GoogleFonts.poppins(color: ConstValues.blackColor, fontSize: 18),
        cursorColor: ConstValues.pinkColor,
        onSaved: onSaved,
        validator: validator,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            hintText: 'Email', hintStyle: GoogleFonts.poppins(fontSize: 16)),
      ),
    );
  }
}
