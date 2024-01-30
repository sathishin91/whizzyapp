import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../constants/utilities.dart';
import '../widgets/custom_button.dart';

class PortNumberScreen extends StatefulWidget {
  const PortNumberScreen({super.key});

  @override
  State<PortNumberScreen> createState() => _PortNumberScreenState();
}

class _PortNumberScreenState extends State<PortNumberScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Center(
                  child: Text(
                    "Whizzy People Count",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
              Gap(10.h),
              Expanded(
                flex: 9,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: inputDecoration('IP Address'),
                      // controller: _emailController,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter ip address';
                        }
                        return null;
                      },
                    ),
                    Gap(20.h),
                    TextFormField(
                      decoration: inputDecoration('Port Number'),
                      // controller: _emailController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter port number';
                        }
                        return null;
                      },
                    ),
                    Gap(20.h),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 36.0, right: 36, bottom: 24),
                      child: CustomButton(
                        title: "Submit",
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
