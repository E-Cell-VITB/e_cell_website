// // subscription_form.dart
// import 'package:e_cell_website/const/theme.dart';
// import 'package:e_cell_website/services/const/toaster.dart';
// import 'package:e_cell_website/services/providers/subscription_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:toastification/toastification.dart';

// class SubscriptionForm extends StatefulWidget {
//   const SubscriptionForm({super.key});

//   @override
//   State<SubscriptionForm> createState() => _SubscriptionFormState();
// }

// class _SubscriptionFormState extends State<SubscriptionForm> {
//   final TextEditingController _emailController = TextEditingController();
//   SubscriptionStatus? _previousStatus;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<SubscriptionProvider>(
//       builder: (context, subscriptioProvider, child) {
//         // Handle status changes for toast messages
//         if (_previousStatus != subscriptioProvider.status) {
//           _previousStatus = subscriptioProvider.status;

//           // Show appropriate toast based on status
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             if (subscriptioProvider.status == SubscriptionStatus.success) {
//               showCustomToast(
//                 title: 'Subscription successfully',
//                 description: 'Stay tuned for more updates!',
//                 type: ToastificationType.success,
//               );
//               _emailController.clear();
//             } else if (subscriptioProvider.status ==
//                 SubscriptionStatus.alreadyExists) {
//               showCustomToast(
//                 title: 'Already Subscribed',
//                 description: 'This email is already subscribed.',
//                 type: ToastificationType.info,
//               );
//             } else if (subscriptioProvider.status == SubscriptionStatus.error) {
//               showCustomToast(
//                 title: 'Error, Try Again',
//                 description: subscriptioProvider.message ?? 'An error occurred',
//                 type: ToastificationType.error,
//               );
//             }

//             // Reset state after showing toast
//             if (subscriptioProvider.status != SubscriptionStatus.initial &&
//                 subscriptioProvider.status != SubscriptionStatus.loading) {
//               Future.delayed(const Duration(milliseconds: 100), () {
//                 subscriptioProvider.resetState();
//               });
//             }
//           });
//         }

//         return Row(
//           children: [
//             Expanded(
//               child: Container(
//                 height: 40,
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF333333),
//                   borderRadius: BorderRadius.circular(5),
//                 ),
//                 child: TextField(
//                   controller: _emailController,
//                   style: const TextStyle(color: Colors.white),
//                   decoration: const InputDecoration(
//                     contentPadding: EdgeInsets.symmetric(horizontal: 15),
//                     hintText: 'Enter your email',
//                     hintStyle: TextStyle(color: Colors.grey),
//                     border: InputBorder.none,
//                   ),
//                   enabled:
//                       subscriptioProvider.status != SubscriptionStatus.loading,
//                 ),
//               ),
//             ),
//             const SizedBox(width: 12),
//             InkWell(
//               onTap: subscriptioProvider.status == SubscriptionStatus.loading
//                   ? null
//                   : () {
//                       subscriptioProvider
//                           .subscribe(_emailController.text.trim());
//                     },
//               child: Container(
//                 height: 40,
//                 padding: const EdgeInsets.symmetric(horizontal: 15),
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(colors: linerGradient),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Center(
//                   child:
//                       subscriptioProvider.status == SubscriptionStatus.loading
//                           ? const SizedBox(
//                               width: 20,
//                               height: 20,
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2,
//                                 valueColor:
//                                     AlwaysStoppedAnimation<Color>(Colors.black),
//                               ),
//                             )
//                           : const Text(
//                               'Subscribe',
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 14,
//                               ),
//                             ),
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
