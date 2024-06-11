import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:mobile_app_cognitive_rehabilitation/app/providers/providers.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/inputs/inputs.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/buttons/buttons.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/snackbars/snackbar.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/common/common_widgets.dart';

class MailLogInScreen extends StatefulWidget {
  static const String mailLogInScreenScreenKey = "/mail_log_in_screen";
  const MailLogInScreen({Key? key}) : super(key: key);

  @override
  _MailLogInScreenScreenState createState() =>
      _MailLogInScreenScreenState(mailLogInScreenScreenKey);
}

class _MailLogInScreenScreenState extends State<MailLogInScreen> {
  String? _key;
  late GlobalKey<FormState> _formKey;
  late CustomSnackbar _snackBar;

  late bool _isLoading = false;
  late String? _email;
  late String? _password;

  String regExp =
      r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";

  _MailLogInScreenScreenState(String mailLogInScreenScreenKey) {
    _key = mailLogInScreenScreenKey;
    _formKey = GlobalKey<FormState>();
    _snackBar =
        CustomSnackbar(duration: 2, backgroundColor: ConstValues.myRedColor);
    _email = "";
    _password = "";
  }

  @override
  void initState() {
    super.initState();
    print("$_key invoked");
    WidgetsBinding.instance
        .addPostFrameCallback((_) async => await _afterBuild());
  }

  Future<void> _afterBuild() async {}

  Future<void> _logInWithMail(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    if (!_formKey.currentState!.validate()) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      return null;
    }
    _formKey.currentState!.save();

    print(_email!);
    print(_password!);

    final provider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    try {
      await provider.mailLogIn(context, _email!, _password!);
    } on FirebaseAuthException catch (e) {
      _snackBar.show(context, e.message!);
    } catch (e) {}

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
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
    _email = value.trim();
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return !_isLoading;
      },
      child: Scaffold(
          backgroundColor: ConstValues.myWhiteColor,
          resizeToAvoidBottomInset: false,
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
              "Mail Log In",
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
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              child: _buildForm(),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Container(
        padding: EdgeInsets.only(top: 16, right: 32, bottom: 0, left: 32),
        alignment: Alignment.center,
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
            Expanded(
              child: Container(
                  child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(children: [
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
                          textInputAction: TextInputAction.done,
                          onSaved: (String? value) => _savePassword(value!),
                          validator: (String? value) =>
                              _validatePassword(value!, context),
                        ),
                      )
                    ]),
                    Container(
                      padding: EdgeInsets.only(bottom: 36),
                      child: Column(children: [
                        Container(
                            child: _isLoading == true
                                ? MailButtonLoading()
                                : MailButton(
                                    text: "Log In with mail",
                                    onPressed: () async =>
                                        await _logInWithMail(context))),
                      ]),
                    )
                  ],
                ),
              )),
            ),
          ],
        ));
  }

  @override
  void dispose() {
    print('$_key Dispose invoked');
    super.dispose();
  }
}
