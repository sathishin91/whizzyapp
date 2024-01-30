import 'package:flutter/material.dart';

import '../constants/theme_constants.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final Color color;
  final double radius;
  final double buttonWidth;
  final Color textColor;
  final double? fontSize;
  final BorderSide borderSide;
  final TextStyle? textStyle;

  const CustomButton({
    Key? key,
    required this.title,
    this.onPressed,
    this.color = ThemeConstants.primaryColor,
    this.radius = 9,
    this.buttonWidth = double.infinity,
    this.fontSize,
    this.textColor = Colors.black87,
    this.textStyle,
    this.borderSide = const BorderSide(width: 0, color: Colors.transparent),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = buttonWidth;
    if (buttonWidth == double.infinity) {
      width = MediaQuery.of(context).size.width * 0.65;
    }
    return Container(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return Colors.grey;
              } else {
                return color;
              }
            },
          ),
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(vertical: 12),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(radius),
                ),
                side: borderSide),
          ),
        ),
        child: Text(
          title,
          style: textStyle?.copyWith(color: textColor) ??
              ThemeConstants.btnTheme.copyWith(
                color: textColor,
                fontSize: fontSize ?? 18,
              ),
        ),
      ),
    );
  }
}
