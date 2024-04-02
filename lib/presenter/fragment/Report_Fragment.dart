import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../blocs/dashboard/dashboard_cubit.dart';
import '../../constants/app_context.dart';
import '../../constants/constant_export.dart';
import '../../constants/utilities.dart';
import '../../models/reportModel.dart';
import '../../models/sensorModel.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/required_text.dart';

class ReportFragment extends StatefulWidget {
  final int? selectedIndex;
  const ReportFragment({Key? key, this.selectedIndex}) : super(key: key);

  @override
  State<ReportFragment> createState() => _ReportFragmentState();
}

class _ReportFragmentState extends State<ReportFragment> {
  TextEditingController searchCont = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;
  DropDownValues? _selectTitle;
  List<Map<String, String>> optionData = [];
  List<Map<String, String>> sensorDataId = [];
  List<Sensors>? sensors = [];
  List<String> selectedSensorIds = [];
  List<HourlyValuesRpts>? hourlyValuesRpts = [];
  String startTimeReport = "";
  String endTimeReport = "";
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardCubit, DashboardState>(
      listener: (context, state) {
        if (state is ReportSensorInfoLoaded) {
          hourlyValuesRpts = state.reportModel.hourlyValuesRpts;
        } else if (state is SensorDataInfoLoaded) {
          sensors = state.sensorData.sensors;
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
            body: Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8, right: 8),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    10.height,
                    DropdownSearch<DropDownValues?>(
                      items: [
                        DropDownValues(value: "option", name: "Select"),
                        ...AppContext()
                            .listDropdown
                            .map(
                              (item) => DropDownValues(
                                value: item.areaId,
                                name: item.areaName!,
                              ),
                            )
                            .toList(),
                      ],
                      popupProps: PopupProps.menu(
                        constraints: const BoxConstraints(
                          maxHeight: 150,
                        ),
                        itemBuilder:
                            (context, DropDownValues? item, isSelected) =>
                                Padding(
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
                              bottom: Radius.circular(
                                  AppSizeConstants.xtralargeSpacing),
                            ),
                          ),
                        ),
                      ),
                      validator: (value) =>
                          value == null ? "Select Area" : null,
                      onChanged: (DropDownValues? value) {
                        optionData.clear();
                        selectedSensorIds.clear();
                        _selectTitle = value;
                        if (_selectTitle!.name != "Select") {
                          context
                              .read<DashboardCubit>()
                              .areaSensorList(_selectTitle!.value);
                        }
                      },
                      selectedItem: _selectTitle,
                      itemAsString: (DropDownValues? item) => item!.name,
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration:
                            AppStyles.customInputDecoration(
                          context,
                          label: const RequiredText(
                            label: "Select Area",
                          ),
                        ),
                      ),
                    ),
                    20.height,
                    buildCalendarDialogButton(),
                    20.height,
                    sensors!.isEmpty
                        ? Container()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      "Available Sensors:",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color:
                                                  ThemeConstants.primaryColor),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 12.0),
                                    child: CustomButton(
                                      buttonWidth: 120,
                                      onPressed: () {
                                        setState(() {
                                          // Clear the optionData list before selecting all sensors
                                          optionData.clear();
                                          // Clear the selectedSensorIds list before selecting all sensors
                                          selectedSensorIds.clear();
                                          // Iterate over the list of sensors
                                          for (var sensor in sensors!) {
                                            // Add the sensor ID to the selectedSensorIds list
                                            selectedSensorIds
                                                .add(sensor.sensorId!);
                                            // Add the sensor ID to the optionData list
                                            optionData.add({
                                              "sensorId": "${sensor.sensorId}"
                                            });
                                          }
                                        });
                                      },
                                      title: "Select All",
                                      color:
                                          ThemeConstants.black.withOpacity(0.5),
                                      textColor: ThemeConstants.white,
                                    ),
                                  ),
                                ],
                              ),
                              5.height,
                              SingleChildScrollView(
                                  child: Column(
                                children: [
                                  ...sensors!.map((sensor) {
                                    return SizedBox(
                                      height: 35,
                                      child: CheckboxListTile(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 12.0,
                                                vertical: -12.0),
                                        title: Text(sensor.sensorId!),
                                        value: selectedSensorIds
                                            .contains(sensor.sensorId),
                                        onChanged: (bool? value) {
                                          setState(() {
                                            if (value != null && value) {
                                              selectedSensorIds
                                                  .add(sensor.sensorId!);
                                              optionData.add({
                                                "sensorId": "${sensor.sensorId}"
                                              });
                                            } else {
                                              selectedSensorIds
                                                  .remove(sensor.sensorId!);
                                              optionData.removeWhere((map) =>
                                                  map["sensorId"] ==
                                                  sensor.sensorId);
                                            }
                                          });
                                        },
                                      ),
                                    );
                                  }).toList(),
                                ],
                              )),
                              15.height,
                              Center(
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          ThemeConstants.primaryColor,
                                    ),
                                    onPressed: () {
                                      if (startTimeReport != "" &&
                                          endTimeReport != "") {
                                        if (optionData.isNotEmpty) {
                                          context
                                              .read<DashboardCubit>()
                                              .reportSensorList(
                                                  optionData,
                                                  _selectTitle!.value
                                                      .toString(),
                                                  startTimeReport,
                                                  endTimeReport);
                                        } else {
                                          showToast(
                                              message: "Please select sensor");
                                        }
                                      } else {
                                        showToast(
                                            message:
                                                "Please choose From and To date");
                                      }
                                    },
                                    child: Text(
                                      "View Data",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color: ThemeConstants.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                    10.height,
                    hourlyValuesRpts != null && hourlyValuesRpts!.length != 0
                        ? Align(
                            alignment: Alignment.topRight,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ThemeConstants.primaryColor,
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      insetPadding: const EdgeInsets.all(0),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            newDataTableMethod(),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Text(
                                'View Full Screen',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: ThemeConstants.white),
                              ),
                            ),
                          )
                        : Container(),
                    newDataTableMethod(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  SingleChildScrollView newDataTableMethod() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Sensor Name'), tooltip: 'report title'),
          DataColumn(label: Text('Date'), tooltip: 'hours'),
          // DataColumn(
          //   label: const Text('Hour'),
          //   onSort: (columnIndex, ascending) {
          //     _toggleSort(columnIndex);
          //   },
          // ),
          DataColumn(
              label: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("IN"),
                  ),
                  SizedBox(width: 15),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text("OUT"),
                  ),
                ],
              ),
              tooltip: 'hour in and out value') // Add more columns as needed
        ],
        rows: hourlyValuesRpts != null && hourlyValuesRpts!.length != 0
            ? hourlyValuesRpts!.map((hourlyValue) {
                return DataRow(cells: [
                  DataCell(Text(hourlyValue.sensorName!)),
                  DataCell(Text(getDateTimeList(hourlyValue.timeStamp!))),
                  // DataCell(Text(hourlyValue.hour!)),
                  DataCell(
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(hourlyValue.inValue.toString()),
                        ),
                        const SizedBox(width: 15),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(hourlyValue.outValue.toString()),
                        ),
                      ],
                    ),
                  ),
                ]);
              }).toList()
            : [
                DataRow(
                  cells: List<DataCell>.generate(columns.length,
                      (index) => const DataCell(Text('No Data'))),
                ),
              ],
      ),
    );
  }

  int? _sortColumnIndex;
  bool _sortAscending = true;

  void _toggleSort(int columnIndex) {
    if (_sortColumnIndex == columnIndex) {
      setState(() {
        _sortAscending = !_sortAscending;
      });
    } else {
      setState(() {
        _sortColumnIndex = columnIndex;
        _sortAscending = true;
      });
    }
  }

  final List<DataColumn> columns = [
    const DataColumn(label: Text('Sensor Name'), tooltip: 'report title'),
    const DataColumn(
      label: Text('Date'),
    ),
    // const DataColumn(
    //   label: Text('Hour'),
    // ),
    // DataColumn(label: Text('Hour'), tooltip: 'hours'),
    const DataColumn(
        label: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text("IN"),
            ),
            SizedBox(width: 15),
            Align(
              alignment: Alignment.centerRight,
              child: Text("OUT"),
            ),
          ],
        ),
        tooltip: 'hour in and out value') // Add more columns as needed
  ];
  String getDateTimeAsString(DateTime dateValue) {
    String formattedDate = DateFormat('yyyyMMdd').format(dateValue);
    return "${formattedDate}000000";
  }

  String getEndTimeAsString(DateTime dateValue) {
    String formattedDate = DateFormat('yyyyMMdd').format(dateValue);
    return "${formattedDate}225959";
  }

  String getDateTimeList(String dateValue) {
    DateTime dateTime = DateTime.parse(dateValue);
    String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
    return formattedDate;
  }

  List<DateTime?> _dialogCalendarPickerValue = [
    DateTime.now(),
  ];

  buildCalendarDialogButton() {
    const dayTextStyle =
        TextStyle(color: Colors.black, fontWeight: FontWeight.w700);
    final weekendTextStyle =
        TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w600);
    final config = CalendarDatePicker2WithActionButtonsConfig(
      dayTextStyle: dayTextStyle,
      calendarType: CalendarDatePicker2Type.range,
      selectedDayHighlightColor: ThemeConstants.primaryColor,
      closeDialogOnCancelTapped: true,
      firstDate: DateTime(2001),
      currentDate: DateTime.now(),
      firstDayOfWeek: 1,
      weekdayLabelTextStyle: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      controlsTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
      centerAlignModePicker: true,
      customModePickerIcon: const SizedBox(),
      selectedDayTextStyle: dayTextStyle.copyWith(color: Colors.white),
      dayTextStylePredicate: ({required date}) {
        TextStyle? textStyle;
        if (date.weekday == DateTime.saturday ||
            date.weekday == DateTime.sunday) {
          textStyle = weekendTextStyle;
        }
        return textStyle;
      },
      dayBuilder: ({
        required date,
        textStyle,
        decoration,
        isSelected,
        isDisabled,
        isToday,
      }) {
        Widget? dayWidget;
        if (date.day % 3 == 0 && date.day % 9 != 0) {
          dayWidget = Container(
            decoration: decoration,
            child: Center(
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Text(
                    MaterialLocalizations.of(context).formatDecimal(date.day),
                    style: textStyle,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 27.5),
                    child: Container(
                      height: 4,
                      width: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: isSelected == true
                            ? Colors.white
                            : Colors.grey[500],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return dayWidget;
      },
      yearBuilder: ({
        required year,
        decoration,
        isCurrentYear,
        isDisabled,
        isSelected,
        textStyle,
      }) {
        return Center(
          child: Container(
            decoration: decoration,
            height: 36,
            width: 72,
            child: Center(
              child: Semantics(
                selected: isSelected,
                button: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      year.toString(),
                      style: textStyle,
                    ),
                    if (isCurrentYear == true)
                      Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(left: 5),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.redAccent,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    return Padding(
      padding: const EdgeInsets.all(1),
      child: TextFormField(
        decoration: InputDecoration(
          hintStyle: const TextStyle(color: ThemeConstants.grey),
          labelStyle: const TextStyle(color: ThemeConstants.grey),
          label: const RequiredText(
            label: "Select From Date -- To Date",
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.black),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.black),
          ),
          hintText: "dd/mm/yyyy",
          suffixIcon: Image.asset(
            'assets/pngs/calendaricon.png',
            width: 24,
            height: 24,
          ),
        ),
        readOnly: true,
        onTap: () async {
          final values = await showCalendarDatePicker2Dialog(
            context: context,
            config: config,
            dialogSize: const Size(325, 400),
            borderRadius: BorderRadius.circular(15),
            value: _dialogCalendarPickerValue,
            dialogBackgroundColor: Colors.white,
          );

          if (values != null) {
            startTimeReport = getDateTimeAsString(values[0]!);
            endTimeReport = getEndTimeAsString(values[1]!);
            setState(() {
              _dialogCalendarPickerValue = values;
            });
            _dobController.text =
                "${DateFormat("dd/MM/yyyy").format(values[0]!)}  -  ${DateFormat("dd/MM/yyyy").format(values[1]!)}";
          }
        },
        controller: _dobController,
        validator: (value) =>
            value == null || value.isEmpty ? "Please choose date" : null,
      ),
    );
  }
}

class RichTextWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Center(child: Text("9hr")),
        5.height,
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Align(
              alignment: Alignment.centerLeft,
              child: Text("IN"),
            ),
            SizedBox(width: 15),
            Align(
              alignment: Alignment.centerRight,
              child: Text("OUT"),
            ),
          ],
        )
      ],
    );
  }
}
