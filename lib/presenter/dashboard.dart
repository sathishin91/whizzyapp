import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../blocs/dashboard/dashboard_cubit.dart';
import '../constants/theme_constants.dart';
import '../models/SampleListModel.dart';
import '../models/sensorModel.dart';
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
  List<ActiveSensorData> sensorDataList = [];
  String colorCode = "";
  @override
  void initState() {
    super.initState();
    bottomNavMethod();
    context.read<DashboardCubit>().activeSensorList();
  }

  String getCurrentDateTimeAsString() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyyMMddHH').format(now);
    return "${formattedDate}0000";
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
          actions: [
            BlocConsumer<DashboardCubit, DashboardState>(
              listener: (context, state) {
                if (state is SensorActiveListInfoLoaded) {
                  colorCode = state.sensorActiveList[0].statusColor!;
                  sensorDataList = state.sensorActiveList;
                }
              },
              builder: (context, state) {
                return GestureDetector(
                  onTap: () {
                    context.read<DashboardCubit>().activeSensorList();
                    showAlignedDialog(
                      context: context,
                      builder: _verticalDrawerBuilder(context, sensorDataList),
                      followerAnchor: Alignment.topLeft,
                      isGlobal: true,
                      transitionsBuilder: (BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation,
                          Widget child) {
                        return SlideTransition(
                          position: Tween(
                                  begin: const Offset(-1, 0),
                                  end: const Offset(0, 0))
                              .animate(animation),
                          child: FadeTransition(
                            opacity: CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOut,
                            ),
                            child: child,
                          ),
                        );
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                      //O-orange R-Red Y-yellow G-Green
                      Icons.sensor_window,
                      color: colorCode == "O"
                          ? Colors.orange
                          : colorCode == "R"
                              ? Colors.red
                              : colorCode == "Y"
                                  ? Colors.yellow
                                  : colorCode == "G"
                                      ? Colors.green
                                      : Colors.red,
                    ),
                  ),
                );
              },
            ),
          ],
          automaticallyImplyLeading: false,
        ),
        body: pages.elementAt(selectedIndex),
        bottomNavigationBar: BottomAppBar(
          color: ThemeConstants.white,
          height: 70,
          clipBehavior: Clip.hardEdge,
          elevation: 2,
          shape: const CircularNotchedRectangle(),
          notchMargin: 10,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 0),
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
                                size: 24,
                                color: const Color.fromARGB(255, 3, 7, 8)),
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

  Widget newRowWidget(BuildContext context, String text1, String text2, text3) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              text1,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              text2,
              maxLines: 5,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              text3,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          )
        ],
      ),
    );
  }

  String getDateTimeString(String dateValue) {
    DateTime parsedDate = DateFormat('yyyy-MM-ddTHH:mm:ss').parse(dateValue);
    String formattedDateString =
        DateFormat('dd-MMM-yyyy HH:mm:ss').format(parsedDate);
    return formattedDateString;
  }

  WidgetBuilder _verticalDrawerBuilder(
    BuildContext context,
    List<ActiveSensorData> sensorList,
  ) {
    return (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.only(top: 50.0, left: 5, right: 5),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            height: 140,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: ThemeConstants.white,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: DefaultTextStyle(
              style: const TextStyle(fontSize: 18, color: Colors.black87),
              child: SingleChildScrollView(
                child: Container(
                  color: Colors.white,
                  // height: screenHeight * 0.2,
                  // width: screenWidth,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          5.height,
                          Text(
                            "Sensor Status",
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          10.height,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: sensorList.asMap().entries.map((entry) {
                              final index = entry.key;
                              final sensor = entry.value;
                              return Column(
                                children: [
                                  newRowWidget(
                                    context,
                                    "${index + 1}.".toString(),
                                    sensor.sensor!.sensorUuid.toString(),
                                    getDateTimeString(
                                        sensor.timestamp.toString()),
                                  ),
                                  if (index != sensorList.length - 1)
                                    const Divider(),
                                ],
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    };
  }
}
