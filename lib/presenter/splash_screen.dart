import 'package:flutter/material.dart';

import '../constants/app_context.dart';
import '../constants/theme_constants.dart';
import '../core/preference_helper.dart';
import '../routes/route_generator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    _launchNextScreen();
    return SafeArea(
      child: Scaffold(
        backgroundColor: ThemeConstants.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/pngs/logo.png",
              height: 250,
              width: double.infinity,
            ),
            Text(
              "WHIZZY PCS",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: ThemeConstants.primaryColor,
                    fontSize: 25,
                  ),
            )
          ],
        ),
      ),
    );
  }

  void _launchNextScreen() async {
    bool? accountCreated = await PreferenceHelper.checkIfAccountCreated;
    if (accountCreated == true) {
      AppContext().baseUrl = (await PreferenceHelper.getBaseUrl())!;
      Future.delayed(
        const Duration(seconds: 2),
        () => Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.dashboard,
          (route) => false,
        ),
      );
    } else {
      Future.delayed(
        const Duration(seconds: 2),
        () => Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.loginScreen,
          (route) => false,
        ),
      );
    }
  }
}
