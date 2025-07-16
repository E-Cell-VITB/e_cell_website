import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cell_website/screens/events/widgets/eventdetails.dart';
import 'package:e_cell_website/widgets/linear_grad_text.dart';
import 'package:flutter/material.dart';

// EventUpdate model
class EventUpdate {
  final String? id;
  final String eventName;
  final DateTime eventStartTime;
  final String venue;
  final bool isActive;

  EventUpdate({
    this.id,
    required this.eventName,
    required this.eventStartTime,
    required this.venue,
    this.isActive = true,
  });

  factory EventUpdate.fromMap(Map<String, dynamic> map) {
    return EventUpdate(
      id: map['id'],
      eventName: map['eventName'] ?? '',
      eventStartTime: (map['eventStartTime'] as Timestamp).toDate(),
      venue: map['venue'] ?? '',
      isActive: map['isActive'] ?? true,
    );
  }
}

class EventUpdatesScreen extends StatefulWidget {
  const EventUpdatesScreen({
    super.key,
  });

  @override
  State<EventUpdatesScreen> createState() => _EventUpdatesScreenState();
}

class _EventUpdatesScreenState extends State<EventUpdatesScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Duration _durationLeft;
  Timer? _timer;
  String _statusText = 'Loading...';
  DateTime? _targetTime;
  String _venue = 'Loading venue...';
  String _eventName = 'Loading event...';
  StreamSubscription? _eventSubscription;

  @override
  void initState() {
    super.initState();
    _durationLeft = Duration.zero;
    _loadEventData();
    _startTimer();
  }

  Future<void> _loadEventData() async {
    try {
      // Listen to the next upcoming event
      _eventSubscription = _firestore
          .collection('eventupdates')
          .where('eventStartTime',
              isGreaterThan: Timestamp.fromDate(DateTime.now()))
          .orderBy('eventStartTime', descending: false)
          .limit(1)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          final data = snapshot.docs.first.data();
          final eventUpdate = EventUpdate.fromMap({
            ...data,
            'id': snapshot.docs.first.id,
          });

          setState(() {
            _targetTime = eventUpdate.eventStartTime;
            _venue = eventUpdate.venue;
            _eventName = eventUpdate.eventName;
            _statusText = 'Event starts in';
          });

          _updateDuration();
        } else {
          setState(() {
            _statusText = 'No upcoming events';
            _venue = 'No venue information';
            _eventName = 'No events scheduled';
            _durationLeft = Duration.zero;
          });
        }
      });
    } catch (e) {
      setState(() {
        _statusText = 'Error loading event data';
        _venue = 'Error loading venue';
        _eventName = 'Error loading event';
      });
    }
  }

  void _updateDuration() {
    if (_targetTime == null) {
      _durationLeft = Duration.zero;
      return;
    }

    final now = DateTime.now();
    if (now.isBefore(_targetTime!)) {
      _durationLeft = _targetTime!.difference(now);
    } else {
      _durationLeft = Duration.zero;
      _statusText = 'Event has started or ended';
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
    _eventSubscription?.cancel();
    super.dispose();
  }

  String _format(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    final days = _format(_durationLeft.inDays);
    final hours = _format(_durationLeft.inHours.remainder(24));
    final minutes = _format(_durationLeft.inMinutes.remainder(60));
    final seconds = _format(_durationLeft.inSeconds.remainder(60));

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Event Name
          // Padding(
          //   padding: const EdgeInsets.only(bottom: 20.0),
          //   child: LinearGradientText(
          //     child: Text(
          //       _eventName,
          //       style: isMobile
          //           ? Theme.of(context).textTheme.headlineSmall
          //           : Theme.of(context).textTheme.headlineLarge,
          //       textAlign: TextAlign.center,
          //     ),
          //   ),
          // ),

          // Status Text
          // Padding(
          //   padding: const EdgeInsets.only(bottom: 20.0),
          //   child: Text(
          //     _statusText,
          //     style: TextStyle(
          //       color: Colors.white70,
          //       fontSize: isMobile ? 16 : 20,
          //       fontWeight: FontWeight.w500,
          //     ),
          //     textAlign: TextAlign.center,
          //   ),
          // ),

          Image.asset(
            'assets/images/Ecell.png',
            width: 200,
            height: 200,
          ),

          const SizedBox(height: 20),
          // Countdown Timer
          SizedBox(
            width: isMobile ? screenWidth * 0.9 : screenWidth * 0.6,
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
          ),

          const SizedBox(height: 36),

          // Venue
          LinearGradientText(
            child: Text(
              'Venue: $_venue',
              style: isMobile
                  ? Theme.of(context).textTheme.labelLarge
                  : Theme.of(context).textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
          ),
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
        const SizedBox(height: 30),
        GradientBox(
          radius: isMobile ? 9 : 18,
          height: isMobile ? 40 : 160,
          width: isMobile ? 50 : 160,
          child: Center(
            child: LinearGradientText(
              child: Text(
                count,
                style: isMobile
                    ? Theme.of(context).textTheme.labelLarge
                    : Theme.of(context).textTheme.displayLarge,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          type,
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 16 : 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// class LinearGradientText extends StatelessWidget {
//   const LinearGradientText({
//     super.key,
//     required this.child,
//   });
//   final Text child;

//   @override
//   Widget build(BuildContext context) {
//     const List<Color> linerGradient = [
//       Color(0xffC79200),
//       Color(0xffFFE8A9),
//       Color(0xffC79200),
//     ];

//     return ShaderMask(
//       blendMode: BlendMode.srcIn,
//       shaderCallback: (Rect bounds) {
//         return const LinearGradient(
//           colors: linerGradient,
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ).createShader(bounds);
//       },
//       child: child,
//     );
//   }
// }

// class GradientBox extends StatelessWidget {
//   final Widget child;
//   final double? height;
//   final double? width;
//   final double radius;
//   final VoidCallback? onTap;

//   const GradientBox({
//     super.key,
//     required this.radius,
//     required this.child,
//     this.height,
//     this.width,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     const List<Color> eventBoxLinearGradient = [
//       Color(0xFF0D0D0D),
//       Color(0xFF1F1E1E),
//       Color(0xFF000000)
//     ];

//     const List<Color> linerGradient = [
//       Color(0xffC79200),
//       Color(0xffFFE8A9),
//       Color(0xffC79200),
//     ];

//     return Container(
//       height: height,
//       width: width,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(radius),
//         gradient: LinearGradient(colors: linerGradient),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(1),
//         child: Container(
//           height: height,
//           width: width,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(radius),
//             gradient: LinearGradient(colors: eventBoxLinearGradient),
//           ),
//           child: InkWell(
//             onTap: onTap,
//             borderRadius: BorderRadius.circular(radius),
//             child: child,
//           ),
//         ),
//       ),
//     );
//   }
// }
