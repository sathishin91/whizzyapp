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
import '../../widgets/custom_button.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/required_text.dart';

class HomeFragment extends StatefulWidget {
  final VoidCallback goToSearch;

  const HomeFragment(this.goToSearch, {super.key});
  // const HomeFragment({required this.goToSearch}) : super(key: key);

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class SalesData {
  final String month;
  final int sales;

  SalesData(this.month, this.sales);
}

class _HomeFragmentState extends State<HomeFragment> {
  TextEditingController searchCont = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  DropDownValues? _selectTitle;
  final format = DateFormat("yyyy/MM/dd");
  String entryTotal = "";
  String exitTotal = "";
  String peakHour = "";
  String avgDwellTime = "";
  String maxDwellTime = "";
  String startTime = "";
  String endTime = "";
  String sensorIdValue = "";
  @override
  void initState() {
    super.initState();
    startTime = getCurrentDateTimeAsString();
    try {
      sensorIdValue = AppContext().listDropdown[0].areaId ?? "";
      callAPIMethod(startTime, startTime, sensorIdValue);
    } catch (e) {}
  }

  @override
  void dispose() {
    _dobController.dispose();
    super.dispose();
  }

  String getCurrentDateTimeAsString() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyyMMddHH').format(now);
    return "${formattedDate}0000";
  }

  String getNextDayAsString(DateTime selectedDateTime) {
    DateTime nextDay = selectedDateTime.add(const Duration(days: 1));
    String nextDayString = DateFormat('yyyyMMdd').format(nextDay);
    return "${nextDayString}235959";
  }

