import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../blocs/dashboard/dashboard_cubit.dart';
import '../../constants/app_context.dart';
import '../../constants/constant_export.dart';
import '../../constants/utilities.dart';
import '../../models/sensorListDashboard.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/required_text.dart';

class HomeFragment extends StatefulWidget {
  final VoidCallback goToSearch;

  const HomeFragment(this.goToSearch, {super.key});

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class SalesData {
  final int month;
  final int sales;

  SalesData(this.month, this.sales);
}

class _HomeFragmentState extends State<HomeFragment> {
  TextEditingController searchCont = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  DropDownValues? _selectTitle;
  final format = DateFormat("yyyy/MM/dd");
  String entryTotal = "";
  String entryTotalCurrent = "";
  String exitTotal = "";
  String exitTotalCurrent = "";
  String peakHour = "";
  String peakHourCurrent = "";
  String avgDwellTime = "";
  String maxDwellTime = "";
  String startTime = "";
  bool startOccupancyToday = true;
  String endTime = "";
  String sensorIdValue = "";
  List<OccupancyData> occupancyDataTodayList = [];
  @override
  void initState() {
    super.initState();
    startTime = getCurrentDateTimeAsString();
    endTime = getLastWeekInitial();
    context.read<DashboardCubit>().loadDropdownList();
    context.read<DashboardCubit>().occupancyList();
  }

  @override
  void dispose() {
    _dobController.dispose();
    super.dispose();
  }

  String getCurrentDateTimeAsString() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyyMMdd').format(now);
    return formattedDate;
  }

  String getLastWeekInitial() {
    DateTime now = DateTime.now();
    DateTime nextDay = now.subtract(const Duration(days: 7));
    String nextDayString = DateFormat('yyyyMMdd').format(nextDay);
    return nextDayString;
  }

  String getLastWeekEndTime(DateTime selectedDateTime) {
    DateTime nextDay = selectedDateTime.subtract(const Duration(days: 7));
    String nextDayString = DateFormat('yyyyMMdd').format(nextDay);
    return nextDayString;
  }

  void callAPIMethod(String sT, String eT, String sId) {
    context.read<DashboardCubit>().dashboardSensorList(sId, sT, eT);
  }

  String convertTo12HourFormat(String time24) {
    try {
      if (time24 != "0") {
        final DateFormat formatter = DateFormat('HH');
        final DateTime dateTime = formatter.parse(time24);
        final String formattedTime = DateFormat('h a').format(dateTime);
        return formattedTime;
      } else {
        return '0';
      }
    } catch (e) {
      print('Error parsing time: $e');
      return '0'; // Return a default value or handle the error appropriately
    }
  }

  List<ChartData> _convertToChartData(List<HourlyEntry>? hourlyEntry) {
    List<ChartData> chartDataList = [];
    if (hourlyEntry != null) {
      for (HourlyEntry entry in hourlyEntry) {
        chartDataList.add(ChartData(
          hour: entry.hour ?? "",
          inValue: entry.inValue ?? 0,
          outValue: entry.outValue ?? 0,
        ));
      }
    }
    return chartDataList;
  }

  List<ChartData> _convertToChartDataOccupancy(List<HourlyEntry>? hourlyEntry) {
    List<ChartData> chartDataList = [];
    if (hourlyEntry != null) {
      for (HourlyEntry entry in hourlyEntry) {
        chartDataList.add(ChartData(
          hour: entry.hour ?? "",
          inValue: entry.inValue! - entry.outValue! ?? 0,
          outValue: entry.outValue ?? 0,
        ));
      }
    }
    return chartDataList;
  }

  List<ChartData> _convertToChartDataOccupancyLastWeek(
      List<HourlyEntry>? hourlyEntry) {
    List<ChartData> chartDataList = [];
    if (hourlyEntry != null) {
      int previousTotal = 0;
      for (HourlyEntry entry in hourlyEntry) {
        int currentIn = entry.inValue!;
        int currentOut = entry.outValue!;
        // int currentTotal = previousTotal + currentIn - currentOut;
        int currentTotal = (previousTotal + currentIn - currentOut)
            .clamp(0, double.infinity)
            .toInt();
        chartDataList.add(ChartData(
          hour: entry.hour ?? "",
          inValue: currentTotal ?? 0,
          outValue: entry.outValue ?? 0,
        ));
        previousTotal = currentTotal;
      }
    }
    return chartDataList;
  }

