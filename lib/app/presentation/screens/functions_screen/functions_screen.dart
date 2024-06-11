import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mobile_app_cognitive_rehabilitation/app/providers/providers.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/buttons/buttons.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/snackbars/snackbar.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/common/common_widgets.dart';

class FunctionsScreen extends StatefulWidget {
  static const String functionsScreenKey = "/functions_screen";
  const FunctionsScreen({super.key});

  @override
  State<FunctionsScreen> createState() =>
      _FunctionsScreenState(functionsScreenKey);
}

class _FunctionsScreenState extends State<FunctionsScreen>
    with TickerProviderStateMixin {
  late String _key;

  late AnimationController _controller;
  late DatabaseManager? _database;
  late bool _isLoading;
  late CustomSnackbar _snackBar;

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastLinearToSlowEaseIn,
  );

  _FunctionsScreenState(String functionsScreenKey) {
    _key = functionsScreenKey;
    _database = DatabaseManager();
    _isLoading = false;
    _snackBar =
        CustomSnackbar(duration: 2, backgroundColor: ConstValues.myRedColor);
  }

  @override
  void initState() {
    super.initState();
    print('$_key invoked');
    _controller = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    WidgetsBinding.instance
        .addPostFrameCallback((_) async => await _afterBuild());
  }

  Future<void> _afterBuild() async {
    await Future.delayed(const Duration(milliseconds: 100), () {
      _animate();
    });
  }

  Future<void> _getEffects() async {
    setState(() {
      _isLoading = true;
    });

    await Provider.of<TBIProvider>(context, listen: false).getEffects();

    setState(() {
      _isLoading = false;
    });
  }

  void _getRandomEffect() {
    Provider.of<TBIProvider>(context, listen: false).getRandomEffect();
  }

  Future<void> _updateDocs() async {
    setState(() {
      _isLoading = true;
    });
    bool updateResult = await _database!.updateDocs("");
    if (updateResult) {
      _snackBar.show(context, "Success!");
    } else {
      _snackBar.show(context, "Oops, there was an error!");
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _createUserProgress() async {
    setState(() {
      _isLoading = true;
    });
    bool updateResult = await _database!.createUserProgress("");
    if (updateResult) {
      _snackBar.show(context, "Success!");
    } else {
      _snackBar.show(context, "Oops, there was an error!");
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _animate() {
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: BackArrow(
          onTap: Navigator.of(context).pop,
          color: ConstValues.blueColor,
        ),
        elevation: 0,
        title: Text(
          "Functions",
          style: GoogleFonts.poppins(
              fontSize: 24,
              color: ConstValues.blackColor,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.none),
        ),
        actions: [
          RotationTransition(
            turns: _animation,
            child: ScaleTransition(
              scale: _animation,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(
                  Icons.data_object,
                  size: 32,
                  color: ConstValues.pinkColor,
                ),
              ),
            ),
          )
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
        padding: EdgeInsets.all(16),
        color: ConstValues.whiteColor,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _isLoading
                ? PrimaryButtonLoading()
                : PrimaryButton(text: "Update Docs", onPressed: null),
          ],
        ));
  }
}
