import 'package:flutter/material.dart';
import '../../config/brand.dart';
import '../../theme/app_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(gradient: AppColors.warmGradient),
        child: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(Brand.name,
                style: TextStyle(
                    color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800)),
            SizedBox(height: 20),
            CircularProgressIndicator(color: Colors.white),
          ]),
        ),
      ),
    );
  }
}
