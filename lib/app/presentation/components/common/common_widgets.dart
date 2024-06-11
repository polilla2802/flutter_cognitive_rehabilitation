import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConstValues {
  static Color primaryColor = HexColor.fromHex('#f85f6a');
  static Color secondaryColor = HexColor.fromHex('#d2dae2');
  static Color blackColor = HexColor.fromHex('#191d1f');
  static Color whiteColor = HexColor.fromHex('#ffffff');
  static Color blueColor = HexColor.fromHex('#1B9DEA');
  static Color pinkColor = HexColor.fromHex('#EF4D77');
  static Color goShineColor = HexColor.fromHex("#aae7ff");
  static Color goPopColor = HexColor.fromHex("#82DFAD");
  static Color goColor = HexColor.fromHex("#EF4D77");
  static Color goSpeedColor = HexColor.fromHex("#FFDA2D");
  static Color goMatrixColor = HexColor.fromHex("#6610F2");

  static Map<int, Color> blue = {
    50: Color.fromRGBO(0, 145, 255, .1),
    100: Color.fromRGBO(0, 145, 255, .2),
    200: Color.fromRGBO(0, 145, 255, .3),
    300: Color.fromRGBO(0, 145, 255, .4),
    400: Color.fromRGBO(0, 145, 255, .5),
    500: Color.fromRGBO(0, 145, 255, .6),
    600: Color.fromRGBO(0, 145, 255, .7),
    700: Color.fromRGBO(0, 145, 255, .8),
    800: Color.fromRGBO(0, 145, 255, .9),
    900: Color.fromRGBO(0, 145, 255, 1),
  };

  static MaterialColor myBlueColor = MaterialColor(0xFF1B9DEA, blue);

  static Map<int, Color> pink = {
    50: Color.fromRGBO(239, 77, 119, .1),
    100: Color.fromRGBO(239, 77, 119, .2),
    200: Color.fromRGBO(239, 77, 119, .3),
    300: Color.fromRGBO(239, 77, 119, .4),
    400: Color.fromRGBO(239, 77, 119, .5),
    500: Color.fromRGBO(239, 77, 119, .6),
    600: Color.fromRGBO(239, 77, 119, .7),
    700: Color.fromRGBO(239, 77, 119, .8),
    800: Color.fromRGBO(239, 77, 119, .9),
    900: Color.fromRGBO(239, 77, 119, 1),
  };

  static MaterialColor myPinkColor = MaterialColor(0xFFEF4D77, pink);

  static Map<int, Color> green = {
    50: Color.fromRGBO(0, 121, 65, .1),
    100: Color.fromRGBO(0, 121, 65, .2),
    200: Color.fromRGBO(0, 121, 65, .3),
    300: Color.fromRGBO(0, 121, 65, .4),
    400: Color.fromRGBO(0, 121, 65, .5),
    500: Color.fromRGBO(0, 121, 65, .6),
    600: Color.fromRGBO(0, 121, 65, .7),
    700: Color.fromRGBO(0, 121, 65, .8),
    800: Color.fromRGBO(0, 121, 65, .9),
    900: Color.fromRGBO(0, 121, 65, 1),
  };

  static MaterialColor myGreenColor = MaterialColor(0xFF007941, green);

  static Map<int, Color> red = {
    50: Color.fromRGBO(248, 95, 106, .1),
    100: Color.fromRGBO(248, 95, 106, .2),
    200: Color.fromRGBO(248, 95, 106, .3),
    300: Color.fromRGBO(248, 95, 106, .4),
    400: Color.fromRGBO(248, 95, 106, .5),
    500: Color.fromRGBO(248, 95, 106, .6),
    600: Color.fromRGBO(248, 95, 106, .7),
    700: Color.fromRGBO(248, 95, 106, .8),
    800: Color.fromRGBO(248, 95, 106, .9),
    900: Color.fromRGBO(248, 95, 106, 1),
  };

  static MaterialColor myRedColor = MaterialColor(0xFFf85f6a, red);

  static Map<int, Color> orange = {
    50: Color.fromRGBO(255, 168, 52, .1),
    100: Color.fromRGBO(255, 168, 52, .2),
    200: Color.fromRGBO(255, 168, 52, .3),
    300: Color.fromRGBO(255, 168, 52, .4),
    400: Color.fromRGBO(255, 168, 52, .5),
    500: Color.fromRGBO(255, 168, 52, .6),
    600: Color.fromRGBO(255, 168, 52, .7),
    700: Color.fromRGBO(255, 168, 52, .8),
    800: Color.fromRGBO(255, 168, 52, .9),
    900: Color.fromRGBO(255, 168, 52, 1),
  };
  static MaterialColor myOrangeColor = MaterialColor(0xFFffa834, orange);

  static Map<int, Color> yellow = {
    50: Color.fromRGBO(255, 218, 45, .1),
    100: Color.fromRGBO(255, 218, 45, .2),
    200: Color.fromRGBO(255, 218, 45, .3),
    300: Color.fromRGBO(255, 218, 45, .4),
    400: Color.fromRGBO(255, 218, 45, .5),
    500: Color.fromRGBO(255, 218, 45, .6),
    600: Color.fromRGBO(255, 218, 45, .7),
    700: Color.fromRGBO(255, 218, 45, .8),
    800: Color.fromRGBO(255, 218, 45, .9),
    900: Color.fromRGBO(255, 218, 45, 1),
  };
  static MaterialColor myYellowColor = MaterialColor(0xFFFFDA2D, yellow);

  static Map<int, Color> silver = {
    50: Color.fromRGBO(210, 218, 226, .1),
    100: Color.fromRGBO(210, 218, 226, .2),
    200: Color.fromRGBO(210, 218, 226, .3),
    300: Color.fromRGBO(210, 218, 226, .4),
    400: Color.fromRGBO(210, 218, 226, .5),
    500: Color.fromRGBO(210, 218, 226, .6),
    600: Color.fromRGBO(210, 218, 226, .7),
    700: Color.fromRGBO(210, 218, 226, .8),
    800: Color.fromRGBO(210, 218, 226, .9),
    900: Color.fromRGBO(210, 218, 226, 1),
  };

  static MaterialColor mySilverColor = MaterialColor(0xFFd2dae2, silver);

  static Map<int, Color> black = {
    50: Color.fromRGBO(25, 29, 31, .1),
    100: Color.fromRGBO(25, 29, 31, .2),
    200: Color.fromRGBO(25, 29, 31, .3),
    300: Color.fromRGBO(25, 29, 31, .4),
    400: Color.fromRGBO(25, 29, 31, .5),
    500: Color.fromRGBO(25, 29, 31, .6),
    600: Color.fromRGBO(25, 29, 31, .7),
    700: Color.fromRGBO(25, 29, 31, .8),
    800: Color.fromRGBO(25, 29, 31, .9),
    900: Color.fromRGBO(25, 29, 31, 1),
  };
  static MaterialColor myBlackColor = MaterialColor(0xFF191d1f, black);

  static Map<int, Color> white = {
    50: Color.fromRGBO(255, 255, 255, .1),
    100: Color.fromRGBO(255, 255, 255, .2),
    200: Color.fromRGBO(255, 255, 255, .3),
    300: Color.fromRGBO(255, 255, 255, .4),
    400: Color.fromRGBO(255, 255, 255, .5),
    500: Color.fromRGBO(255, 255, 255, .6),
    600: Color.fromRGBO(255, 255, 255, .7),
    700: Color.fromRGBO(255, 255, 255, .8),
    800: Color.fromRGBO(255, 255, 255, .9),
    900: Color.fromRGBO(255, 255, 255, 1),
  };
  static MaterialColor myWhiteColor = MaterialColor(0xFFffffff, white);

  static Map<int, Color> purple = {
    50: Color.fromRGBO(102, 16, 242, .1),
    100: Color.fromRGBO(102, 16, 242, .2),
    200: Color.fromRGBO(102, 16, 242, .3),
    300: Color.fromRGBO(102, 16, 242, .4),
    400: Color.fromRGBO(102, 16, 242, .5),
    500: Color.fromRGBO(102, 16, 242, .6),
    600: Color.fromRGBO(102, 16, 242, .7),
    700: Color.fromRGBO(102, 16, 242, .8),
    800: Color.fromRGBO(102, 16, 242, .9),
    900: Color.fromRGBO(102, 16, 242, 1),
  };
  static MaterialColor myPurpleColor = MaterialColor(0xFF6610F2, purple);
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String? hexString) {
    if (hexString == null || hexString.isEmpty) {
      return ConstValues.primaryColor;
    }
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

class BackArrow extends StatelessWidget {
  final Function()? onTap;
  final Color? color;
  const BackArrow({super.key, this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Icon(
          Icons.arrow_back,
          color: color != null ? color : ConstValues.blueColor,
          size: 32,
        ),
      ),
    );
  }
}

