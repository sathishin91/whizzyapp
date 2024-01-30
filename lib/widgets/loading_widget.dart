import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final bool showLoading;
  final Widget child;

  const LoadingWidget({
    super.key,
    required this.showLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Visibility(
          visible: showLoading,
          child: Container(
            color: Colors.transparent,
          ),
        ), // blocks user interaction
        Center(
          child: Visibility(
            visible: showLoading,
            child: CircularProgressIndicator(
              backgroundColor: Colors.grey[200],
            ),
          ),
        ),
      ],
    );
  }
}
