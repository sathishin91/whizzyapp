import 'package:custom_date_range_picker/custom_date_range_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../constants/app_context.dart';
import '../../constants/constant_export.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0, top: 8, right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextFormField(
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
              onTap: () {
                datePickerDialog(context);
              },
              controller: _dobController,
              validator: (value) => value == null || value.isEmpty
                  ? "Please enter date of birth"
                  : null,
            ),
            20.height,
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
                itemBuilder: (context, DropDownValues? item, isSelected) =>
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
                      bottom:
                          Radius.circular(AppSizeConstants.xtralargeSpacing),
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
                dropdownSearchDecoration: AppStyles.customInputDecoration(
                  context,
                  label: const RequiredText(
                    label: AppConstants.selectTitle,
                  ),
                ),
              ),
            ),
            10.height,
            // SingleChildScrollView(
            //   scrollDirection: Axis.horizontal,
            //   child: DataTable(
            //     columns: columns,
            //     rows: rows,
            //   ),
            // ),
            // RichTextWidget(),
            // RichText(
            //   text: const TextSpan(
            //     text: '10 Jan ',
            //     children: <TextSpan>[
            //       TextSpan(
            //         text: 'In - Out',
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  final List<DataColumn> columns = [
    DataColumn(label: Text('Title'), tooltip: 'Serial Number'),
    DataColumn(
      label: RichText(
        text: TextSpan(
          text: 'Hello, ',
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.black,
          ),
          children: <TextSpan>[
            TextSpan(
              text: 'world',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            TextSpan(
              text: '!',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    ),
    DataColumn(label: Text('In - Out'), tooltip: 'Surname'),
    DataColumn(label: Text('In - Out'), tooltip: 'Person\'s Age'),
    // Add more columns as needed
  ];

  final List<DataRow> rows = [
    DataRow(cells: [
      DataCell(Text('GHPO')),
      DataCell(Text('John')),
      DataCell(Text('Doe')),
      DataCell(Text('30')),
    ]),
    DataRow(cells: [
      DataCell(Text('COACH')),
      DataCell(Text('Jane')),
      DataCell(Text('Smith')),
      DataCell(Text('25')),
    ]),
    DataRow(cells: [
      DataCell(Text('KATE SPADE')),
      DataCell(Text('Bob')),
      DataCell(Text('Johnson')),
      DataCell(Text('40')),
    ]),
    // Add more rows as needed
  ];

  void datePickerDialog(BuildContext context) {
    return showCustomDateRangePicker(
      context,
      dismissible: true,
      minimumDate: DateTime(2000),
      maximumDate: DateTime.now().add(const Duration(days: 30)),
      endDate: endDate,
      startDate: startDate,
      onApplyClick: (start, end) {
        setState(() {
          endDate = end;
          startDate = start;
          _dobController.text = "$start - $end";
        });
      },
      onCancelClick: () {
        setState(() {
          endDate = null;
          startDate = null;
        });
      },
    );
  }

  Widget cardWidget(String text) => Expanded(
        child: Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text("data"),
                Text(text),
              ],
            ),
          ),
        ),
      );
}

class RichTextWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: 'Hello, ',
        style: DefaultTextStyle.of(context).style,
        children: <TextSpan>[
          TextSpan(
            text: 'world',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          TextSpan(
            text: '!',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