class ForwardArrow extends StatelessWidget {
  final Function()? onTap;
  final Color? color;
  const ForwardArrow({super.key, this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Icon(
          Icons.arrow_forward,
          color: color != null ? color : ConstValues.blueColor,
          size: 32,
        ),
      ),
    );
  }
}

Widget focusToolTip({Animation<double>? animation, int? raise = 1}) {
  return Tooltip(
    textStyle: GoogleFonts.poppins(
        fontWeight: FontWeight.w600, color: Colors.white, letterSpacing: 2),
    verticalOffset: -65,
    showDuration: Duration(seconds: 1),
    decoration: BoxDecoration(
        color: ConstValues.myPurpleColor,
        borderRadius: BorderRadius.all(Radius.circular(15))),
    triggerMode: TooltipTriggerMode.tap,
    message: "f o c u s + $raise",
    child: RotationTransition(
      turns: animation!,
      child: ScaleTransition(
        scale: animation,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 1000),
          curve: Curves.fastLinearToSlowEaseIn,
          child: Image.asset(
            "assets/images/icons/skills/focus.png",
            width: 40,
          ),
        ),
      ),
    ),
  );
}

Widget logicToolTip({Animation<double>? animation, int? raise = 1}) {
  return Tooltip(
    textStyle: GoogleFonts.poppins(
        fontWeight: FontWeight.w600, color: Colors.white, letterSpacing: 2),
    verticalOffset: -65,
    showDuration: Duration(seconds: 1),
    decoration: BoxDecoration(
        color: ConstValues.myOrangeColor,
        borderRadius: BorderRadius.all(Radius.circular(15))),
    triggerMode: TooltipTriggerMode.tap,
    message: "l o g i c + $raise",
    child: RotationTransition(
      turns: animation!,
      child: ScaleTransition(
        scale: animation,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 1000),
          curve: Curves.fastLinearToSlowEaseIn,
          child: Image.asset(
            "assets/images/icons/skills/logic.png",
            width: 40,
          ),
        ),
      ),
    ),
  );
}

