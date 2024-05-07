import 'package:flatwork/utils/utils.dart';
import 'package:flutter/material.dart';

class CommonContainer extends StatelessWidget {
  const CommonContainer({
    super.key,
    this.child,
    this.height,
    this.color
  });

  final Widget? child;
  final double? height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final deviceSize = context.deviceSize;

    return Container(
      width: deviceSize.width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color ?? context.colorScheme.primaryContainer,
      ),
      child: child,
    );
  }
}
