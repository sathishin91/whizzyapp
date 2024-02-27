import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

import '../blocs/dashboard/dashboard_cubit.dart';
import '../constants/theme_constants.dart';
import '../models/SampleListModel.dart';
import 'fragment/Home_Fragment.dart';
import 'fragment/Profile_Fragment.dart';
import 'fragment/Report_Fragment.dart';
import 'fragment/Notification_Fragment.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<SampleListModel> SampleData = [];
  int selectedIndex = 0;
  String pageTitle = "Jobs";
  DateTime? _lastPressedAt;

  @override
  void initState() {
    super.initState();
    bottomNavMethod();
    context.read<DashboardCubit>().loadDropdownList();
  }

  // Define the callback function here
  void goToSearch() {
    setState(() {
      selectedIndex = 1;
      pageTitle = "Search";
    });
  }

  void bottomNavMethod() {
    SampleData.add(
      SampleListModel(
        title: "Home",
        launchWidget: Text("Home View", style: boldTextStyle(size: 24)),
        icon: Icons.home,
        alternateIcon: Icons.home_outlined,
        colors: ThemeConstants.primaryColor,
      ),
    );
    SampleData.add(
      SampleListModel(
        title: "Report",
        launchWidget: Text("Search View", style: boldTextStyle(size: 24)),
        icon: Icons.report,
        alternateIcon: Icons.report_outlined,
        colors: ThemeConstants.primaryColor,
      ),
    );
    SampleData.add(
      SampleListModel(
        title: "Notification",
        launchWidget: Text("Profile View", style: boldTextStyle(size: 24)),
        icon: Icons.notifications_active,
        alternateIcon: Icons.notifications_active_outlined,
        colors: ThemeConstants.primaryColor,
      ),
    );
    SampleData.add(
      SampleListModel(
        title: "Settings",
        launchWidget: Text("Profile View", style: boldTextStyle(size: 24)),
        icon: Icons.account_circle,
        alternateIcon: Icons.account_circle_outlined,
        colors: ThemeConstants.primaryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeFragment(goToSearch),
      const ReportFragment(),
      const NotificationFragment(),
      const ProfileFragment(),
    ];
    return WillPopScope(
      onWillPop: () async {
        if (selectedIndex != 0) {
          setState(() {
            selectedIndex = 0;
            pageTitle = "Jobs";
          });
          return false; // Prevent app from closing
        } else {
          // Handle double press to close app
          DateTime currentTime = DateTime.now();
          if (_lastPressedAt == null ||
              currentTime.difference(_lastPressedAt!) >
                  const Duration(seconds: 2)) {
            // Reset timer if it's been more than 2 seconds
            _lastPressedAt = currentTime;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Press back again to exit')),
            );
            return false; // Prevent app from closing
          } else {
            // Close app if pressed within 2 seconds
            SystemNavigator.pop();
            return false;
          }
        }
      },
      child: Scaffold(
        backgroundColor: ThemeConstants.white,
        appBar: AppBar(
          centerTitle: false,
          title: RichText(
            text: TextSpan(
              text: 'Whizzy People Counting',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: ThemeConstants.primaryColor),
              children: <TextSpan>[
                TextSpan(
                  text: "", //pageTitle,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: ThemeConstants.primaryColor),
                ),
              ],
            ),
          ),
          automaticallyImplyLeading: false,
        ),
        body: pages.elementAt(selectedIndex),
        bottomNavigationBar: BottomAppBar(
          clipBehavior: Clip.hardEdge,
          shape: const CircularNotchedRectangle(),
          notchMargin: 10,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                ...List.generate(
                  SampleData.length,
                  (index) {
                    SampleListModel data = SampleData[index];
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        selectedIndex == index
                            ? Icon(data.icon, size: 24, color: data.colors)
                            : Icon(data.alternateIcon,
                                size: 24, color: Colors.blueGrey[300]),
                        Text(
                          data.title.validate(),
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: selectedIndex == index
                                        ? data.colors
                                        : ThemeConstants.grey.withOpacity(0.4),
                                  ),
                        ),
                      ],
                    ).onTap(() {
                      setState(() {
                        selectedIndex = index;
                        if (selectedIndex == 0) {
                          pageTitle = "Jobs";
                        } else if (selectedIndex == 1) {
                          pageTitle = "Search";
                        } else if (selectedIndex == 2) {
                          pageTitle = "Profile";
                        } else if (selectedIndex == 3) {
                          pageTitle = "Settings";
                        }
                      });
                    }).expand();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
