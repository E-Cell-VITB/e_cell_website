import 'package:e_cell_website/const/const_labels.dart';
import 'package:e_cell_website/const/theme.dart';
import 'package:flutter/material.dart';

class SloganText extends StatelessWidget {
  const SloganText({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(children: [
      TextSpan(
        text: "✨ ",
        style: TextStyle(
          fontSize: size.width * 0.02,
          fontWeight: FontWeight.w600,
          letterSpacing: 2,
          color: secondaryColor,
          shadows: const [
            Shadow(
              color: Color.fromRGBO(32, 32, 32, 0.6),
              offset: Offset(2, 4),
              blurRadius: 2,
            ),
          ],
        ),
      ),
      TextSpan(
        text: slogan.toUpperCase(),
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: size.width * 0.02,
          fontWeight: FontWeight.w600,
          letterSpacing: 2,
          color: primaryColor,
          shadows: const [
            Shadow(
              color: Color.fromRGBO(32, 32, 32, 0.6),
              offset: Offset(2, 4),
              blurRadius: 2,
            ),
          ],
        ),
      ),
      TextSpan(
        text: " ✨",
        style: TextStyle(
          fontSize: size.width * 0.02,
          fontWeight: FontWeight.w600,
          letterSpacing: 2,
          color: secondaryColor,
          shadows: const [
            Shadow(
              color: Color.fromRGBO(32, 32, 32, 0.6),
              offset: Offset(2, 4),
              blurRadius: 2,
            ),
          ],
        ),
      ),
    ]));
  }
}
