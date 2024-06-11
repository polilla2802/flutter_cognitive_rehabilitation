import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/providers/providers.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/configuration/route_generator.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/common/common_widgets.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/splash_screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (context) => DatabaseProvider()),
        ChangeNotifierProvider(create: (context) => TBIProvider()),
        ChangeNotifierProvider(create: (context) => GameProvider()),
        ChangeNotifierProvider(create: (context) => GoPopProvider()),
        ChangeNotifierProvider(create: (context) => GoColorProvider()),
        ChangeNotifierProvider(create: (context) => GoSpeedProvider()),
        ChangeNotifierProvider(create: (context) => GoMatrixProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp(
        builder: (context, child) {
          return MediaQuery(
            child: child!,
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          );
        },
        title: 'GoCognitive Dev',
        theme: ThemeData(
            fontFamily: "Poppins",
            primaryColor: ConstValues.myPinkColor,
            primarySwatch: ConstValues.myWhiteColor,
            backgroundColor: Colors.white),
        initialRoute: SplashScreen.splashScreenKey,
        onGenerateRoute: RouteGenerator.generateRoute,
      );
}
