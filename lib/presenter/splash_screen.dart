import 'package:flutter/material.dart';
import 'package:whizzy/constants/app_context.dart';
import 'package:whizzy/core/preference_helper.dart';

import '../constants/theme_constants.dart';
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
        body: Center(
          child: Text(
            "Whizzy People Count",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
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
        () => Navigator.pushNamed(
          context,
          Routes.dashboard,
        ),
      );
    } else {
      Future.delayed(
        const Duration(seconds: 2),
        () => Navigator.pushNamed(
          context,
          Routes.loginScreen,
        ),
      );
    }
  }
}
