import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../models/notify_model.dart';

class NotificationReportCard extends StatelessWidget {
  final NotificationAll notificationAll;

  const NotificationReportCard({Key? key, required this.notificationAll})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey, width: 0.5),
          borderRadius: BorderRadius.all(Radius.circular(5))),
      elevation: 0,
      child: InkWell(
        onTap: () {
          notifyDialog(context, notificationAll);
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 5,
                            child: Text(
                              "Title: ${notificationAll.alertTitle}",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 15),
                            ),
                          ),
                          const Gap(35),
                        ],
                      ),
                      const Gap(12),
                      Text(
                        "Area Id: ${notificationAll.areaId}",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                      const Gap(14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Area Name: ${notificationAll.areaName}",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                          ),
                          Text("Alert Type: ${notificationAll.alertType}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black)),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> notifyDialog(
      BuildContext context, NotificationAll notificationAll) async {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(6.0))),
            title: Text(
              "Title: ${notificationAll.alertTitle!}",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  newRowWidget(
                    context,
                    notificationAll.alertTitle.toString(),
                    "Area Id:",
                  ),
                  newRowWidget(
                    context,
                    notificationAll.areaName.toString(),
                    "Area Name:",
                  ),
                  newRowWidget(
                    context,
                    notificationAll.alertType.toString(),
                    "Alert Type:",
                  ),
                  newRowWidget(
                    context,
                    notificationAll.alertIndex.toString(),
                    "Alert Index:",
                  ),
                  newRowWidget(
                    context,
                    notificationAll.templateCode!,
                    "Template Code:",
                  ),
                  newRowWidget(
                    context,
                    notificationAll.persons!
                        .map((person) => person.email)
                        .join(',\n'),
                    "Email:",
                  ),
                ],
              ),
            ),
          );
        });
  }

  Row newRowWidget(BuildContext context, String title, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        textWidget(context, text),
        Text(
          title,
          maxLines: 5,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Text textWidget(BuildContext context, String text) => Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium,
      );
}
