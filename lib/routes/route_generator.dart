import 'package:WHIZZYPCS/widgets/notification_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/dashboard/dashboard_cubit.dart';
import '../blocs/login/login_cubit.dart';
import '../di/get_it.dart';
import '../presenter/dashboard.dart';
import '../presenter/login_screen.dart';
import '../presenter/port_number_screen.dart';
import '../presenter/splash_screen.dart';

class RouteGenerator {
  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.initial:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
      case Routes.portNumberScreen:
        return MaterialPageRoute(
          builder: (_) => const PortNumberScreen(),
        );
      case Routes.loginScreen:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => getItInstance<LoginCubit>(),
              ),
              BlocProvider(
                create: (context) => getItInstance<DashboardCubit>(),
              ),
            ],
            child: const LoginScreen(),
          ),
        );
      case Routes.dashboard:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getItInstance<DashboardCubit>(),
            child: const Dashboard(),
          ),
        );

      case Routes.notificationView:
        return MaterialPageRoute(
          builder: (_) => const NotificationCardWidget(),
        );
      // case Routes.forgetpassword:
      //   return MaterialPageRoute(
      //     builder: (_) => const ForgetPassword(),
      //   );
    }
    return _errorRoute();
  }

  Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Error'),
          ),
          body: const Center(
            child: Text("ERROR"),
          ),
        );
      },
    );
  }

  Route<dynamic> _comingSoonRoute() => MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: const Text(""),
          ),
          body: const Center(
            child: Text(
              "Coming soon!!",
              style: TextStyle(
                fontSize: 24,
              ),
            ),
          ),
        ),
      );

  void dispose() {}
}

class Routes {
  static const String initial = "/";
  static const String dashboard = "dashboard";
  static const String accountCreation = "accountCreation";
  static const String skillSuggestion = "skillSuggestion";

  static const String basicInfo = "basicInfo";
  static const String educationInfo = "educationInfo";
  static const String experienceInfo = "experienceInfo";
  static const String skillInfo = "skillInfo";

  //login
  static const String portNumberScreen = "portNumberScreen";
  static const String loginScreen = "loginScreen";
  static const String termsandconditions = "termsandconditions";
  static const String forgetpassword = "forgetpassword";
  static const String holdingscreen = "holdingscreen";
  static const String userprofile = "userprofile";
  static const String shiftOfficerScreen = "shiftOfficerScreen";
  static const String postOverviewScreen = "postOverviewScreen";
  static const String patientForm = "patientForm";
  static const String fullpatientForm = "fullpatientForm";

  //apply job
  static const String applyJob = "applyJob";

  static const String notificationView = "notificationView";
}
