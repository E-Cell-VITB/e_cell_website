// import 'package:e_cell_website/const/theme.dart';
// import 'package:e_cell_website/screens/team/widgets/profile.dart';
// import 'package:e_cell_website/widgets/linear_grad_text.dart';
// import 'package:flutter/material.dart';

// class Membercard extends StatelessWidget {
//   const Membercard({super.key});
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Container(
//       height: size.height * 0.6,
//       width: size.width * 0.6,
//       decoration: BoxDecoration(
//           color: containerBgColor, borderRadius: BorderRadius.circular(18)),
//       child: Padding(
//         padding: const EdgeInsets.all(18.0),
//         child: Stack(
//           children: [
//             const Align(
//               alignment: Alignment.topCenter,
//               child: LinearGradientText(
//                   child: Text(
//                 "PR&HR",
//                 style: TextStyle(fontSize: 30),
//               )),
//             ),
//             Align(
//               alignment: const Alignment(0, 0),
//               child: Text(
//                 "PR&HR",
//                 style: TextStyle(
//                     letterSpacing: 3,
//                     foreground: Paint()
//                       ..style = PaintingStyle.stroke
//                       ..strokeWidth = 0.5
//                       ..color = const Color.fromARGB(255, 80, 80, 80),
//                     fontSize: 280),
//               ),
//             ),
//             const Align(
//               alignment: Alignment(0, 0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   ProfileCard(),
//                   SizedBox(
//                     width: 40,
//                   ),
//                   ProfileCard(),
//                   SizedBox(
//                     width: 40,
//                   ),
//                   ProfileCard(),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
