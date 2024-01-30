import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:whizzy/constants/constant_export.dart';

import '../core/app_error.dart';
import 'theme_constants.dart';

InputDecoration inputDecoration(String labelText, {Icon? prefixIcon}) {
  return InputDecoration(
    labelText: labelText,
    prefixIcon: prefixIcon,
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade500, width: 30.0),
      borderRadius: BorderRadius.circular(12.0),
    ),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade500, width: 1.0),
        borderRadius: BorderRadius.circular(12.0)),
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade500, width: 1.0),
        borderRadius: BorderRadius.circular(12.0)),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade500, width: 1.0),
      borderRadius: BorderRadius.circular(12.0),
    ),
  );
}

InputDecoration inputSearchDecoration(BuildContext context, String hintText) {
  return InputDecoration(
    contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
    counterText: "",
    border: const OutlineInputBorder(),
    errorBorder: const OutlineInputBorder(),
    focusedBorder: const OutlineInputBorder(),
    hintText: hintText,
    hintStyle: Theme.of(context)
        .textTheme
        .bodySmall!
        .copyWith(color: ThemeConstants.grey),
    prefixIcon: Icon(
      Icons.search,
      color: gray.withOpacity(0.8),
    ),
  );
}

void debugLog(Object message) {
  print(message);
}

showToast({required String message}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
  );
}

showErrorToast({
  String? errorMessage,
  required AppErrorType appErrorType,
}) {
  Fluttertoast.showToast(
    msg: getErrorMessage(appErrorType: appErrorType, message: errorMessage),
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
  );
}

String getErrorMessage({String? message, required AppErrorType appErrorType}) {
  final String errorMessage = message ??
      (appErrorType == AppErrorType.network
          ? AppConstants.noNetworkMessage
          : AppConstants.genericErrorMessage);
  return errorMessage;
}