  List<ChartData> chartHourEntry = [];
  List<ChartData> chartHourEntryLastWeek = [];
  List<ChartData> chartHourExit = [];
  List<ChartData> chartHourExitLastWeek = [];
  List<ChartData> chartHourOccupancy = [];
  List<ChartData> chartHourOccupancyLastWeek = [];

  int maxValueHourEntry = 200;
  int maxValueOccupancy = 0;
  int intervalHourEntry = 40;

  int maxValueHourExit = 200;
  int intervalHourExit = 40;

  int maxValueHourOccupancy = 60;
  int intervalHourOccupancy = 10;

  int roundToNearest(int value, int roundTo) {
    if (value <= 60) {
      return 80;
    } else if (value <= 80) {
      return 120;
    } else if (value <= 100) {
      return 140;
    } else if (value <= 120) {
      return 160;
    } else if (value <= 140) {
      return 180;
    } else if (value <= 150) {
      return 200;
    } else if (value <= 200) {
      return 250;
    } else if (value <= 300) {
      return 350;
    } else if (value <= 350) {
      return 400;
    } else if (value <= 400) {
      return 450;
    } else if (value <= 450) {
      return 500;
    } else if (value <= 500) {
      return 600;
    } else if (value <= 600) {
      return 700;
    } else if (value <= 900) {
      return 1000;
    } else if (value <= 1200) {
      return 1900;
    } else if (value <= 1600) {
      return 2200;
    } else if (value <= 2000) {
      return 2600;
    } else if (value <= 2500) {
      return 3000;
    } else if (value <= 3500) {
      return 4000;
    } else if (value <= 4000) {
      return 5000;
    } else if (value <= 5500) {
      return 7000;
    } else if (value <= 7500) {
      return 9000;
    } else if (value <= 9500) {
      return 10000;
    } else {
      return (value / 50).ceil() * 50; // Round to the nearest multiple of 50
    }
  }

