import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'constants/app_title.dart';
import 'di/get_it.dart';
import 'routes/route_generator.dart';
import 'theme/app_theme.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final RouteGenerator _routeGenerator = getItInstance<RouteGenerator>();
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (_, __) => MaterialApp(
        title: AppTitle.appTitle,
        theme: AppTheme.buildTheme(context),
        themeMode: ThemeMode.light,
        initialRoute: Routes.initial,
        onGenerateRoute: _routeGenerator.generateRoute,
      ),
    );
  }
}