  void callAPIMethod(String sT, String eT, String sId) {
    context.read<DashboardCubit>().dashboardSensorList(sId, sT, eT);
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

  List<ChartData> chartHourEntry = [];
  List<ChartData> chartHourExit = [];
  List<ChartData> chartHourOccupancy = [];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardCubit, DashboardState>(
      listener: (context, state) {
        if (state is DashboardSensorInfoLoaded) {
          final String l1 = state.dashboardSensorList.entryTotalLastweek!;
          entryTotal = state.dashboardSensorList.entryTotalLastweek!;
          exitTotal = state.dashboardSensorList.exitTotalLastweek!;
          peakHour = state.dashboardSensorList.peakHourLastweek!;
          avgDwellTime = state.dashboardSensorList.avgDwellTime!;
          maxDwellTime = state.dashboardSensorList.maxDwellTime!;
          chartHourEntry =
              _convertToChartData(state.dashboardSensorList.hourlyEntry);
          chartHourExit =
              _convertToChartData(state.dashboardSensorList.hourlyExit);
          chartHourOccupancy =
              _convertToChartData(state.dashboardSensorList.hourlyOccupancy);
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
                        DropdownSearch<DropDownValues?>(
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
                            itemBuilder:
                                (context, DropDownValues? item, isSelected) =>
                                    Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: AppSizeConstants.screenVertical,
                                  horizontal:
                                      AppSizeConstants.screenHorizontal),
                              child: Text(
                                item!.name,
                                style: _selectTitle == item
                                    ? Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.apply(
                                            color: ThemeConstants.primaryColor)
                                    : Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            menuProps: const MenuProps(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(
                                      AppSizeConstants.xtralargeSpacing),
                                ),
                              ),
                            ),
                          ),
                          validator: (value) =>
                              value == null ? AppConstants.selectTitle : null,
                          onChanged: (DropDownValues? value) {
                            _selectTitle = value;
                            sensorIdValue = _selectTitle!.value;
                            callAPIMethod(startTime, endTime, sensorIdValue);
                          },
                          selectedItem: _selectTitle,
                          itemAsString: (DropDownValues? item) => item!.name,
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration:
                                AppStyles.customInputDecoration(
                              context,
                              label: const RequiredText(
                                label: AppConstants.selectTitle,
                              ),
                            ),
                          ),
                        ),
                        20.height,
                        DateTimeField(
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
                              borderSide:
                                  const BorderSide(color: ThemeConstants.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  const BorderSide(color: ThemeConstants.black),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  const BorderSide(color: ThemeConstants.black),
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
                            final selectedDate = await showDatePicker(
                              context: context,
                              firstDate: DateTime(1900),
                              initialDate: currentValue ?? DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                            if (selectedDate != null) {
                              // final selectedTime = await showTimePicker(
                              //   context: context,
                              //   initialTime: TimeOfDay.fromDateTime(
                              //       currentValue ?? DateTime.now()),
                              // );
                              // if (selectedTime != null) {
                              final selectedDateTime = DateTime(
                                selectedDate.year,
                                selectedDate.month,
                                selectedDate.day,
                              );
                              final formatDate = DateFormat('yyyyMMddHH')
                                  .format(selectedDateTime);
                              startTime = "${formatDate}0000";
                              endTime = getNextDayAsString(selectedDateTime);
                              callAPIMethod(startTime, endTime, sensorIdValue);
                              return selectedDateTime;
                              // }
                            }
                            // Return the currentValue if the user cancels
                            return currentValue;
                          },
                        ),
                      ],
                    ),
                    15.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        cardWidget(entryTotal, "Entry Total\nLast Week ",
                            ThemeConstants.entryTotalColorCode),
                        cardWidget(exitTotal, "Exit Total\nLast Week ",
                            ThemeConstants.exitTotalColorCode),
                      ],
                    ),
                    10.height,
                    Row(
                      children: [
                        cardWidget(peakHour, "Peak Hour\nLast Week ",
                            ThemeConstants.peakHourColorCode),
                        cardWidgetDwellTime(
                            "\nAvgDwellTime: $avgDwellTime",
                            "MaxDwellTime: $maxDwellTime ",
                            ThemeConstants.avgDwellTimeColorCode),
                      ],
                    ),
                    10.height,
                    SfCartesianChart(
                      title: ChartTitle(
                        text: 'Hourly Entry',
                        alignment: ChartAlignment.near,
                      ),
                      primaryXAxis: CategoryAxis(
                        majorGridLines: const MajorGridLines(width: 0),
                        majorTickLines: const MajorTickLines(width: 0),
                        interval: 0.2,
                      ),
                      primaryYAxis: NumericAxis(
                        axisLine: const AxisLine(width: 2),
                        majorGridLines: const MajorGridLines(width: 1),
                        majorTickLines: const MajorTickLines(size: 5),
                        minimum: 0,
                        maximum: 400,
                        interval: 50,
                      ),
                      series: <CartesianSeries<ChartData, String>>[
                        ColumnSeries<ChartData, String>(
                          width: 0.5,
                          spacing: 0.2,
                          dataSource: chartHourEntry,
                          xValueMapper: (ChartData data, _) =>
                              "${data.hour.toString()}hr",
                          yValueMapper: (ChartData data, _) => data.inValue,
                        ),
                        ColumnSeries<ChartData, String>(
                          width: 0.5,
                          spacing: 0.2,
                          dataSource: chartHourEntry,
                          xValueMapper: (ChartData data, _) =>
                              "${data.hour.toString()}hr",
                          yValueMapper: (ChartData data, _) => data.outValue,
                        ),
                      ],
                    ),
                    20.height,
                    SfCartesianChart(
                      title: ChartTitle(
                        text: 'Hourly Exit',
                        alignment: ChartAlignment.near,
                      ),
                      primaryXAxis: CategoryAxis(
                        majorGridLines: const MajorGridLines(width: 0),
                        majorTickLines: const MajorTickLines(width: 0),
                        interval: 0.2,
                      ),
                      primaryYAxis: NumericAxis(
                        axisLine: const AxisLine(width: 2),
                        majorGridLines: const MajorGridLines(width: 1),
                        majorTickLines: const MajorTickLines(size: 5),
                        minimum: 0,
                        maximum: 400,
                        interval: 50,
                      ),
                      series: <CartesianSeries<ChartData, String>>[
                        ColumnSeries<ChartData, String>(
                          width: 0.5,
                          spacing: 0.2,
                          dataSource: chartHourExit,
                          xValueMapper: (ChartData data, _) =>
                              "${data.hour.toString()}hr",
                          yValueMapper: (ChartData data, _) => data.inValue,
                        ),
                        ColumnSeries<ChartData, String>(
                          width: 0.5,
                          spacing: 0.2,
                          dataSource: chartHourExit,
                          xValueMapper: (ChartData data, _) =>
                              "${data.hour.toString()}hr",
                          yValueMapper: (ChartData data, _) => data.outValue,
                        ),
                      ],
                    ),
                    20.height,
                    SfCartesianChart(
                      title: ChartTitle(
                        text: 'Hourly Occupancy',
                        alignment: ChartAlignment.near,
                      ),
                      primaryXAxis: CategoryAxis(
                        majorGridLines: const MajorGridLines(width: 0),
                        majorTickLines: const MajorTickLines(width: 0),
                        interval: 0.2,
                      ),
                      primaryYAxis: NumericAxis(
                        axisLine: const AxisLine(width: 2),
                        majorGridLines: const MajorGridLines(width: 1),
                        majorTickLines: const MajorTickLines(size: 5),
                        minimum: 0,
                        maximum: 400,
                        interval: 50,
                      ),
                      series: <CartesianSeries<ChartData, String>>[
                        ColumnSeries<ChartData, String>(
                          width: 0.5,
                          spacing: 0.2,
                          dataSource: chartHourOccupancy,
                          xValueMapper: (ChartData data, _) =>
                              "${data.hour.toString()}hr",
                          yValueMapper: (ChartData data, _) => data.inValue,
                        ),
                        ColumnSeries<ChartData, String>(
                          width: 0.5,
                          spacing: 0.2,
                          dataSource: chartHourOccupancy,
                          xValueMapper: (ChartData data, _) =>
                              "${data.hour.toString()}hr",
                          yValueMapper: (ChartData data, _) => data.outValue,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
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
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  amt,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                15.height,
                Text(text2),
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

  void _showRadioBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        int selectedOption = 1; // Initialize the selected option

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Select an Option',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  RadioListTile<int>(
                    title: Text('Relevant Jobs',
                        style: Theme.of(context).textTheme.titleSmall),
                    value: 1,
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value!;
                      });
                    },
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: -1.0, horizontal: 8.0),
                    dense: true,
                  ),
                  RadioListTile<int>(
                    title: Text('Salary - Hight to low',
                        style: Theme.of(context).textTheme.titleSmall),
                    value: 2,
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value!;
                      });
                    },
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: -1.0, horizontal: 8.0),
                    dense: true,
                  ),
                  RadioListTile<int>(
                    title: Text(
                      'Salary - Latest to oldest',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    value: 3,
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value!;
                      });
                    },
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: -1.0, horizontal: 8.0),
                    dense: true,
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomButton(
                        buttonWidth: 150,
                        color: Colors.white,
                        onPressed: () {
                          setState(() {
                            selectedOption = 0; // Clear the selection
                          });
                        },
                        title: "Clear",
                      ),
                      CustomButton(
                        buttonWidth: 150,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        title: 'Apply',
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String selectedOption = 'Option 1'; // Default selection
  List<String> filterOptions = [
    'Option 1',
    'Option 2',
    'Option 3',
    'Option 4',
    'Option 5',
  ];

  List<String> selectedOptions = [];

  void _showFilterModalSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Filter Options:'),
                  Wrap(
                    spacing: 8.0,
                    children: filterOptions.map((String option) {
                      return FilterChip(
                        label: Text(option),
                        selected: selectedOptions.contains(option),
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) {
                              selectedOptions.add(option);
                            } else {
                              selectedOptions.remove(option);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16.0),
                  Text('Selected Filter:'),
                  Text(selectedOptions.isEmpty
                      ? 'No Filter Selected'
                      : selectedOptions.join(', ')),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedOptions.clear();
                          });
                        },
                        child: Text('Clear'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Apply your filter logic here
                          Navigator.pop(context); // Close the modal sheet
                        },
                        child: Text('Apply'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
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
