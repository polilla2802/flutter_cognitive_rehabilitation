import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/common/common_widgets.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/welcome_screen/welcome_screen.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/dashboard_screen/dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String splashScreenKey = "/splash_screen";

  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState(splashScreenKey);
}

class _SplashScreenState extends State<SplashScreen> {
  String _key = "";
  late bool _ready = false;
  late Color _color;
  late Random _random;

  _SplashScreenState(String splashScreenKey) {
    _key = splashScreenKey;
    _random = Random();
    _color = _random.nextBool() ? ConstValues.pinkColor : ConstValues.blueColor;
  }

  @override
  void initState() {
    super.initState();
    print("$_key invoked");
    WidgetsBinding.instance
        .addPostFrameCallback((_) async => await _afterBuild());
  }

  Future<void> _afterBuild() async {
    await _buildMethod();
  }

  Future<void> _buildMethod() async {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _ready = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      body: Container(
          color: ConstValues.whiteColor,
          alignment: Alignment.center,
          child: _buildBody(context)));

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoading();
        } else if (snapshot.hasData) {
          if (_ready) {
            return const DashboardScreen();
          } else {
            return _buildLoading();
          }
        } else if (snapshot.hasError) {
          return const Center(
            child: Text("Oops there was an error"),
          );
        }
        if (_ready) {
          return const WelcomeScreen();
        } else {
          return _buildLoading();
        }
      },
    );
  }

  Widget _buildLoading() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
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
                    style: GoogleFonts.poppins(color: ConstValues.blueColor)),
                TextSpan(
                    text: "Cognitive",
                    style: GoogleFonts.poppins(color: ConstValues.pinkColor))
              ])),
        ),
        Container(
          width: 40,
          height: 40,
          child: CircularProgressIndicator(
            color: _color,
            strokeWidth: 5,
          ),
        )
      ],
    );
  }
}
