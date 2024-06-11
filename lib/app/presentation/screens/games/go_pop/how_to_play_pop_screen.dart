import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:mobile_app_cognitive_rehabilitation/app/providers/providers.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/buttons/buttons.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/common/common_widgets.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/games/go_pop/go_pop_screen.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/games/go_pop/go_pop_details_screen.dart';

class HowToPlayPopScreen extends StatefulWidget {
  static const String howToPlayPopScreenKey = "/how_to_play_pop_screen";
  final bool shine;
  final bool showDashboard;
  final GoPopDifficulty difficulty;

  const HowToPlayPopScreen(
      {super.key,
      this.shine = false,
      this.showDashboard = false,
      this.difficulty = GoPopDifficulty.Zero});

  @override
  State<HowToPlayPopScreen> createState() =>
      HowToPlayPopScreenState(shine, showDashboard, difficulty);
}

class HowToPlayPopScreenState extends State<HowToPlayPopScreen>
    with TickerProviderStateMixin {
  late bool _shine;
  late bool _showDashboard;
  late GoPopDifficulty _difficulty;

  int currentPos = 0;
  List<String> listPaths = List<String>.empty();

  late Color mainColor;
  Color backgroundColor = Color.fromRGBO(0, 0, 0, .289);
  Color secondaryColor = Color.fromRGBO(255, 255, 255, 1);

  late CarouselController _myCarouselController;

  HowToPlayPopScreenState(
      bool shine, bool showDashboard, GoPopDifficulty difficulty) {
    _shine = shine;
    _showDashboard = showDashboard;
    _difficulty = difficulty;
    _myCarouselController = CarouselController();
    mainColor = _shine ? ConstValues.goShineColor : ConstValues.myGreenColor;
  }

  @override
  void initState() {
    _getImages();
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) async => await _afterBuild());
  }

  Future<void> _afterBuild() async {}

  Future<void> _goToGoPopDetailsScreen(bool shine) async {
    await Navigator.of(context).pushReplacementNamed(
        GoPopDetailsScreen.goPopDetailsScreenKey,
        arguments: GoPopScreenArgs(
            difficulty: _difficulty,
            shine: shine,
            showDashboard: _showDashboard));
  }

  Future<void> _goToGoPopScreen(bool shine) async {
    await Navigator.of(context).pushReplacementNamed(GoPopScreen.goPopScreenKey,
        arguments: GoPopScreenArgs(
          difficulty: _difficulty,
          shine: shine,
          showDashboard: _showDashboard,
          highScore:
              Provider.of<GoPopProvider>(context, listen: false).userProgress,
        ));
  }

  void _onPageChanged(
      BuildContext context, int index, CarouselPageChangedReason reason) {
    setState(() {
      currentPos = index;
    });
  }

  void _goToPreviousPage() {
    _myCarouselController.previousPage();
  }

  void _goToNextPage() {
    _myCarouselController.nextPage();
  }

  void _getImages() {
    print("get images");

    double level = getLevelByPopDifficulty(_difficulty);

    if (level >= 0 && level < 3) {
      listPaths = [
        "assets/images/games/go_pop/how_to_play/easy/htp_pop_1.jpg",
        "assets/images/games/go_pop/how_to_play/easy/htp_pop_2.jpg",
        "assets/images/games/go_pop/how_to_play/easy/htp_pop_3.jpg",
        "assets/images/games/go_pop/how_to_play/easy/htp_pop_4.jpg",
        "assets/images/games/go_pop/how_to_play/easy/htp_pop_5.jpg",
      ];
    } else if (level >= 3 && level < 7) {
      listPaths = [
        "assets/images/games/go_pop/how_to_play/medium/htp_pop_1.jpg",
        "assets/images/games/go_pop/how_to_play/medium/htp_pop_2.jpg",
        "assets/images/games/go_pop/how_to_play/medium/htp_pop_3.jpg",
        "assets/images/games/go_pop/how_to_play/medium/htp_pop_4.jpg",
        "assets/images/games/go_pop/how_to_play/medium/htp_pop_5.jpg",
      ];
    } else {
      listPaths = [
        "assets/images/games/go_pop/how_to_play/hard/htp_pop_1.jpg",
        "assets/images/games/go_pop/how_to_play/hard/htp_pop_2.jpg",
        "assets/images/games/go_pop/how_to_play/hard/htp_pop_3.jpg",
        "assets/images/games/go_pop/how_to_play/hard/htp_pop_4.jpg",
        "assets/images/games/go_pop/how_to_play/hard/htp_pop_5.jpg",
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _goToGoPopDetailsScreen(_shine);
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: ConstValues.blackColor,
            leading: BackArrow(
              onTap: () async => await _goToGoPopDetailsScreen(_shine),
              color: _shine ? ConstValues.goShineColor : ConstValues.goPopColor,
            ),
            title: Text(
              "How To Play",
              style: GoogleFonts.poppins(
                  fontSize: 24,
                  color: _shine
                      ? ConstValues.goShineColor
                      : ConstValues.goPopColor,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.none),
            ),
            actions: [
              GestureDetector(
                onTap: () async => await _goToGoPopScreen(_shine),
                child: Container(
                  padding: EdgeInsets.only(right: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "skip",
                        style: GoogleFonts.poppins(
                            color: _shine
                                ? ConstValues.goShineColor
                                : ConstValues.goPopColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 20),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          body: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    double getScreenHeight = MediaQuery.of(context).size.height;
    return Container(
      color: backgroundColor,
      child: Stack(children: [
        Container(
            child: Align(
          alignment: Alignment.bottomCenter,
          child: CarouselSlider(
            options: CarouselOptions(
                height: getScreenHeight,
                scrollDirection: Axis.horizontal,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 6),
                viewportFraction: 1.0,
                enableInfiniteScroll: false,
                pauseAutoPlayInFiniteScroll: true,
                onPageChanged: (index, reason) =>
                    _onPageChanged(context, index, reason)),
            carouselController: _myCarouselController,
            items: listPaths.map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return MyImageView(i);
                },
              );
            }).toList(),
          ),
        )),
        currentPos == 0
            ? Container()
            : Positioned.fill(
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.only(left: 8),
                      child: GestureDetector(
                        onTap: () => _goToPreviousPage(),
                        child: BackArrow(
                            color: _shine
                                ? ConstValues.goShineColor
                                : ConstValues.myGreenColor),
                      ),
                    )),
              ),
        currentPos == listPaths.length - 1
            ? Container()
            : Positioned.fill(
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => _goToNextPage(),
                        child: ForwardArrow(
                            color: _shine
                                ? ConstValues.goShineColor
                                : ConstValues.myGreenColor),
                      ),
                    )),
              ),
        Positioned(
          bottom: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: listPaths.map((url) => _buildIndicators(url)).toList(),
            ),
          ),
        ),
        currentPos == listPaths.length - 1
            ? Positioned(
                bottom: 40,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [_buildStartButton()]),
                ),
              )
            : Container()
      ]),
    );
  }

  Widget _buildIndicators(String url) {
    int index = listPaths.indexOf(url);
    return Container(
      width: 14,
      height: 14,
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(width: 2, color: mainColor),
        color: currentPos == index ? mainColor : secondaryColor,
      ),
    );
  }

  Widget _buildStartButton() {
    return Container(
      padding: EdgeInsets.only(top: 8, left: 16),
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
            child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 150,
              child: GoPopStartButton(
                text: "Start",
                shine: _shine,
                onPressed: () async => await _goToGoPopScreen(_shine),
              ),
            )
          ],
        )),
      ),
    );
  }

  @override
  void dispose() async {
    super.dispose();
  }
}

class MyImageView extends StatelessWidget {
  final String imgPath;

  MyImageView(this.imgPath);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(imgPath),
            fit: BoxFit.fitHeight,
            alignment: Alignment.bottomCenter),
      ),
    );
  }
}
