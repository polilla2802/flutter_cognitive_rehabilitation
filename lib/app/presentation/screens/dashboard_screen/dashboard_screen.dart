import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/providers/providers.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/games/games_screen.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/snackbars/snackbar.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/titles/dashed_title.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/game_icons/game_icons.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/common/common_widgets.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/stats_screen/stats_screen.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/containers/info_container.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/functions_screen/functions_screen.dart';

class DashboardScreen extends StatefulWidget {
  static const String dashboardScreenKey = "/dashboard_screen";
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() =>
      _DashboardScreenState(dashboardScreenKey);
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? _key;

  late User? _user;
  Set<int> setOfInts = Set();
  late List<int>? randomEffects;

  double _opacity = 0;

  late GlobalKey<ScaffoldState> _scaffoldKey;
  late CustomSnackbar _snackBar;

  _DashboardScreenState(String dashboardScreenKey) {
    _key = dashboardScreenKey;
    _scaffoldKey = GlobalKey<ScaffoldState>();
    _user = FirebaseAuth.instance.currentUser!;
    randomEffects = null;
    _snackBar =
        CustomSnackbar(duration: 2, backgroundColor: ConstValues.myRedColor);
  }

  @override
  void initState() {
    super.initState();
    print("$_key invoked");
    //Gets list of effects from firebase at start of this screen
    Provider.of<TBIProvider>(context, listen: false).getEffects();
    WidgetsBinding.instance
        .addPostFrameCallback((_) async => await _afterBuild());
  }

  Future<void> _afterBuild() async {
    setState(() {
      _opacity = 1;
    });
  }

  Future<void> _goToGamesScreen() async {
    await Navigator.of(context).pushNamed(GamesScreen.gamesScreenKey);
  }

  Future<void> _goToStatsScreen() async {
    await Navigator.of(context).pushNamed(StatsScreen.statsScreenKey);
  }

  Future<void> _goToFunctionsScreen() async {
    await Navigator.of(context).pushNamed(FunctionsScreen.functionsScreenKey);
  }

  Future<void> _logOut() async {
    final provider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    try {
      await provider.logOut(context);
    } on FirebaseAuthException catch (e) {
      _snackBar.show(context, e.message!);
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(context),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: _openDrawer(),
        title: Text(
          "Dashboard",
          style: GoogleFonts.poppins(
              fontSize: 24,
              color: ConstValues.blackColor,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.none),
        ),
        actions: [
          TextButton(
              onPressed: () async => await _logOut(),
              child: Container(
                child: Icon(
                  Icons.logout,
                  color: ConstValues.pinkColor,
                  size: 32,
                ),
              )),
        ],
      ),
      body: _buildBody());

