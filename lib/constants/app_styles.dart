import 'package:flutter/material.dart';

import 'constant_export.dart';

class AppStyles {
  AppStyles._();

  static InputDecoration customInputDecoration(
    BuildContext context, {
    String? labelText,
    Widget? label,
    String? hintText,
  }) =>
      InputDecoration(
        labelText: labelText,
        label: label,
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
        labelStyle: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: Colors.black),

        contentPadding: const EdgeInsets.all(8.0),
        isDense: true,
        //isCollapsed: true,
        hintText: hintText,
        focusColor: ThemeConstants.primaryColor,
      );
}
