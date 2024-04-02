import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:nb_utils/nb_utils.dart';

import '../blocs/login/login_cubit.dart';
import '../constants/app_context.dart';
import '../constants/constant_export.dart';
import '../constants/utilities.dart';
import '../core/preference_helper.dart';
import '../routes/route_generator.dart';
import '../widgets/custom_button.dart';
import '../widgets/loading_widget.dart';

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
  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ThemeConstants.white,
        resizeToAvoidBottomInset: false,
        body: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is IPError) {
              enableLoginFlow = true;
              showErrorToast(
                  appErrorType: state.appErrorType,
                  errorMessage: "Please Enter Valid IP Code");
            } else if (state is LoginError) {
              showErrorToast(
                  appErrorType: state.appErrorType,
                  errorMessage: state.errorMessage);
            } else if (state is IPInfoLoaded) {
              enableLoginFlow = false;
            } else if (state is LoginInfoLoaded) {
              context.read<LoginCubit>().loadDropdownList();
            } else if (state is DropdownInfoLoaded) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.dashboard,
                ((route) => false),
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
                        child: Image.asset(
                          "assets/pngs/logo.png",
                          height: 120,
                          width: double.infinity,
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
                                    context,
                                    'IP Code',
                                    prefixIcon:
                                        const Icon(Icons.important_devices),
                                  ),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  controller: _ipCodeController,
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Enter IP Code';
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
                                            message: "Please Enter IP Code");
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
                                        decoration: inputDecoration(
                                            context, 'Email',
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
                                        decoration: InputDecoration(
                                          labelText: 'Password',
                                          prefixIcon: const Icon(Icons.lock),
                                          suffixIcon: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _isObscure =
                                                    !_isObscure; // Toggle the obscureText state
                                              });
                                            },
                                            child: Icon(_isObscure
                                                ? Icons.visibility
                                                : Icons.visibility_off),
                                          ),
                                          labelStyle: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                color:
                                                    ThemeConstants.primaryColor,
                                              ),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey.shade500,
                                                width: 30.0),
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey.shade500,
                                                  width: 1.0),
                                              borderRadius:
                                                  BorderRadius.circular(12.0)),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey.shade500,
                                                  width: 1.0),
                                              borderRadius:
                                                  BorderRadius.circular(12.0)),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey.shade500,
                                                width: 1.0),
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                        ),
                                        controller: _passwordController,
                                        keyboardType: TextInputType.text,
                                        obscureText:
                                            _isObscure, // Set the obscureText property based on _isObscure state
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter password';
                                          }
                                          return null;
                                        },
                                      ),
                                      // TextFormField(
                                      //   decoration: inputDecoration(
                                      //       context, 'Password',
                                      //       prefixIcon:
                                      //           const Icon(Icons.password)),
                                      //   controller: _passwordController,
                                      //   keyboardType: TextInputType.text,
                                      //   obscureText: true,
                                      //   validator: (value) {
                                      //     if (value == null || value.isEmpty) {
                                      //       return 'Please enter password';
                                      //     }
                                      //     return null;
                                      //   },
                                      // ),
                                      Gap(20.h),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 36.0, right: 36, bottom: 24),
                                        child: CustomButton(
                                          title: "Login",
                                          color: ThemeConstants.white,
                                          onPressed: () async {
                                            AppContext().baseUrl =
                                                (await PreferenceHelper
                                                    .getBaseUrl())!;

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
