import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:mobile_app_cognitive_rehabilitation/app/providers/providers.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/buttons/buttons.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/common/common_widgets.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/games/go_color/go_color_screen.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/games/go_color/go_color_details_screen.dart';

class HowToPlayColorScreen extends StatefulWidget {
  static const String howToPlayColorScreenKey = "/how_to_play_color_screen";
  final bool spanish;
  final bool showDashboard;
  final GoColorDifficulty difficulty;

  const HowToPlayColorScreen(
      {super.key,
      this.spanish = false,
      this.showDashboard = false,
      this.difficulty = GoColorDifficulty.Zero});

  @override
  State<HowToPlayColorScreen> createState() =>
      HowToPlayColorScreenState(spanish, showDashboard, difficulty);
}

class HowToPlayColorScreenState extends State<HowToPlayColorScreen>
    with TickerProviderStateMixin {
  late bool _spanish;
  late bool _showDashboard;
  late GoColorDifficulty _difficulty;

  late int _currentPos = 0;
  List<String> listPaths = List<String>.empty();

  Color backgroundColor = Color.fromRGBO(0, 0, 0, .289);
  Color mainColor = ConstValues.pinkColor;
  Color secondaryColor = Color.fromRGBO(255, 255, 255, 1);

  late CarouselController _myCarouselController;

  HowToPlayColorScreenState(
      bool spanish, bool showDashboard, GoColorDifficulty difficulty) {
    _difficulty = difficulty;
    _spanish = spanish;
    _showDashboard = showDashboard;
    _currentPos = 0;
    _myCarouselController = CarouselController();
  }

  @override
  void initState() {
    _getImages();
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) async => await _afterBuild());
  }

  Future<void> _afterBuild() async {}

  Future<void> _goToGoColorDetailsScreen(bool spanish) async {
    await Navigator.of(context).pushReplacementNamed(
        GoColorDetailsScreen.goColorDetailsScreenKey,
        arguments: GoColorScreenArgs(
            difficulty: _difficulty,
            spanish: spanish,
            showDashboard: _showDashboard));
  }

  Future<void> _goToGoColorScreen(bool spanish) async {
    await Navigator.of(context).pushReplacementNamed(
        GoColorScreen.goColorScreenKey,
        arguments: GoColorScreenArgs(
          difficulty: _difficulty,
          spanish: spanish,
          showDashboard: _showDashboard,
          highScore:
              Provider.of<GoColorProvider>(context, listen: false).userProgress,
        ));
  }

  void _onPageChanged(
      BuildContext context, int index, CarouselPageChangedReason reason) {
    setState(() {
      _currentPos = index;
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

    double level = getLevelByColorDifficulty(_difficulty);

    if (level >= 0 && level < 3) {
      listPaths = [
        "assets/images/games/go_color/how_to_play/easy/htp_color_1.jpg",
        "assets/images/games/go_color/how_to_play/easy/htp_color_2.jpg",
        "assets/images/games/go_color/how_to_play/easy/htp_color_3.jpg",
        "assets/images/games/go_color/how_to_play/easy/htp_color_4.jpg",
        "assets/images/games/go_color/how_to_play/easy/htp_color_5.jpg",
        "assets/images/games/go_color/how_to_play/easy/htp_color_6.jpg",
        "assets/images/games/go_color/how_to_play/easy/htp_color_7.jpg",
      ];
    } else if (level >= 3 && level < 7) {
      listPaths = [
        "assets/images/games/go_color/how_to_play/medium/htp_color_1.jpg",
        "assets/images/games/go_color/how_to_play/medium/htp_color_2.jpg",
        "assets/images/games/go_color/how_to_play/medium/htp_color_3.jpg",
        "assets/images/games/go_color/how_to_play/medium/htp_color_4.jpg",
        "assets/images/games/go_color/how_to_play/medium/htp_color_5.jpg",
        "assets/images/games/go_color/how_to_play/medium/htp_color_6.jpg",
        "assets/images/games/go_color/how_to_play/medium/htp_color_7.jpg",
      ];
    } else {
      listPaths = [
        "assets/images/games/go_color/how_to_play/hard/htp_color_1.jpg",
        "assets/images/games/go_color/how_to_play/hard/htp_color_2.jpg",
        "assets/images/games/go_color/how_to_play/hard/htp_color_3.jpg",
        "assets/images/games/go_color/how_to_play/hard/htp_color_4.jpg",
        "assets/images/games/go_color/how_to_play/hard/htp_color_5.jpg",
        "assets/images/games/go_color/how_to_play/hard/htp_color_6.jpg",
        "assets/images/games/go_color/how_to_play/hard/htp_color_7.jpg",
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _goToGoColorDetailsScreen(_spanish);
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: ConstValues.blackColor,
            leading: BackArrow(
              onTap: () async => await _goToGoColorDetailsScreen(_spanish),
              color: ConstValues.goColor,
            ),
            title: Text(
              _spanish ? "Como Jugar" : "How To Play",
              style: GoogleFonts.poppins(
                  fontSize: 24,
                  color: ConstValues.goColor,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.none),
            ),
            actions: [
              GestureDetector(
                onTap: () async => await _goToGoColorScreen(_spanish),
                child: Container(
                  padding: EdgeInsets.only(right: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "skip",
                        style: GoogleFonts.poppins(
                            color: ConstValues.goColor,
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
        _currentPos == 0
            ? Container()
            : Positioned.fill(
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.only(left: 8),
                      child: GestureDetector(
                        onTap: () => _goToPreviousPage(),
                        child: BackArrow(color: ConstValues.myPinkColor),
                      ),
                    )),
              ),
        _currentPos == listPaths.length - 1
            ? Container()
            : Positioned.fill(
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => _goToNextPage(),
                        child: ForwardArrow(color: ConstValues.myPinkColor),
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
        _currentPos == listPaths.length - 1
            ? Positioned(
                bottom: 120,
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
        color: _currentPos == index ? mainColor : secondaryColor,
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
              child: GoColorStartButton(
                text: _spanish ? "Empieza" : "Start",
                onPressed: () async => await _goToGoColorScreen(_spanish),
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
