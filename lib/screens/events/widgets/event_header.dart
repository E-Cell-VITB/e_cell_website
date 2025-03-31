// import 'package:e_cell_website/backend/models/event.dart';
// import 'package:e_cell_website/const/theme.dart';
// import 'package:flutter/material.dart';

// class EventHeaderClickable extends StatelessWidget {
//   final Event event;
//   final bool isMobile;

//   const EventHeaderClickable({
//     super.key,
//     required this.event,
//     required this.isMobile,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;

//     // Fixed heights as in original
//     final containerHeight = isMobile ? 80.0 : size.width * 0.11;

//     return Padding(
//       padding: EdgeInsets.only(top: isMobile ? 82 : size.width * 0.13),
//       child: Align(
//         alignment: Alignment.topCenter,
//         child: Container(
//           width: isMobile ? 300 : size.width * 0.7,
//           height: containerHeight, // Fixed height
//           decoration: BoxDecoration(
//             gradient: const LinearGradient(colors: linerGradient),
//             borderRadius: BorderRadius.circular(28),
//           ),
//           padding: const EdgeInsets.all(2),
//           child: Container(
//             width: isMobile ? 350 : size.width * 0.7,
//             height: containerHeight - 4,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(28),
//               gradient: const LinearGradient(colors: eventBoxLinearGradient),
//             ),
//             padding: const EdgeInsets.symmetric(horizontal: 30),
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     event.name,
//                     style: TextStyle(
//                       fontSize: isMobile ? 12 : 35,
//                       fontWeight: FontWeight.w600,
//                     ),
//                     textAlign: TextAlign.center,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),

//                   // Clickable description with dialog for full text
//                   GestureDetector(
//                     onTap: () {
//                       // Only show dialog if description is truncated
//                       if (event.description.length > (isMobile ? 30 : 80)) {
//                         showDialog(
//                           context: context,
//                           builder: (context) => AlertDialog(
//                             title: Text(event.name),
//                             content: SingleChildScrollView(
//                               child: Text(
//                                 event.description,
//                                 style: const TextStyle(
//                                   fontSize: 16,
//                                 ),
//                               ),
//                             ),
//                             actions: [
//                               TextButton(
//                                 onPressed: () => Navigator.pop(context),
//                                 child: const Text('Close'),
//                               ),
//                             ],
//                           ),
//                         );
//                       }
//                     },
//                     child: SizedBox(
//                       height: isMobile
//                           ? (containerHeight - 4 - 12 - 0) * 0.55
//                           : (containerHeight - 4 - 35 - 12) * 0.7,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Flexible(
//                             child: Text(
//                               event.description,
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: isMobile ? 6 : 14,
//                               ),
//                               maxLines: isMobile ? 2 : 3,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                           if (event.description.length > (isMobile ? 30 : 80))
//                             Icon(
//                               Icons.more_horiz,
//                               size: isMobile ? 8 : 16,
//                               color: Colors.grey,
//                             ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
