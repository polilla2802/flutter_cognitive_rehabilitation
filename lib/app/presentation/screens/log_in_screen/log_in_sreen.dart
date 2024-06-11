import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:mobile_app_cognitive_rehabilitation/app/providers/providers.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/buttons/buttons.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/snackbars/snackbar.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/common/common_widgets.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/mail_log_in_screen/mail_log_in_sreen.dart';

class LogInScreen extends StatefulWidget {
  static const String logInScreenKey = "/log_in_screen";
  const LogInScreen({Key? key}) : super(key: key);

  @override
  _LogInScreenState createState() => _LogInScreenState(logInScreenKey);
}

class _LogInScreenState extends State<LogInScreen> {
  String? _key;
  late CustomSnackbar _snackBar;
  late bool _isLoading = false;

  _LogInScreenState(String logInScreenKey) {
    _key = logInScreenKey;
    _snackBar =
        CustomSnackbar(duration: 2, backgroundColor: ConstValues.myRedColor);
  }

  @override
  void initState() {
    super.initState();
    print("$_key invoked");
    WidgetsBinding.instance
        .addPostFrameCallback((_) async => await _afterBuild());
  }

  Future<void> _afterBuild() async {}

  Future<void> _signInWithGoogle(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    final provider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    try {
      await provider.googleLogIn(context);
    } on FirebaseAuthException catch (e) {
      _snackBar.show(context, e.message!);
    } catch (e) {}

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _goToMailLogInScreen(BuildContext context) async {
    await Navigator.of(context)
        .pushNamed(MailLogInScreen.mailLogInScreenScreenKey);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return !_isLoading;
      },
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: _isLoading == true
                ? Container()
                : BackArrow(
                    onTap: Navigator.of(context).pop,
                    color: ConstValues.blueColor,
                  ),
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Text(
              "Log In",
              style: GoogleFonts.poppins(
                  fontSize: 24,
                  color: ConstValues.blackColor,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.none),
            ),
          ),
          body: _buildBody(context)),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 16, right: 32, bottom: 0, left: 32),
        alignment: Alignment.center,
        color: ConstValues.myWhiteColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
                    child: _isLoading == true
                        ? GoogleButtonLoading()
                        : GoogleButton(
                            text: "Log In with google",
                            onPressed: () async =>
                                await _signInWithGoogle(context))),
                Container(height: 16),
                Container(
                    child: MailButton(
                        text: "Log In with mail",
                        onPressed: _isLoading
                            ? null
                            : () async => await _goToMailLogInScreen(context))),
              ],
            )
          ],
        ));
  }

  @override
  void dispose() {
    print('$_key Dispose invoked');
    super.dispose();
  }
}
