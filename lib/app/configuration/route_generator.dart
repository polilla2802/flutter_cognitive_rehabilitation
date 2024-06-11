import 'package:flutter/material.dart';

import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/games/games_screen.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/stats_screen/stats_screen.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/log_in_screen/log_in_sreen.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/games/go_pop/go_pop_screen.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/splash_screen/splash_screen.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/sign_in_screen/sign_in_sreen.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/welcome_screen/welcome_screen.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/games/go_color/go_color_screen.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/games/go_speed/go_speed_screen.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/games/go_matrix/go_matrix_screen.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/dashboard_screen/dashboard_screen.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/functions_screen/functions_screen.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/games/go_pop/go_pop_details_screen.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/games/go_pop/how_to_play_pop_screen.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/mail_log_in_screen/mail_log_in_sreen.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/games/go_speed/go_speed_details_screen.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/games/go_color/go_color_details_screen.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/games/go_speed/how_to_play_speed_screen.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/games/go_color/how_to_play_color_screen.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/games/go_matrix/go_matrix_details_screen.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/games/go_matrix/how_to_play_matrix_screen.dart';

class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case SplashScreen.splashScreenKey:
        return MaterialPageRoute(
            settings: const RouteSettings(name: SplashScreen.splashScreenKey),
            builder: (_) => SplashScreen());
      case WelcomeScreen.welcomeScreenKey:
        return MaterialPageRoute(
            settings: const RouteSettings(name: WelcomeScreen.welcomeScreenKey),
            builder: (_) => WelcomeScreen());
      case SignInScreen.signInScreenKey:
        return MaterialPageRoute(
            settings: const RouteSettings(name: SignInScreen.signInScreenKey),
            builder: (_) => SignInScreen());
      case LogInScreen.logInScreenKey:
        return MaterialPageRoute(
            settings: const RouteSettings(name: LogInScreen.logInScreenKey),
            builder: (_) => LogInScreen());
      case MailLogInScreen.mailLogInScreenScreenKey:
        return MaterialPageRoute(
            settings: const RouteSettings(
                name: MailLogInScreen.mailLogInScreenScreenKey),
            builder: (_) => MailLogInScreen());
      case DashboardScreen.dashboardScreenKey:
        return MaterialPageRoute(
            settings:
                const RouteSettings(name: DashboardScreen.dashboardScreenKey),
            builder: (_) => DashboardScreen());
      case FunctionsScreen.functionsScreenKey:
        return MaterialPageRoute(
            settings:
                const RouteSettings(name: FunctionsScreen.functionsScreenKey),
            builder: (_) => FunctionsScreen());
      case GamesScreen.gamesScreenKey:
        return MaterialPageRoute(
            settings: const RouteSettings(name: GamesScreen.gamesScreenKey),
            builder: (_) => GamesScreen());
      case StatsScreen.statsScreenKey:
        return MaterialPageRoute(
            settings: const RouteSettings(name: StatsScreen.statsScreenKey),
            builder: (_) => StatsScreen());
      case GoPopDetailsScreen.goPopDetailsScreenKey:
        if (args is GoPopScreenArgs) {
          return MaterialPageRoute(
              settings: const RouteSettings(
                  name: GoPopDetailsScreen.goPopDetailsScreenKey),
              builder: (_) => GoPopDetailsScreen(
                    difficulty: args.difficulty,
                    shine: args.shine,
                    showDashboard: args.showDashboard,
                  ));
        }
        return MaterialPageRoute(
            settings: const RouteSettings(
                name: GoPopDetailsScreen.goPopDetailsScreenKey),
            builder: (_) => GoPopDetailsScreen());
      case GoPopScreen.goPopScreenKey:
        if (args is GoPopScreenArgs) {
          return MaterialPageRoute(
              settings: const RouteSettings(name: GoPopScreen.goPopScreenKey),
              builder: (_) => GoPopScreen(
                    highScore: args.highScore,
                    difficulty: args.difficulty,
                    shine: args.shine,
                    showDashboard: args.showDashboard,
                  ));
        }
        return MaterialPageRoute(
            settings: const RouteSettings(name: GoPopScreen.goPopScreenKey),
            builder: (_) => GoPopScreen());
      case HowToPlayPopScreen.howToPlayPopScreenKey:
        if (args is GoPopScreenArgs) {
          return MaterialPageRoute(
              settings: const RouteSettings(
                  name: HowToPlayPopScreen.howToPlayPopScreenKey),
              builder: (_) => HowToPlayPopScreen(
                    difficulty: args.difficulty,
                    shine: args.shine,
                    showDashboard: args.showDashboard,
                  ));
        }
        return MaterialPageRoute(
            settings: const RouteSettings(
                name: HowToPlayPopScreen.howToPlayPopScreenKey),
            builder: (_) => HowToPlayPopScreen());
      case GoColorDetailsScreen.goColorDetailsScreenKey:
        if (args is GoColorScreenArgs) {
          return MaterialPageRoute(
              settings: const RouteSettings(
                  name: GoColorDetailsScreen.goColorDetailsScreenKey),
              builder: (_) => GoColorDetailsScreen(
                    difficulty: args.difficulty,
                    spanish: args.spanish,
                    showDashboard: args.showDashboard,
                  ));
        }
        return MaterialPageRoute(
            settings: const RouteSettings(
                name: GoColorDetailsScreen.goColorDetailsScreenKey),
            builder: (_) => GoColorDetailsScreen());
      case GoColorScreen.goColorScreenKey:
        if (args is GoColorScreenArgs) {
          return MaterialPageRoute(
              settings:
                  const RouteSettings(name: GoColorScreen.goColorScreenKey),
              builder: (_) => GoColorScreen(
                    highScore: args.highScore,
                    timesPlayed: args.timesPlayed,
                    spanish: args.spanish,
                    showDashboard: args.showDashboard,
                    difficulty: args.difficulty,
                  ));
        }
        return MaterialPageRoute(
            settings: const RouteSettings(name: GoColorScreen.goColorScreenKey),
            builder: (_) => GoColorScreen());
      case HowToPlayColorScreen.howToPlayColorScreenKey:
        if (args is GoColorScreenArgs) {
          return MaterialPageRoute(
              settings: const RouteSettings(
                  name: HowToPlayColorScreen.howToPlayColorScreenKey),
              builder: (_) => HowToPlayColorScreen(
                    difficulty: args.difficulty,
                    spanish: args.spanish,
                    showDashboard: args.showDashboard,
                  ));
        }
        return MaterialPageRoute(
            settings: const RouteSettings(
                name: HowToPlayColorScreen.howToPlayColorScreenKey),
            builder: (_) => HowToPlayColorScreen());
      case GoSpeedDetailsScreen.goSpeedDetailsScreenKey:
        if (args is GoSpeedScreenArgs) {
          return MaterialPageRoute(
              settings: const RouteSettings(
                  name: GoSpeedDetailsScreen.goSpeedDetailsScreenKey),
              builder: (_) => GoSpeedDetailsScreen(
                    difficulty: args.difficulty,
                    showDashboard: args.showDashboard,
                  ));
        }
        return MaterialPageRoute(
            settings: const RouteSettings(
                name: GoSpeedDetailsScreen.goSpeedDetailsScreenKey),
            builder: (_) => GoSpeedDetailsScreen());
      case GoSpeedScreen.goSpeedScreenKey:
        if (args is GoSpeedScreenArgs) {
          return MaterialPageRoute(
              settings:
                  const RouteSettings(name: GoSpeedScreen.goSpeedScreenKey),
              builder: (_) => GoSpeedScreen(
                    highScore: args.highScore,
                    timesPlayed: args.timesPlayed,
                    showDashboard: args.showDashboard,
                    difficulty: args.difficulty,
                  ));
        }
        return MaterialPageRoute(
            settings: const RouteSettings(name: GoSpeedScreen.goSpeedScreenKey),
            builder: (_) => GoSpeedScreen());
      case HowToPlaySpeedScreen.howToPlaySpeedScreenKey:
        if (args is GoSpeedScreenArgs) {
          return MaterialPageRoute(
              settings: const RouteSettings(
                  name: HowToPlaySpeedScreen.howToPlaySpeedScreenKey),
              builder: (_) => HowToPlaySpeedScreen(
                    difficulty: args.difficulty,
                    showDashboard: args.showDashboard,
                  ));
        }
        return MaterialPageRoute(
            settings: const RouteSettings(
                name: HowToPlaySpeedScreen.howToPlaySpeedScreenKey),
            builder: (_) => HowToPlaySpeedScreen());
      case GoMatrixDetailsScreen.goMatrixDetailsScreenKey:
        if (args is GoMatrixScreenArgs) {
          return MaterialPageRoute(
              settings: const RouteSettings(
                  name: GoMatrixDetailsScreen.goMatrixDetailsScreenKey),
              builder: (_) => GoMatrixDetailsScreen(
                    difficulty: args.difficulty,
                    showDashboard: args.showDashboard,
                  ));
        }
        return MaterialPageRoute(
            settings: const RouteSettings(
                name: GoMatrixDetailsScreen.goMatrixDetailsScreenKey),
            builder: (_) => GoMatrixDetailsScreen());
      case GoMatrixScreen.goMatrixScreenKey:
        if (args is GoMatrixScreenArgs) {
          return MaterialPageRoute(
              settings:
                  const RouteSettings(name: GoMatrixScreen.goMatrixScreenKey),
              builder: (_) => GoMatrixScreen(
                    highScore: args.highScore,
                    showDashboard: args.showDashboard,
                    difficulty: args.difficulty,
                  ));
        }
        return MaterialPageRoute(
            settings:
                const RouteSettings(name: GoMatrixScreen.goMatrixScreenKey),
            builder: (_) => GoMatrixScreen());
      case HowToPlayMatrixScreen.howToPlayMatrixScreenKey:
        if (args is GoMatrixScreenArgs) {
          return MaterialPageRoute(
              settings: const RouteSettings(
                  name: HowToPlayMatrixScreen.howToPlayMatrixScreenKey),
              builder: (_) => HowToPlayMatrixScreen(
                    difficulty: args.difficulty,
                    showDashboard: args.showDashboard,
                  ));
        }
        return MaterialPageRoute(
            settings: const RouteSettings(
                name: HowToPlayMatrixScreen.howToPlayMatrixScreenKey),
            builder: (_) => HowToPlayMatrixScreen());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
