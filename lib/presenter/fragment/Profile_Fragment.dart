import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../constants/constant_export.dart';
import '../../core/preference_helper.dart';
import '../../routes/route_generator.dart';

class ProfileFragment extends StatefulWidget {
  const ProfileFragment({Key? key}) : super(key: key);

  @override
  State<ProfileFragment> createState() => _ProfileFragmentState();
}

class _ProfileFragmentState extends State<ProfileFragment> {
  TextEditingController searchCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 12.0, top: 8),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "IP Code Details:",
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(6),
              width: double.infinity,
              child: Card(
                color: ThemeConstants.primaryColor.withOpacity(0.3),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(6),
                  ),
                ),
                elevation: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    10.height,
                    ipAddress(),
                    10.height,
                    portNumber(),
                    5.height,
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(12),
              child: Column(
                children: [
                  const Divider(),
                  30.height,
                  GestureDetector(
                    onTap: () {
                      showConfirmDialogCustom(
                        context,
                        negativeText: "Cancel",
                        positiveText: "Yes",
                        primaryColor: ThemeConstants.primaryColor,
                        onCancel: (v) {
                          finish(context);
                        },
                        onAccept: (_) {
                          finish(context);
                          PreferenceHelper.logoutAccountCreated();
                          Navigator.pushNamedAndRemoveUntil(
                              context, Routes.loginScreen, (routes) => false);
                        },
                        dialogType: DialogType.CONFIRMATION,
                        title: "Do you want to logout from the app?",
                      );
                    },
                    child: Center(
                        child: Row(
                      children: [
                        const Icon(
                          Icons.logout,
                          size: 24,
                          color: grey,
                        ),
                        10.width,
                        Text("Logout",
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    )),
                  ),
                ],
              ),
            ),
            15.height,
            const Divider(),
            15.height,
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text("Version 1.0.0",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(fontSize: 11.5)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding textWidget(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Text(text, style: Theme.of(context).textTheme.titleSmall),
    );
  }

  Widget ipAddress() =>
      const _ProfileDetails(title: "IP Address", valueList: ["13.1.2.1"]);

  Widget portNumber() =>
      const _ProfileDetails(title: "Port Number", valueList: ["8087"]);
}

class _ProfileDetails extends StatelessWidget {
  final String title;
  final List<String> valueList;

  const _ProfileDetails(
      {Key? key, required this.title, required this.valueList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: AppSizeConstants.screenVertical,
          horizontal: AppSizeConstants.screenHorizontal),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(fontWeight: FontWeight.bold)),
          for (var element in valueList)
            if (element != "")
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: ThemeConstants.grey,
                      width: 1.0,
                    ),
                  ),
                ),
                child: Text(
                  element,
                  textAlign: TextAlign.start,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: ThemeConstants.black),
                ),
              ),
        ],
      ),
    );
  }
}