Widget memoryToolTip({Animation<double>? animation, int? raise = 1}) {
  return Tooltip(
    textStyle: GoogleFonts.poppins(
        fontWeight: FontWeight.w600, color: Colors.white, letterSpacing: 2),
    verticalOffset: -65,
    showDuration: Duration(seconds: 1),
    decoration: BoxDecoration(
        color: ConstValues.goColor,
        borderRadius: BorderRadius.all(Radius.circular(15))),
    triggerMode: TooltipTriggerMode.tap,
    message: "m e m o r y + $raise",
    child: RotationTransition(
      turns: animation!,
      child: ScaleTransition(
        scale: animation,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 1000),
          curve: Curves.fastLinearToSlowEaseIn,
          child: Image.asset(
            "assets/images/icons/skills/memory.png",
            width: 40,
          ),
        ),
      ),
    ),
  );
}

Widget reflexToolTip({Animation<double>? animation, int? raise = 1}) {
  return Tooltip(
    textStyle: GoogleFonts.poppins(
        fontWeight: FontWeight.w600, color: Colors.white, letterSpacing: 2),
    verticalOffset: -65,
    showDuration: Duration(seconds: 1),
    decoration: BoxDecoration(
        color: ConstValues.myGreenColor,
        borderRadius: BorderRadius.all(Radius.circular(15))),
    triggerMode: TooltipTriggerMode.tap,
    message: "r e f l e x + $raise",
    child: RotationTransition(
      turns: animation!,
      child: ScaleTransition(
        scale: animation,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 1000),
          curve: Curves.fastLinearToSlowEaseIn,
          child: Image.asset(
            "assets/images/icons/skills/reflex.png",
            width: 40,
          ),
        ),
      ),
    ),
  );
}

Widget responseToolTip({Animation<double>? animation, int? raise = 1}) {
  return Tooltip(
    textStyle: GoogleFonts.poppins(
        fontWeight: FontWeight.w600, color: Colors.white, letterSpacing: 2),
    verticalOffset: -65,
    showDuration: Duration(seconds: 1),
    decoration: BoxDecoration(
        color: ConstValues.myBlueColor,
        borderRadius: BorderRadius.all(Radius.circular(15))),
    triggerMode: TooltipTriggerMode.tap,
    message: "r e s p o n s e + $raise",
    child: RotationTransition(
      turns: animation!,
      child: ScaleTransition(
        scale: animation,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 1000),
          curve: Curves.fastLinearToSlowEaseIn,
          child: Image.asset(
            "assets/images/icons/skills/response.png",
            width: 40,
          ),
        ),
      ),
    ),
  );
}

Widget speedToolTip({Animation<double>? animation, int? raise = 1}) {
  return Tooltip(
    textStyle: GoogleFonts.poppins(
        fontWeight: FontWeight.w600, color: Colors.black, letterSpacing: 2),
    verticalOffset: -65,
    margin: EdgeInsets.only(left: 16),
    showDuration: Duration(seconds: 1),
    decoration: BoxDecoration(
        color: ConstValues.myYellowColor,
        borderRadius: BorderRadius.all(Radius.circular(15))),
    triggerMode: TooltipTriggerMode.tap,
    message: "s p e e d + $raise",
    child: RotationTransition(
      turns: animation!,
      child: ScaleTransition(
        scale: animation,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 1000),
          curve: Curves.fastLinearToSlowEaseIn,
          child: Image.asset(
            "assets/images/icons/skills/speed.png",
            width: 40,
          ),
        ),
      ),
    ),
  );
}
