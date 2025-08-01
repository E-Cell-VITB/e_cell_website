// import 'package:e_cell_website/const/theme.dart';
// import 'package:flutter/material.dart';

// class TeamDetailsForm extends StatelessWidget {
//   final TextEditingController teamNameController;
//   final int? teamSize;
//   final int maxTeamSize;
//   final ValueChanged<int?> onTeamSizeChanged;

//   const TeamDetailsForm({
//     required this.teamNameController,
//     required this.teamSize,
//     required this.maxTeamSize,
//     required this.onTeamSizeChanged,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: Column(
//         children: [
//           TextFormField(
//             controller: teamNameController,
//             decoration: InputDecoration(
//               labelText: 'Team Name',
//               labelStyle: const TextStyle(color: Colors.grey),
//               filled: true,
//               fillColor: backgroundColor,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide.none,
//               ),
//             ),
//             style: const TextStyle(color: primaryColor),
//             textDirection: TextDirection.ltr,
//             validator: (value) =>
//                 value == null || value.isEmpty ? 'Team name is required' : null,
//           ),
//           const SizedBox(height: 16),
//           DropdownButtonFormField<int>(
//             decoration: InputDecoration(
//               labelText: 'Team Size',
//               labelStyle: const TextStyle(color: Colors.grey),
//               filled: true,
//               fillColor: backgroundColor,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide.none,
//               ),
//             ),
//             dropdownColor: Colors.black87,
//             style: const TextStyle(color: primaryColor),
//             value: teamSize,
//             items: List.generate(
//               maxTeamSize,
//               (index) => DropdownMenuItem(
//                 value: index + 1,
//                 child: Directionality(
//                   textDirection: TextDirection.ltr,
//                   child: Text(
//                     '${index + 1}',
//                     style: const TextStyle(color: primaryColor),
//                   ),
//                 ),
//               ),
//             ),
//             onChanged: onTeamSizeChanged,
//             validator: (value) =>
//                 value == null ? 'Please select a team size' : null,
//           ),
//         ],
//       ),
//     );
//   }
// }
