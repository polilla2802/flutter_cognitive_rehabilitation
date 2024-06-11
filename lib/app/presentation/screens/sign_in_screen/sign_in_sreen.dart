import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:mobile_app_cognitive_rehabilitation/app/providers/providers.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/inputs/inputs.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/buttons/buttons.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/snackbars/snackbar.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/common/common_widgets.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/log_in_screen/log_in_sreen.dart';

class SignInScreen extends StatefulWidget {
  static const String signInScreenKey = "/sign_in_screen";
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState(signInScreenKey);
}

class _SignInScreenState extends State<SignInScreen> {
  String? _key;
  late GlobalKey<FormState> _formKey;
  late CustomSnackbar _snackBar;
  late bool _isLoading = false;
  late String? _name;
  late String? _mail;
  late String? _password;
  late String? _passwordRepeat;

  String regExp =
      r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";

  _SignInScreenState(String signInScreenKey) {
    _key = signInScreenKey;
    _formKey = GlobalKey<FormState>();
    _snackBar =
        CustomSnackbar(duration: 2, backgroundColor: ConstValues.myRedColor);
    _name = "";
    _mail = "";
    _password = "";
    _passwordRepeat = "";
  }

  @override
  void initState() {
    super.initState();
    print("$_key invoked");
    WidgetsBinding.instance
        .addPostFrameCallback((_) async => await _afterBuild());
  }

  Future<void> _afterBuild() async {}

  Future<void> _signInWithMail(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    if (!_formKey.currentState!.validate()) {
      _snackBar.show(context, "There are some invalid fields");

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      return null;
    }
    _formKey.currentState!.save();

    print(_name!);
    print(_mail!);
    print(_password!);
    print(_passwordRepeat!);

    if (_password! == _passwordRepeat) {
      final provider =
          Provider.of<AuthenticationProvider>(context, listen: false);
      try {
        await provider.mailSignIn(context, _name!, _mail!, _password!);
      } on FirebaseAuthException catch (e) {
        _snackBar.show(context, e.message!);
      } catch (e) {}

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      _snackBar.show(context, "Passwords do not match");

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _goToLogInScreen() async {
    await Navigator.of(context)
        .pushReplacementNamed(LogInScreen.logInScreenKey);
  }

  String? _validateName(String value, BuildContext context) {
    if (value.isEmpty) {
      return "Name is required";
    }
    return null;
  }

  void _saveName(String value) {
    _name = value.trim();
  }

  String? _validateEmail(String value, BuildContext context) {
    if (value.isEmpty) {
      return "Email is required";
    }
    if (!RegExp(regExp).hasMatch(value.trim())) {
      return "Invalid Email";
    }
    return null;
  }

  void _saveEmail(String value) {
    _mail = value.trim();
  }

  String? _validatePassword(String value, BuildContext context) {
    if (value.isEmpty) {
      return "Password is required";
    }
    return null;
  }

  void _savePassword(String value) {
    _password = value.trim();
  }

  String? _validatePasswordRepeat(String value, BuildContext context) {
    if (value.isEmpty) {
      return "Password is required";
    }
    return null;
  }

  void _savePasswordRepeat(value) {
    _passwordRepeat = value.trim();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return !_isLoading;
      },
      child: Scaffold(
          backgroundColor: ConstValues.whiteColor,
          resizeToAvoidBottomInset: true,
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
              "Sign In",
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
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            child: _buildForm(),
          ),
        ));
  }

  Widget _buildForm() {
    return Container(
        padding: EdgeInsets.only(top: 16, right: 32, bottom: 0, left: 32),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              child: Column(
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
            ),
            Container(
                child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Column(children: [
                      Container(
                        padding: EdgeInsets.only(bottom: 32),
                        child: NameInput(
                          onSaved: (String? value) => _saveName(value!),
                          validator: (String? value) =>
                              _validateName(value!, context),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: 32),
                        child: EmailInput(
                          onSaved: (String? value) => _saveEmail(value!),
                          validator: (String? value) =>
                              _validateEmail(value!, context),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: 32),
                        child: PasswordInput(
                          obscureText: true,
                          onSaved: (String? value) => _savePassword(value!),
                          validator: (String? value) =>
                              _validatePassword(value!, context),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: 42),
                        child: PasswordInput(
                          textInputAction: TextInputAction.done,
                          obscureText: true,
                          onSaved: (String? value) =>
                              _savePasswordRepeat(value!),
                          validator: (String? value) =>
                              _validatePasswordRepeat(value!, context),
                        ),
                      )
                    ]),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 24),
                    child: Column(children: [
                      Container(
                          child: _isLoading == true
                              ? MailButtonLoading()
                              : MailButton(
                                  text: "Sign In with mail",
                                  onPressed: () async =>
                                      await _signInWithMail(context))),
                      GestureDetector(
                        onTap: _isLoading
                            ? null
                            : () async => await _goToLogInScreen(),
                        child: Container(
                          padding: EdgeInsets.only(top: 16),
                          child: Text(
                            "Already have an account? Log In",
                            style: GoogleFonts.poppins(
                                color: _isLoading
                                    ? Colors.black45
                                    : ConstValues.myBlackColor,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      )
                    ]),
                  )
                ],
              ),
            )),
          ],
        ));
  }

  @override
  void dispose() {
    print('$_key Dispose invoked');
    super.dispose();
  }
}
