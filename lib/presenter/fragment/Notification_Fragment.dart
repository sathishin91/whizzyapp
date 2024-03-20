import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../blocs/dashboard/dashboard_cubit.dart';
import '../../constants/utilities.dart';
import '../../core/preference_helper.dart';
import '../../models/notify_model.dart';
import '../../widgets/mutual_fund_invest_list_card.dart';

class NotificationFragment extends StatefulWidget {
  final int? selectedIndex;
  const NotificationFragment({Key? key, this.selectedIndex}) : super(key: key);

  @override
  State<NotificationFragment> createState() => _NotificationFragmentState();
}

class _NotificationFragmentState extends State<NotificationFragment> {
  TextEditingController searchCont = TextEditingController();
  List<NotificationAll> notificationAll = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserId();
  }

  void getUserId() async {
    String userId = (await PreferenceHelper.getUserId())!;
    context.read<DashboardCubit>().notificationListAll(userId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardCubit, DashboardState>(
      listener: (context, state) {
        if (state is NotificationInfoLoaded) {
          print("success");
          notificationAll = state.notificationAll;
        } else if (state is DashboardError) {
          showErrorToast(
              appErrorType: state.appErrorType,
              errorMessage: state.errorMessage);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              10.height,
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    if (index < notificationAll.length) {
                      return NotificationReportCard(
                        notificationAll: notificationAll[index],
                      );
                    } else {
                      return Center(
                        child: Text(
                          "No Records Found",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      );
                    }
                  },
                  itemCount: notificationAll.length,
                ),
              ),
              10.height,
            ],
          ),
        );
      },
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
