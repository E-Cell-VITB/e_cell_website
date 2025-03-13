import 'package:e_cell_website/const/theme.dart';
import 'package:flutter/material.dart';

class LinearGradientText extends StatelessWidget {
  const LinearGradientText({
    super.key,
    required this.child,
  });
  final Text child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          colors: linerGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds);
      },
      child: child,
    );
  }
}
