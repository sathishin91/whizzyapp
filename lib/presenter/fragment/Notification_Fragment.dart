import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class NotificationFragment extends StatefulWidget {
  final int? selectedIndex;
  const NotificationFragment({Key? key, this.selectedIndex}) : super(key: key);

  @override
  State<NotificationFragment> createState() => _NotificationFragmentState();
}

class _NotificationFragmentState extends State<NotificationFragment> {
  TextEditingController searchCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            10.height,
            // SizedBox(
            //   width: double.infinity,
            //   child: Card(
            //     shape: const RoundedRectangleBorder(
            //       borderRadius: BorderRadius.all(Radius.circular(8.0)),
            //     ),
            //     child: Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Column(
            //         children: [
            const Text("Coming Soon"),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            // cardWidget("text"),
            10.height,
          ],
        ),
      ),
    );
  }

  Widget cardWidget(String text) => Card(
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
      );
}
