import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:mobile_app_cognitive_rehabilitation/app/providers/providers.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/common/common_widgets.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/games/go_matrix/go_matrix_screen.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/screens/games/go_matrix/go_matrix_details_screen.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/buttons/go_matrix_buttons/go_matrix_start_button.dart';

class HowToPlayMatrixScreen extends StatefulWidget {
  static const String howToPlayMatrixScreenKey = "/how_to_play_matrix_screen";
  final bool showDashboard;
  final GoMatrixDifficulty difficulty;

  const HowToPlayMatrixScreen(
      {super.key,
      this.showDashboard = false,
      this.difficulty = GoMatrixDifficulty.Zero});

  @override
  State<HowToPlayMatrixScreen> createState() =>
      HowToPlayMatrixScreenState(showDashboard, difficulty);
}

class HowToPlayMatrixScreenState extends State<HowToPlayMatrixScreen>
    with TickerProviderStateMixin {
  late bool _showDashboard;
  late GoMatrixDifficulty _difficulty;

  int currentPos = 0;
  List<String> listPaths = List<String>.empty();

  late Color mainColor;
  Color backgroundColor = Color.fromRGBO(0, 0, 0, .289);
  Color secondaryColor = Color.fromRGBO(255, 255, 255, 1);

  late CarouselController _myCarouselController;

  HowToPlayMatrixScreenState(
      bool showDashboard, GoMatrixDifficulty difficulty) {
    _showDashboard = showDashboard;
    _difficulty = difficulty;
    _myCarouselController = CarouselController();
    mainColor = ConstValues.myPurpleColor;
  }

  @override
  void initState() {
    _getImages();
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) async => await _afterBuild());
  }

  Future<void> _afterBuild() async {}

  Future<void> _goToGoMatrixDetailsScreen() async {
    await Navigator.of(context)
        .pushReplacementNamed(GoMatrixDetailsScreen.goMatrixDetailsScreenKey,
            arguments: GoMatrixScreenArgs(
              showDashboard: _showDashboard,
              difficulty: _difficulty,
            ));
  }

  Future<void> _goToGoMatrixScreen() async {
    await Navigator.of(context)
        .pushReplacementNamed(GoMatrixScreen.goMatrixScreenKey,
            arguments: GoMatrixScreenArgs(
              showDashboard: _showDashboard,
              difficulty: _difficulty,
              highScore: Provider.of<GoMatrixProvider>(context, listen: false)
                  .userProgress,
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

    double level = getLevelByMatrixDifficulty(_difficulty);

    if (level >= 0 && level < 3) {
      listPaths = [
        "assets/images/games/go_matrix/how_to_play/easy/htp_matrix_1.jpg",
      ];
    } else if (level >= 3 && level < 7) {
      listPaths = [
        "assets/images/games/go_matrix/how_to_play/medium/htp_matrix_1.jpg",
      ];
    } else {
      listPaths = [
        "assets/images/games/go_matrix/how_to_play/hard/htp_matrix_1.jpg",
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _goToGoMatrixDetailsScreen();
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: ConstValues.blackColor,
            leading: BackArrow(
              onTap: () async => await _goToGoMatrixDetailsScreen(),
              color: ConstValues.goMatrixColor,
            ),
            title: Text(
              "How To Play",
              style: GoogleFonts.poppins(
                  fontSize: 24,
                  color: ConstValues.goMatrixColor,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.none),
            ),
            actions: [
              GestureDetector(
                onTap: () async => await _goToGoMatrixScreen(),
                child: Container(
                  padding: EdgeInsets.only(right: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "skip",
                        style: GoogleFonts.poppins(
                            color: ConstValues.goMatrixColor,
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
                        child: BackArrow(color: ConstValues.myPurpleColor),
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
                        child: ForwardArrow(color: ConstValues.myPurpleColor),
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
              child: GoMatrixStartButton(
                text: "Start",
                onPressed: () async => await _goToGoMatrixScreen(),
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
