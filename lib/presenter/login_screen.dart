import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:whizzy/blocs/login/login_cubit.dart';
import 'package:whizzy/constants/constant_export.dart';
import 'package:whizzy/widgets/loading_widget.dart';

import '../constants/utilities.dart';
import '../routes/route_generator.dart';
import '../widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _ipCodeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool enableLoginFlow = true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginError) {
              showErrorToast(
                  appErrorType: state.appErrorType,
                  errorMessage: state.errorMessage);
            }
            if (state is IPInfoLoaded) {
              enableLoginFlow = false;
            }
            if (state is LoginInfoLoaded) {
              Navigator.pushNamed(
                context,
                Routes.dashboard,
              );
            }
          },
          builder: (context, state) {
            return LoadingWidget(
              showLoading: state is LoginLoading,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: Text(
                          "WHIZZY PEOPLE COUNT",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(color: ThemeConstants.primaryColor),
                        ),
                      ),
                    ),
                    Gap(10.h),
                    Expanded(
                      flex: 9,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  decoration: inputDecoration(
                                    'IP Code',
                                    prefixIcon:
                                        const Icon(Icons.important_devices),
                                  ),
                                  controller: _ipCodeController,
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter code';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              30.width,
                              SizedBox(
                                width: 80,
                                height: 60,
                                child: Padding(
                                  padding: const EdgeInsets.only(),
                                  child: CustomButton(
                                    title: "Fetch IP",
                                    onPressed: () {
                                      if (_ipCodeController.text.toString() !=
                                          "") {
                                        context.read<LoginCubit>().loadIpCode(
                                              _ipCodeController.text.toString(),
                                            );
                                      } else {
                                        showToast(
                                            message: "Please enter ip code");
                                      }
                                    },
                                    color: ThemeConstants.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          30.height,
                          const Divider(),
                          30.height,
                          !enableLoginFlow
                              ? Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        decoration: inputDecoration('Email',
                                            prefixIcon:
                                                const Icon(Icons.email)),
                                        controller: _emailController,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter email address';
                                          }
                                          return null;
                                        },
                                      ),
                                      Gap(20.h),
                                      TextFormField(
                                        decoration: inputDecoration('Password',
                                            prefixIcon:
                                                const Icon(Icons.password)),
                                        controller: _passwordController,
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter password';
                                          }
                                          return null;
                                        },
                                      ),
                                      Gap(20.h),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 36.0, right: 36, bottom: 24),
                                        child: CustomButton(
                                          title: "Login",
                                          color: ThemeConstants.white,
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              _formKey.currentState!.save();
                                              context
                                                  .read<LoginCubit>()
                                                  .loadLogin(
                                                    _emailController.text
                                                        .toString(),
                                                    _passwordController.text
                                                        .toString(),
                                                  );
                                            } else {
                                              showToast(
                                                  message:
                                                      "Please enter required fields");
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container()
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
