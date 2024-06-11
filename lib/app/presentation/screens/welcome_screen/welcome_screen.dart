import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/buttons/buttons.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/common/common_widgets.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/log_in_screen/log_in_sreen.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/sign_in_screen/sign_in_sreen.dart';

class WelcomeScreen extends StatefulWidget {
  static const String welcomeScreenKey = "/welcome_screen";
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreen createState() => _WelcomeScreen(welcomeScreenKey);
}

class _WelcomeScreen extends State<WelcomeScreen> {
  String? _key;

  _WelcomeScreen(String welcomeScreenKey) {
    _key = welcomeScreenKey;
  }

  @override
  void initState() {
    super.initState();
    print("$_key invoked");
    WidgetsBinding.instance
        .addPostFrameCallback((_) async => await _afterBuild());
  }

  Future<void> _afterBuild() async {}

  Future<void> _goToSignInScreen() async {
    await Navigator.of(context).pushNamed(SignInScreen.signInScreenKey);
  }

  Future<void> _goToLogInScreen() async {
    await Navigator.of(context).pushNamed(LogInScreen.logInScreenKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody());
  }

  Widget _buildBody() {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Container(
          padding: EdgeInsets.all(32),
          alignment: Alignment.center,
          color: ConstValues.whiteColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                children: [
                  Container(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Image.asset(
                        "assets/images/logos/brain.png",
                        width: 100,
                      )),
                  Container(
                    padding: EdgeInsets.only(bottom: 16),
                    child: RichText(
                        text: TextSpan(
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold, fontSize: 24),
                            children: [
                          TextSpan(
                              text: "Go",
                              style: GoogleFonts.poppins(
                                  color: ConstValues.blueColor)),
                          TextSpan(
                              text: "Cognitive",
                              style: GoogleFonts.poppins(
                                  color: ConstValues.pinkColor))
                        ])),
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                      child: BlueButton(
                    text: "Get Started",
                    onPressed: () async => await _goToSignInScreen(),
                  )),
                  Container(
                    height: 16,
                  ),
                  Container(
                      child: SecondaryButton(
                    text: "Log In",
                    onPressed: () async => await _goToLogInScreen(),
                  )),
                ],
              )
            ],
          )),
    );
  }

  @override
  void dispose() {
    print('$_key Dispose invoked');
    super.dispose();
  }
}
