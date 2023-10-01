import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _animationController1;
  late AnimationController _animationController2;
  late Animation<double> _radialTransform;
  late Animation<double> _shadowTransform;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1300))
      ..repeat(reverse: true);
    _animationController1 =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat();
    _animationController2 =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..repeat();
    _radialTransform =
        Tween<double>(begin: 360, end: 0).animate(_animationController1);
    _shadowTransform = Tween<double>(begin: 0, end: 360).animate(
        CurvedAnimation(
            parent: _animationController2, curve: Curves.slowMiddle));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            linearGradientText(
              text: "Gradient Text",
              colors: const [
                Color(0xff386641),
                Color(0xffa7c957),
                Color(0xff386641),
              ],
            ),
            const SizedBox(height: 20),
            AnimatedBuilder(
                animation: _animationController,
                builder: (context, _) {
                  return linearGradientText(
                      text: "Animated Text",
                      colors: [
                        Colors.white,
                        Colors.grey.shade800,
                        Colors.white,
                      ],
                      transformValue: _animationController.value);
                }),
            const SizedBox(height: 20),
            AnimatedBuilder(
                animation: _radialTransform,
                builder: (context, _) {
                  return sweepGradientText(
                      text: 'Sweeping Text',
                      colors: const [
                        Color(0xff7209b7),
                        Color(0xfff72585),
                        Color(0xffffffff),
                      ],
                      transformValue: _radialTransform.value);
                }),
            const SizedBox(height: 20),
            AnimatedBuilder(
                animation: _shadowTransform,
                builder: (context, _) {
                  return sweepGradientText(
                      text: 'Reveal',
                      colors: const [
                        Color(0xffffd100),
                        Color(0xff000000),
                      ],
                      alignment: Alignment.bottomRight,
                      increment: 360,
                      transformValue: _shadowTransform.value);
                }),
          ],
        ),
      ),
    );
  }

  Widget linearGradientText(
      {required String text,
      required List<Color> colors,
      double transformValue = 0.5}) {
    return ShaderMask(
      shaderCallback: (rect) => LinearGradient(
        colors: colors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0, transformValue, 1],
      ).createShader(rect),
      child: Text(
        text,
        style: GoogleFonts.montserrat(
          fontSize: 40,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget sweepGradientText({
    required String text,
    required List<Color> colors,
    Alignment alignment = Alignment.topCenter,
    double transformValue = 0,
    int increment = 180,
  }) {
    return ShaderMask(
      shaderCallback: (rect) => SweepGradient(
        colors: colors,
        tileMode: TileMode.repeated,
        center: alignment,
        startAngle: transformValue * pi / 180,
        endAngle: (transformValue + increment) * pi / 180,
      ).createShader(rect),
      child: Text(
        text,
        style: GoogleFonts.montserrat(
          fontSize: 40,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