  // Method to handle refresh action
  Future<void> _handleRefresh() async {
    // Simulate a delay for refreshing data (e.g., fetch new data from API)

    callAPIMethod(startTime, endTime, sensorIdValue);
    await Future.delayed(const Duration(seconds: 2));

    // Update the list data
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: BlocConsumer<DashboardCubit, DashboardState>(
        listener: (context, state) {
          if (state is OccupancyInfoLoaded) {
            print("stateeee======== ${state.occupancyData}");
            occupancyDataTodayList = state.occupancyData;
          }
          if (state is DashboardInfoLoaded) {
            _selectTitle = DropDownValues(
              name: AppContext().listDropdown[0].areaName!,
              value: AppContext().listDropdown[0].areaId!,
            );
            try {
              sensorIdValue = AppContext().listDropdown[0].areaId ?? "";
              callAPIMethod(startTime, endTime, sensorIdValue);
            } catch (e) {}
          }
          if (state is DashboardSensorInfoLoaded) {
            entryTotalCurrent =
                state.dashboardSensorListCurrentWeek.entryTotalCurrentweek!;
            entryTotal =
                state.dashboardSensorListLastWeek.entryTotalCurrentweek!;
            exitTotalCurrent =
                state.dashboardSensorListCurrentWeek.exitTotalCurrentweek!;
            exitTotal = state.dashboardSensorListLastWeek.exitTotalCurrentweek!;
            peakHourCurrent =
                state.dashboardSensorListCurrentWeek.peakHourCurrentweek!;
            peakHour = state.dashboardSensorListLastWeek.peakHourCurrentweek!;
            avgDwellTime = state.dashboardSensorListCurrentWeek.avgDwellTime!;
            maxDwellTime = state.dashboardSensorListCurrentWeek.maxDwellTime!;
            //hourly entry
            chartHourEntry = _convertToChartData(
                state.dashboardSensorListCurrentWeek.hourlyEntry);
            chartHourEntryLastWeek = _convertToChartData(
                state.dashboardSensorListLastWeek.hourlyEntry);
            //hourly exit
            chartHourExit = _convertToChartData(
                state.dashboardSensorListCurrentWeek.hourlyExit);
            chartHourExitLastWeek = _convertToChartData(
                state.dashboardSensorListLastWeek.hourlyExit);
            //hourly occupancy
            chartHourOccupancy = _convertToChartDataOccupancyLastWeek(
                state.dashboardSensorListCurrentWeek.hourlyOccupancy);
            chartHourOccupancyLastWeek = _convertToChartDataOccupancyLastWeek(
                state.dashboardSensorListLastWeek.hourlyOccupancy);

            try {
              maxValueHourEntry = chartHourEntry
                  .map((data) => data.inValue)
                  .reduce((a, b) => a > b ? a : b);
              int maxValueHourEntryLastWeek = 200;
              maxValueHourEntryLastWeek = chartHourEntryLastWeek
                  .map((data) => data.inValue)
                  .reduce((a, b) => a > b ? a : b);
              int maxValue = maxValueHourEntry >= maxValueHourEntryLastWeek
                  ? maxValueHourEntry
                  : maxValueHourEntryLastWeek;

              int range = maxValue;
              int roundedRange = roundToNearest(range, 50);
              intervalHourEntry = (roundedRange / 5).ceil();
              maxValueHourEntry = roundToNearest(maxValue, 50);
            } catch (e) {}

            try {
              maxValueHourExit = chartHourExit
                  .map((data) => data.inValue)
                  .reduce((a, b) => a > b ? a : b);
              int maxValueHourExitLastWeek = 200;
              maxValueHourExitLastWeek = chartHourEntryLastWeek
                  .map((data) => data.inValue)
                  .reduce((a, b) => a > b ? a : b);
              int maxValue = maxValueHourExit >= maxValueHourExitLastWeek
                  ? maxValueHourExit
                  : maxValueHourExitLastWeek;
              int range = maxValue;
              int roundedRange = roundToNearest(range, 50);
              intervalHourExit = (roundedRange / 5).ceil();
              maxValueHourExit = roundToNearest(maxValue, 50);
            } catch (e) {}

            try {
              maxValueHourOccupancy = chartHourOccupancy
                  .map((data) => data.inValue)
                  .reduce((a, b) => a > b ? a : b);
              int maxValueHourOccupancyLastWeek = 200;
              maxValueHourOccupancyLastWeek = chartHourOccupancyLastWeek
                  .map((data) => data.inValue)
                  .reduce((a, b) => a > b ? a : b);
              int maxValue =
                  maxValueHourOccupancy >= maxValueHourOccupancyLastWeek
                      ? maxValueHourOccupancy
                      : maxValueHourOccupancyLastWeek;
              print(
                  "maxoccupancy $maxValue ===== $maxValueHourOccupancy ----- $maxValueHourOccupancyLastWeek ");
              maxValueOccupancy = maxValueHourOccupancy;
              int range = maxValue;
              int roundedRange = roundToNearest(range, 50);
              intervalHourOccupancy = (roundedRange / 5).ceil();
              maxValueHourOccupancy = roundToNearest(maxValue, 50);
            } catch (e) {}
          } else if (state is DashboardError) {
            showErrorToast(
                appErrorType: state.appErrorType,
                errorMessage: state.errorMessage);
          }
        },
        builder: (context, state) {
          return LoadingWidget(
            showLoading: state is DashboardLoading,
            child: Scaffold(
              backgroundColor: ThemeConstants.white,
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      10.height,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          dropDownMethod(context),
                          20.height,
                          dateTimeFieldCurrent(context),
                        ],
                      ),
                      15.height,
                      startOccupancyToday && occupancyDataTodayList.isNotEmpty
                          ? Container(
                              width: double.infinity,
                              child: Card(
                                elevation: 2,
                                color: ThemeConstants.exitTotalColorCode,
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 6.0, top: 5, bottom: 2, right: 10),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            text: 'Occupancy',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge!,
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: "(Current Occupancy)",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge,
                                              ),
                                            ],
                                          ),
                                        ),
                                        ...occupancyDataTodayList
                                            .map((occupancyData) {
                                          return RichText(
                                            text: TextSpan(
                                              text:
                                                  '${occupancyData.areaName!} : ',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!,
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: occupancyData.occupancy,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          );
                                          // Text(
                                          //   '${occupancyData.areaName!} : ${occupancyData.occupancy!}',
                                          //   style: Theme.of(context)
                                          //       .textTheme
                                          //       .bodyMedium,
                                          // );
                                        }).toList(),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      startOccupancyToday ? 10.height : 1.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          cardWidget(
                            "Entry Total: $entryTotalCurrent",
                            "Last Week: $entryTotal ",
                            ThemeConstants.entryTotalColorCode,
                          ),
                          cardWidget(
                            "Peak Hour: ${convertTo12HourFormat(peakHourCurrent)}",
                            "Last Week: ${convertTo12HourFormat(peakHour)}",
                            ThemeConstants.peakHourColorCode,
                          ),
                        ],
                      ),
                      10.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Card(
                            elevation: 2,
                            color: ThemeConstants.avgDwellTimeColorCode,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 6.0, top: 5, bottom: 2, right: 2),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "AvgDwellTime: $avgDwellTime(Min)",
                                    maxLines: 1,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  5.height,
                                  Text(
                                    "MaxDwellTime: $maxDwellTime(Min)",
                                    maxLines: 1,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                            fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      10.height,
                      SfCartesianChart(
                        title: ChartTitle(
                          text: 'Hourly Entry',
                          alignment: ChartAlignment.near,
                        ),
                        enableMultiSelection: true,
                        legend: Legend(
                          isVisible: true,
                          position: LegendPosition.bottom,
                        ),
                        primaryXAxis: CategoryAxis(
                          majorGridLines: const MajorGridLines(
                            width: 1,
                            dashArray: [1, 5],
                            color: Colors.grey,
                          ),
                          labelPlacement: LabelPlacement.onTicks,
                          labelPosition: ChartDataLabelPosition.outside,
                        ),
                        primaryYAxis: NumericAxis(
                          opposedPosition: false,
                          axisLine: const AxisLine(width: 1),
                          majorTickLines: const MajorTickLines(size: 1),
                          minimum: 0,
                          maximum: maxValueHourEntry.toDouble(),
                          interval: intervalHourEntry.toDouble(),
                        ),
                        series: <ChartSeries<ChartData, String>>[
                          SplineSeries<ChartData, String>(
                            name: "Today",
                            color: Colors.blue.shade400,
                            dataSource: chartHourEntry,
                            xValueMapper: (ChartData data, _) =>
                                "${data.hour.toString()}hr",
                            yValueMapper: (ChartData data, _) => data.inValue,
                            markerSettings: MarkerSettings(
                              isVisible: true,
                              height: 3,
                              width: 3,
                              borderColor: Colors.red.shade300,
                              shape: DataMarkerType.circle,
                            ),
                          ),
                          SplineSeries<ChartData, String>(
                            name: "Last Week",
                            color: Colors.grey.shade400,
                            dataSource: chartHourEntryLastWeek,
                            xValueMapper: (ChartData data, _) =>
                                "${(data.hour).toString()}hr",
                            yValueMapper: (ChartData data, _) => data.inValue,
                            markerSettings: MarkerSettings(
                              isVisible: true,
                              height: 3,
                              width: 3,
                              borderColor: Colors.green.shade300,
                              shape: DataMarkerType.circle,
                            ),
                          ),
                        ],
                        trackballBehavior: TrackballBehavior(
                          enable: true,
                          tooltipDisplayMode:
                              TrackballDisplayMode.floatAllPoints,
                          tooltipSettings:
                              const InteractiveTooltip(enable: true),
                          lineType: TrackballLineType.vertical,
                          shouldAlwaysShow: false,
                          activationMode: ActivationMode.singleTap,
                        ),
                      ),
                      20.height,
                      SfCartesianChart(
                        title: ChartTitle(
                          text: 'Hourly Exit',
                          alignment: ChartAlignment.near,
                        ),
                        primaryXAxis: CategoryAxis(
                          majorGridLines: const MajorGridLines(
                            width: 1,
                            dashArray: [1, 5],
                            color: Colors.grey,
                          ),
                          labelPlacement: LabelPlacement.onTicks,
                        ),
                        primaryYAxis: NumericAxis(
                          axisLine: const AxisLine(width: 2),
                          majorGridLines: const MajorGridLines(width: 1),
                          majorTickLines: const MajorTickLines(size: 5),
                          minimum: 0,
                          maximum: maxValueHourExit.toDouble(),
                          interval: intervalHourExit.toDouble(),
                        ),
                        legend: Legend(
                            isVisible: true, position: LegendPosition.bottom),
                        series: <ChartSeries<ChartData, String>>[
                          SplineSeries<ChartData, String>(
                            name: "Today",
                            color: Colors.pink.shade300,
                            dataSource: chartHourExit,
                            xValueMapper: (ChartData data, _) =>
                                "${data.hour.toString()}hr",
                            yValueMapper: (ChartData data, _) => data.outValue,
                            markerSettings: MarkerSettings(
                              isVisible: true,
                              height: 3, // Reduce the size of the marker
                              width: 3, // Reduce the size of the marker
                              borderColor: Colors.red.shade300,
                              shape: DataMarkerType.circle,
                            ),
                          ),
                          SplineSeries<ChartData, String>(
                            name: "Last Week",
                            color: Colors.grey.shade400,
                            dataSource: chartHourExitLastWeek,
                            xValueMapper: (ChartData data, _) =>
                                "${data.hour.toString()}hr",
                            yValueMapper: (ChartData data, _) => data.outValue,
                            markerSettings: MarkerSettings(
                              isVisible: true,
                              height: 3, // Reduce the size of the marker
                              width: 3, // Reduce the size of the marker
                              borderColor: Colors.green.shade300,
                              shape: DataMarkerType.circle,
                            ),
                          ),
                        ],
                        // tooltipBehavior: TooltipBehavior(
                        //   enable: true,
                        //   format: 'point.x \n Count - point.y',
                        // ),
                        trackballBehavior: TrackballBehavior(
                          enable: true,
                          tooltipDisplayMode:
                              TrackballDisplayMode.floatAllPoints,
                          tooltipSettings:
                              const InteractiveTooltip(enable: true),
                          lineType: TrackballLineType.vertical,
                          shouldAlwaysShow: false,
                          activationMode: ActivationMode.singleTap,
                        ),
                      ),
                      20.height,
                      SfCartesianChart(
                        title: ChartTitle(
                          text: 'Hourly Occupancy',
                          alignment: ChartAlignment.near,
                        ),
                        primaryXAxis: CategoryAxis(
                          majorGridLines: const MajorGridLines(
                            width: 1,
                            dashArray: [1, 5],
                            color: Colors.grey,
                          ),
                          labelPlacement: LabelPlacement.onTicks,
                        ),
                        primaryYAxis: NumericAxis(
                          axisLine: const AxisLine(width: 2),
                          majorGridLines: const MajorGridLines(width: 1),
                          majorTickLines: const MajorTickLines(size: 5),
                          minimum: 0,
                          maximum: maxValueHourOccupancy.toDouble(),
                          interval: intervalHourOccupancy.toDouble(),
                        ),
                        legend: Legend(
                            isVisible: true, position: LegendPosition.bottom),
                        series: <ChartSeries<ChartData, String>>[
                          SplineSeries<ChartData, String>(
                            name: "Today",
                            color: Colors.yellow.shade800,
                            dataSource: chartHourOccupancy,
                            xValueMapper: (ChartData data, _) =>
                                "${data.hour.toString()}hr",
                            yValueMapper: (ChartData data, _) => data.inValue,
                            markerSettings: MarkerSettings(
                              isVisible: true,
                              height: 2, // Reduce the size of the marker
                              width: 2, // Reduce the size of the marker
                              borderColor: Colors.green.shade800,
                              shape: DataMarkerType.circle,
                            ),
                          ),
                          SplineSeries<ChartData, String>(
                            name: "Last Week",
                            color: Colors.grey.shade400,
                            dataSource: chartHourOccupancyLastWeek,
                            xValueMapper: (ChartData data, _) =>
                                "${data.hour.toString()}hr",
                            yValueMapper: (ChartData data, _) => data.inValue,
                            markerSettings: MarkerSettings(
                              isVisible: true,
                              height: 3,
                              width: 3,
                              borderColor: Colors.red.shade300,
                              shape: DataMarkerType.circle,
                            ),
                          ),
                        ],
                        trackballBehavior: TrackballBehavior(
                          enable: true,
                          tooltipDisplayMode:
                              TrackballDisplayMode.floatAllPoints,
                          tooltipSettings:
                              const InteractiveTooltip(enable: true),
                          lineType: TrackballLineType.vertical,
                          shouldAlwaysShow: false,
                          activationMode: ActivationMode.singleTap,
                        ),
                        // tooltipBehavior: TooltipBehavior(
                        //   enable: true,
                        //   format: 'point.x \n Count - point.y',
                        // ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  DateTimeField dateTimeFieldCurrent(BuildContext context) {
    return DateTimeField(
      initialValue: DateTime.now(),
      decoration: InputDecoration(
        hintStyle: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: ThemeConstants.grey),
        labelStyle: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: ThemeConstants.grey),
        label: const RequiredText(
          label: "Choose Date",
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: ThemeConstants.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: ThemeConstants.black),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: ThemeConstants.black),
        ),
        hintText: "dd/mm/yyyy",
        suffixIcon: Image.asset(
          'assets/pngs/calendaricon.png',
          width: 24,
          height: 24,
        ),
      ),
      format: format,
      onShowPicker: (context, currentValue) async {
        final DateTime? selectedDate =
            await showCustomDatePicker(context, currentValue);
        if (selectedDate != null) {
          final selectedDateTime = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
          );
          final formatDate = DateFormat('yyyyMMdd').format(selectedDateTime);
          // final endDate = DateFormat('yyyyMMdd').format(selectedDateTime);
          startTime = formatDate;

          final now = DateTime.now();
          if (selectedDateTime.year == now.year &&
              selectedDateTime.month == now.month &&
              selectedDateTime.day == now.day) {
            startOccupancyToday = true;
            context.read<DashboardCubit>().occupancyList();
          } else {
            startOccupancyToday = false;
          }

          endTime = getLastWeekEndTime(selectedDateTime);
          callAPIMethod(startTime, endTime, sensorIdValue);
        }
        return selectedDate;
      },
    );
  }

  Future<DateTime?> showCustomDatePicker(
      BuildContext context, DateTime? currentValue) async {
    final DateTime? selectedDate = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        final DateTime initialDate = currentValue ?? DateTime.now();
        DateTime? selectedDate;
        return Dialog(
          child: CalendarDatePicker(
            initialDate: initialDate,
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
            onDateChanged: (DateTime date) {
              selectedDate = date;
              Navigator.of(context).pop(selectedDate);
            },
          ),
        );
      },
    );
    return selectedDate;
  }

  DropdownSearch<DropDownValues?> dropDownMethod(BuildContext context) {
    return DropdownSearch<DropDownValues?>(
      items: AppContext()
          .listDropdown
          .map((item) => DropDownValues(
                value: item.areaId,
                name: item.areaName!,
              ))
          .toList(),
      popupProps: PopupProps.menu(
        constraints: const BoxConstraints(
          maxHeight: 150,
        ),
        itemBuilder: (context, DropDownValues? item, isSelected) => Padding(
          padding: const EdgeInsets.symmetric(
              vertical: AppSizeConstants.screenVertical,
              horizontal: AppSizeConstants.screenHorizontal),
          child: Text(
            item!.name,
            style: _selectTitle == item
                ? Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.apply(color: ThemeConstants.primaryColor)
                : Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        menuProps: const MenuProps(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(AppSizeConstants.xtralargeSpacing),
            ),
          ),
        ),
      ),
      validator: (value) => value == null ? AppConstants.selectTitle : null,
      onChanged: (DropDownValues? value) {
        _selectTitle = value;
        sensorIdValue = _selectTitle!.value;
        callAPIMethod(startTime, endTime, sensorIdValue);
      },
      selectedItem: _selectTitle,
      itemAsString: (DropDownValues? item) => item!.name,
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: AppStyles.customInputDecoration(
          context,
          label: const RequiredText(
            label: AppConstants.selectTitle,
          ),
        ),
      ),
    );
  }

  Widget cardWidget(String amt, String text2, Color cardColor) => Expanded(
        child: Card(
          elevation: 2,
          color: cardColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 6.0, top: 5, bottom: 2, right: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  amt,
                  maxLines: 1,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                5.height,
                Text(
                  text2,
                  maxLines: 1,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
        ),
      );

  Widget cardWidgetDwellTime(String text1, String text2, Color cardColor) =>
      Expanded(
        child: Card(
          elevation: 2,
          color: cardColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(text1),
                15.height,
                Text(text2),
              ],
            ),
          ),
        ),
      );

  Container logoEndCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      child: Row(children: [
        // Image.asset(
        //   "assets/logo/seek_logo.png",
        //   height: 72,
        //   width: 120,
        // ),
        Gap(15.h),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "#India Job's App",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            5.height,
            Text(
              "Trusted by Jobseekers",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            5.height,
            RichText(
              text: TextSpan(
                text: 'Made in ',
                style: Theme.of(context).textTheme.titleSmall,
                children: <TextSpan>[
                  TextSpan(
                    text: "INDIA",
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: ThemeConstants.primaryColor),
                  ),
                  TextSpan(
                      text: " for the ",
                      style: Theme.of(context).textTheme.titleSmall),
                  TextSpan(
                    text: "WORLD",
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: ThemeConstants.primaryColor),
                  ),
                ],
              ),
            ),
          ],
        )
      ]),
    );
  }
}

class ChartData {
  final String hour;
  final int inValue;
  final int outValue;

  ChartData(
      {required this.hour, required this.inValue, required this.outValue});
}
