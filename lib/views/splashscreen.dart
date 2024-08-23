import 'package:flutter/material.dart';
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:final_project/routes/routes.dart';
import 'package:final_project/routes/routes_generator.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FlutterSplashScreen.scale(
      backgroundColor: Colors.black,
      childWidget: SizedBox(
        height: 200,
        width: 200,
        child: Image.asset("assets/images/logo.png"),
      ),
      animationDuration: const Duration(milliseconds: 1000),
      onAnimationEnd: () => debugPrint("On Fade In End"),
    ));
  }
}
