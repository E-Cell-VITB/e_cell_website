import 'dart:async';
import 'package:e_cell_website/screens/events/widgets/eventdetails.dart';
import 'package:e_cell_website/widgets/linear_grad_text.dart';
import 'package:flutter/material.dart';

class CountdownTimerWidget extends StatefulWidget {
  final DateTime startDateTime;
  final DateTime endDateTime;
  final bool isMobile;
  final double screenWidth;

  const CountdownTimerWidget({
    super.key,
    required this.startDateTime,
    required this.endDateTime,
    required this.isMobile,
    required this.screenWidth,
  });

  @override
  State<CountdownTimerWidget> createState() => _CountdownTimerWidgetState();
}

class _CountdownTimerWidgetState extends State<CountdownTimerWidget> {
  late Duration _durationLeft;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _updateDuration();
    _startTimer();
  }

  void _updateDuration() {
    final now = DateTime.now();
    if (widget.endDateTime.isAfter(now)) {
      _durationLeft = widget.endDateTime.difference(now);
    } else {
      _durationLeft = Duration.zero;
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        _updateDuration();
        if (_durationLeft.inSeconds <= 0) {
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _format(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final days = _format(_durationLeft.inDays);
    final hours = _format(_durationLeft.inHours.remainder(24));
    final minutes = _format(_durationLeft.inMinutes.remainder(60));
    final seconds = _format(_durationLeft.inSeconds.remainder(60));

    return SizedBox(
      width:
          widget.isMobile ? widget.screenWidth * 0.8 : widget.screenWidth * 0.4,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TimeBox(count: days, type: "Days"),
          _separator(context),
          TimeBox(count: hours, type: "Hours"),
          _separator(context),
          TimeBox(count: minutes, type: "Minutes"),
          _separator(context),
          TimeBox(count: seconds, type: "Seconds"),
        ],
      ),
    );
  }

  Widget _separator(BuildContext context) {
    return LinearGradientText(
      child: Text(":", style: Theme.of(context).textTheme.displaySmall),
    );
  }
}

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
          height: isMobile ? 40 : 100,
          width: isMobile ? 50 : 100,
          child: Center(
              child: LinearGradientText(
                  child: Text(
            count,
            style: isMobile
                ? Theme.of(context).textTheme.labelLarge
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
