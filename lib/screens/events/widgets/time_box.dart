import 'package:e_cell_website/screens/events/widgets/eventdetails.dart';
import 'package:e_cell_website/widgets/linear_grad_text.dart';
import 'package:flutter/material.dart';

class TimeBox extends StatelessWidget {
  final String count;
  final String type;
  const TimeBox({required this.count, required this.type, super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 30,
        ),
        GradientBox(
          radius: isMobile ? 9 : 18,
          height: isMobile ? 60 : 100,
          width: isMobile ? 60 : 100,
          child: Center(
              child: LinearGradientText(
                  child: Text(
            count,
            style: isMobile
                ? Theme.of(context).textTheme.displaySmall
                : Theme.of(context).textTheme.displayMedium,
          ))),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(type),
      ],
    );
  }
}