  Widget _buildBody() {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child:
            SingleChildScrollView(child: Container(child: _buildDashBoard())));
  }

  Widget _buildDashBoard() {
    return Container(
        padding: EdgeInsets.only(top: 16, right: 16, bottom: 16, left: 16),
        alignment: Alignment.center,
        color: ConstValues.myWhiteColor,
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: Duration(milliseconds: 2000),
          curve: Curves.fastLinearToSlowEaseIn,
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Opacity(
                        opacity: .2,
                        child: Container(
                          padding: EdgeInsets.only(top: 80),
                          child: Image.asset(
                            "assets/images/logos/brain.png",
                            width: 300,
                          ),
                        )),
                  ),
                ),
                Column(
                  children: [
                    ..._buildLatestGames(),
                    Container(
                      child: AnimatedOpacity(
                        opacity: _opacity,
                        duration: Duration(milliseconds: 2000),
                        curve: Curves.fastLinearToSlowEaseIn,
                        child: Container(
                          child: DashedTitle(
                            text: "What Is TBI",
                          ),
                        ),
                      ),
                    ),
                    _buildTBICard(),
                    Container(
                      child: AnimatedOpacity(
                        opacity: _opacity,
                        duration: Duration(milliseconds: 2000),
                        curve: Curves.fastLinearToSlowEaseIn,
                        child: Container(
                          child: DashedTitle(
                            text: "TBI Effects",
                          ),
                        ),
                      ),
                    ),
                    _buildEffectList()
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  List<Widget> _buildLatestGames() {
    return [
      Container(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: Duration(milliseconds: 2000),
          curve: Curves.fastLinearToSlowEaseIn,
          child: Container(
            child: DashedTitle(
              text: "Latest Games",
            ),
          ),
        ),
      ),
      Container(
        padding: EdgeInsets.only(bottom: 8),
        margin: EdgeInsets.all(0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_gameOne(), _gameTwo(), _gameThree()],
        ),
      ),
    ];
  }

  Widget _buildTBICard() {
    if (Provider.of<TBIProvider>(context, listen: true).effects == null) {
      return Container();
    } else {
      return Container(
        padding: EdgeInsets.only(bottom: 16),
        child: AnimatedOpacity(
            opacity: _opacity,
            duration: Duration(milliseconds: 2000),
            curve: Curves.fastLinearToSlowEaseIn,
            child: InfoContainer(
              title: "What is TBI?",
              description:
                  "Traumatic Brain Injury (TBI) happens when a sudden, external, physical assault damages the brain. It is one of the most common causes of disability and death in adults.",
            )),
      );
    }
  }

  Widget _buildEffectList() {
    if (Provider.of<TBIProvider>(context, listen: true).effects == null) {
      return Container();
    } else {
      randomEffects = List<int>.generate(
          Provider.of<TBIProvider>(context, listen: false).effects!.length,
          (int index) => index);
      randomEffects!.shuffle();

      return Wrap(children: [
        Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [for (int i = 0; i <= 1; i++) _buildEffects(i)])
      ]);
    }
  }

  Widget _buildEffects(int i) {
    return Container(
      padding: EdgeInsets.only(bottom: 16),
      child: AnimatedOpacity(
          opacity: _opacity,
          duration: Duration(milliseconds: 2000),
          curve: Curves.fastLinearToSlowEaseIn,
          child: InfoContainer(
            title: Provider.of<TBIProvider>(context, listen: true)
                .effects![randomEffects![i]]
                .data!
                .title,
            description: Provider.of<TBIProvider>(context, listen: true)
                .effects![randomEffects![i]]
                .data!
                .description,
          )),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: ConstValues.myWhiteColor,
      child: Container(
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Container(
            height: 60,
            color: ConstValues.whiteColor,
          ),
          Container(
            child: ListTile(
              iconColor: ConstValues.pinkColor,
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
              leading: Icon(
                Icons.person,
                size: 32,
              ),
              title: Text(
                  _user!.displayName != null ? _user!.displayName! : "Profile",
                  style: GoogleFonts.poppins(
                      color: ConstValues.myBlackColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w500)),
              onTap: null,
            ),
          ),
          Container(
            child: ListTile(
              iconColor: ConstValues.blueColor,
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
              leading: Icon(
                Icons.gamepad,
                size: 32,
              ),
              title: Text("Games",
                  style: GoogleFonts.poppins(
                      color: ConstValues.myBlackColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w500)),
              onTap: () async => await _goToGamesScreen(),
            ),
          ),
          Container(
            child: ListTile(
              iconColor: ConstValues.pinkColor,
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
              leading: Icon(
                Icons.query_stats,
                size: 32,
              ),
              title: Text("Stats",
                  style: GoogleFonts.poppins(
                      color: ConstValues.myBlackColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w500)),
              onTap: () async => await _goToStatsScreen(),
            ),
          ),
          _user != null
              ? _user!.uid == "EoxeIEbovjfwFQ4QZdwZOvy0REq2"
                  ? Container(
                      child: ListTile(
                        iconColor: ConstValues.blueColor,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        leading: Icon(
                          Icons.data_object,
                          size: 32,
                        ),
                        title: Text("Functions",
                            style: GoogleFonts.poppins(
                                color: ConstValues.myBlackColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w500)),
                        onTap: () async => await _goToFunctionsScreen(),
                      ),
                    )
                  : Container()
              : Container()
        ]),
      ),
    );
  }

  Widget _openDrawer() {
    return Builder(builder: (BuildContext context) {
      return Container(
        child: GestureDetector(
          onTap: () => Scaffold.of(context).openDrawer(),
          child: Container(
            child: Icon(
              Icons.menu,
              color: ConstValues.blueColor,
              size: 32,
            ),
          ),
        ),
      );
    });
  }

  Widget _gameOne() {
    return Flexible(
        child: GoColorIcon(
      showDashboard: true,
    ));
  }

  Widget _gameTwo() {
    return Flexible(
        child: GoSpeedIcon(
      showDashboard: true,
    ));
  }

  Widget _gameThree() {
    return Flexible(
        child: GoMatrixIcon(
      showDashboard: true,
    ));
  }

  @override
  void dispose() {
    print('$_key Dispose invoked');
    super.dispose();
  }
}
