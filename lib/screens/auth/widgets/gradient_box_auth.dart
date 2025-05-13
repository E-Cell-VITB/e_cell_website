import 'package:e_cell_website/const/theme.dart';
import 'package:flutter/material.dart';

class GradientBoxAuth extends StatelessWidget {
  final Widget child;
  final double height;
  final double? width;
  final double radius;
  final VoidCallback? onTap;

  const GradientBoxAuth({
    super.key,
    required this.radius,
    required this.child,
    required this.height,
    this.width,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: const LinearGradient(colors: linerGradient),
      ),
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            gradient: const LinearGradient(
              colors: eventBoxLinearGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(radius),
            child: child,
          ),
        ),
      ),
    );
  }
}
