import 'package:flutter/material.dart';

class RequiredText extends StatelessWidget {
  final String label;
  final TextStyle? style;
  final TextStyle? starStyle;

  const RequiredText(
      {Key? key, required this.label, this.style, this.starStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: label,
        style: style,
        children: [
          TextSpan(
            text: '*',
            style: starStyle?.copyWith(
                  color: Colors.red,
                ) ??
                style?.copyWith(
                  color: Colors.red,
                ) ??
                Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .apply(color: Colors.red),
          )
        ],
      ),
    );
  }
}
