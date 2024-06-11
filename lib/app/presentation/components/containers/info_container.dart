import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/common/common_widgets.dart';

class InfoContainer extends StatefulWidget {
  final String? title;
  final String? description;
  const InfoContainer(
      {super.key, this.title = "Title", this.description = "Description"});

  @override
  State<InfoContainer> createState() => _InfoContainerState(title, description);
}

class _InfoContainerState extends State<InfoContainer>
    with TickerProviderStateMixin {
  static const String _key = "info_container";

  late AnimationController _controller;

  late String? _title;
  late String? _content;

  double _opacity = 0;

  _InfoContainerState(String? title, String? content) {
    _title = title;
    _content = content;
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
    await Future.delayed(const Duration(milliseconds: 300), () async {
      _animate();
    });
  }

  void _animate() {
    if (mounted) {
      _controller.forward();
      setState(() {
        _opacity = 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
        duration: Duration(milliseconds: 1000),
        curve: Curves.fastLinearToSlowEaseIn,
        opacity: _opacity,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
              border: Border.all(width: 2, color: Colors.black),
              borderRadius: BorderRadius.circular(10),
              color: ConstValues.whiteColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: Offset(0, 3),
                ),
              ]),
          child: ListTile(
            dense: true,
            title: Row(
              children: [
                Container(
                  padding: EdgeInsets.only(right: 8),
                  child: Image.asset(
                    "assets/images/logos/brain.png",
                    width: 25,
                  ),
                ),
                Flexible(
                  child: Text(
                    _title!,
                    softWrap: true,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            subtitle: Container(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                _content!,
                textAlign: TextAlign.justify,
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600, fontSize: 12.5),
              ),
            ),
            tileColor: ConstValues.primaryColor,
          ),
        ));
  }

  @override
  void dispose() async {
    print('$_key Dispose invoked');
    _controller.dispose();
    super.dispose();
  }
}
