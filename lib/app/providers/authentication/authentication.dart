import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:flutter/widgets.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/providers/providers.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/splash_screen/splash_screen.dart';

enum AuthenticationState {
  initial,
}

class AuthenticationProvider extends ChangeNotifier {
  static const _key = "AuthenticationProvider";

  late AuthenticationState _state;
  late DatabaseManager? _database;
  late GoogleSignIn _googleSignIn;
  late GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  AuthenticationProvider() {
    _state = AuthenticationState.initial;
    _database = DatabaseManager();
    _googleSignIn = GoogleSignIn();
  }

  AuthenticationState get state => _state;

  void _emit() {
    print("{$_key} _emit invoked");

    notifyListeners();
  }

  void _changeState(AuthenticationState state) {
    _state = state;

    _emit();
  }

  Future<void> mailSignIn(
      BuildContext context, String name, String email, String password) async {
    print("[mailSignIn invoked]");

    try {
      final UserCredential credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        bool initialProgress =
            await _database!.createUserProgress(credential.user!.uid);
        if (initialProgress) {
          await credential.user!.updateDisplayName(name);

          await Navigator.of(context).pushNamedAndRemoveUntil(
              SplashScreen.splashScreenKey,
              ModalRoute.withName(SplashScreen.splashScreenKey));
        } else {
          throw FirebaseAuthException(
              message: "Oops, there was an error, please contact support",
              code: "500");
        }
      } else {
        throw FirebaseAuthException(
            message: "Oops, there was an error, please contact support",
            code: "500");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw FirebaseAuthException(
            message: "The password provided is too weak", code: "400");
      } else if (e.code == 'email-already-in-use') {
        throw FirebaseAuthException(
            message: "An account already exists for that email", code: "500");
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> mailLogIn(
      BuildContext context, String email, String password) async {
    print("[mailLogIn invoked]");

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      await Navigator.of(context).pushNamedAndRemoveUntil(
          SplashScreen.splashScreenKey,
          ModalRoute.withName(SplashScreen.splashScreenKey));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw FirebaseAuthException(
            message: "No user found for that email", code: "500");
      } else if (e.code == 'wrong-password') {
        throw FirebaseAuthException(
            message: "Wrong password provided for that user", code: "400");
      }
    }
  }

  Future<void> googleLogIn(BuildContext context) async {
    print("[googleLogIn invoked]");

    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;
      _user = googleUser;

      final googleAuth = await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.additionalUserInfo!.isNewUser) {
        bool initialProgress =
            await _database!.createUserProgress(userCredential.user!.uid);

        if (initialProgress) {
          await Navigator.of(context).pushNamedAndRemoveUntil(
              SplashScreen.splashScreenKey,
              ModalRoute.withName(SplashScreen.splashScreenKey));
        } else {
          FirebaseAuth.instance.currentUser!.delete();
          throw FirebaseAuthException(
              message: "Oops, there was an error, try again later.",
              code: "500");
        }
      }

      await Navigator.of(context).pushNamedAndRemoveUntil(
          SplashScreen.splashScreenKey,
          ModalRoute.withName(SplashScreen.splashScreenKey));
    } on FirebaseAuthException catch (e) {
      log("[GOOGLE ERROR]: ${e.toString()}");
      FirebaseAuth.instance.currentUser!.delete();
      throw FirebaseAuthException(
          message: "Oops, there was an error, try again later.", code: "500");
    } catch (e) {
      log("[GOOGLE ERROR]: ${e.toString()}");
      FirebaseAuth.instance.currentUser!.delete();
      throw FirebaseAuthException(
          message: "Oops, there was an error, try again later.", code: "500");
    }
  }

  Future<void> logOut(BuildContext context) async {
    print("[logOut invoked]");
    try {
      //Checks if session is from google sign in
      final googleUser = await _googleSignIn.isSignedIn();

      if (googleUser) {
        //If session is from google account, it disconnects first before Sign Out
        await _googleSignIn.disconnect();
        await FirebaseAuth.instance.signOut();
      } else {
        //If session is just mail it just Signs Out
        await FirebaseAuth.instance.signOut();
      }
    } catch (e) {
      log("[GOOGLE ERROR]: ${e.toString()}");
      throw FirebaseAuthException(
          message: "Oops, there was an error, try again later.", code: "500");
    }
  }
}
