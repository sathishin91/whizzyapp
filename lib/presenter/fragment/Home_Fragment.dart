import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../constants/app_context.dart';
import '../../constants/constant_export.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/required_text.dart';

class HomeFragment extends StatefulWidget {
  final VoidCallback goToSearch;

  const HomeFragment(this.goToSearch, {super.key});
  // const HomeFragment({required this.goToSearch}) : super(key: key);

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
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
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData("9hr", 0),
      ChartData("10hr", 0),
      ChartData("11hr", 0),
      ChartData("12hr", 0),
      ChartData("13hr", 0)
    ];
    return Scaffold(
      backgroundColor: ThemeConstants.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // 10.height,
            // GestureDetector(
            //   onTap: () {
            //     widget.goToSearch();
            //   },
            //   child: AppTextField(
            //     textFieldType: TextFieldType.NAME,
            //     enabled: false,
            //     controller: searchCont,
            //     decoration: inputSearchDecoration(context, "Search"),
            //   ).paddingSymmetric(horizontal: 16),
            // ),
            10.height,
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintStyle:
                              const TextStyle(color: ThemeConstants.grey),
                          labelStyle:
                              const TextStyle(color: ThemeConstants.grey),
                          label: const RequiredText(
                            label: "DOB",
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
                        onTap: () => handleDateOfBirthClick(
                            dobController: _dobController, context: context),
                        controller: _dobController,
                        validator: (value) => value == null || value.isEmpty
                            ? "Please enter date of birth"
                            : null,
                      ),
                    ),
                  ),
                  10.width,
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: DropdownSearch<DropDownValues?>(
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
                                horizontal: AppSizeConstants.screenHorizontal),
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
                    ),
                  ),
                ],
              ),
            ),
            15.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                cardWidget("Entry Total ", "Last Week "),
                cardWidget("Exit Total ", "Last Week "),
              ],
            ),
            10.height,
            Row(
              children: [
                cardWidget("Peak Hour ", "Last Week "),
                cardWidget("AvgDwellTime ", "MaxDwellTime "),
              ],
            ),
            SfCartesianChart(
              title: ChartTitle(
                text: 'Hourly Entry',
                alignment: ChartAlignment.near,
              ),
              primaryXAxis: CategoryAxis(
                  // title: AxisTitle(text: "Month"),
                  ),
              series: <CartesianSeries<ChartData, String>>[
                ColumnSeries<ChartData, String>(
                    width: 0.5,
                    spacing: 0.2,
                    dataSource: chartData,
                    xValueMapper: (ChartData data, _) => data.x.toString(),
                    yValueMapper: (ChartData data, _) => data.y)
              ],
            ),
            10.height,
            SfCartesianChart(
              title: ChartTitle(
                text: 'Hourly Exit',
                alignment: ChartAlignment.near,
              ),
              primaryXAxis: CategoryAxis(
                  // title: AxisTitle(text: "Month"),
                  ),
              series: <CartesianSeries<ChartData, String>>[
                ColumnSeries<ChartData, String>(
                    width: 0.5,
                    spacing: 0.2,
                    dataSource: chartData,
                    xValueMapper: (ChartData data, _) => data.x.toString(),
                    yValueMapper: (ChartData data, _) => data.y)
              ],
            ),
            10.height,
            SfCartesianChart(
              title: ChartTitle(
                text: 'Hourly Occupancy',
                alignment: ChartAlignment.near,
              ),
              primaryXAxis: CategoryAxis(
                  // title: AxisTitle(text: "Month"),
                  ),
              series: <CartesianSeries<ChartData, String>>[
                ColumnSeries<ChartData, String>(
                    width: 0.5,
                    spacing: 0.2,
                    dataSource: chartData,
                    xValueMapper: (ChartData data, _) => data.x.toString(),
                    yValueMapper: (ChartData data, _) => data.y)
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget cardWidget(String text1, String text2) => Expanded(
        child: Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text1),
                15.height,
                Text(text2),
              ],
            ),
          ),
        ),
      );

  void handleDateOfBirthClick(
      {required TextEditingController dobController,
      required BuildContext context}) async {
    DateTime? initialDate = dobController.text.isEmpty
        ? null
        : DateFormat('dd/MM/yyyy').parse(dobController.text);
    DateTime? selectedDate = await showRoundedDatePicker(
      context: context,
      borderRadius: 24,
      height: 300,
      initialDate: initialDate ?? DateTime(DateTime.now().year - 18),
      lastDate: DateTime(DateTime.now().year),
      firstDate: DateTime(DateTime.now().year - 100),
      initialDatePickerMode: DatePickerMode.day,
      background: Colors.grey.withOpacity(0.5),
      styleDatePicker: MaterialRoundedDatePickerStyle(
        decorationDateSelected: const BoxDecoration(
          color: ThemeConstants.primaryColor,
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        textStyleCurrentDayOnCalendar: const TextStyle(
          color: Colors.green,
        ),
      ),
      theme: ThemeData(
        primaryColor: ThemeConstants.primaryColor,
        textTheme: const TextTheme(
          titleMedium: TextStyle(
            color: ThemeConstants.primaryColor,
          ),
          bodyMedium: TextStyle(color: Colors.black),
          bodySmall: TextStyle(color: Colors.green),
        ),
        disabledColor: Colors.red.withOpacity(0.5),
      ),
    );
    if (selectedDate != null) {
      dobController.text = DateFormat("dd/MM/yyyy").format(selectedDate);
      setState(() {});
    }
  }

// ListView.builder(
//     itemCount: 5,
//     itemBuilder: (BuildContext context, int index) {
//       return Column(
//         children: const [
//           JobDetailsCard(),
//         ],
//       );
//     },
//   ),
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
