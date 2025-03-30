import 'package:toastification/toastification.dart';

import 'package:flutter/material.dart';

void showCustomToast({
  // required BuildContext context,
  required String title,
  required String description,
  ToastificationType type = ToastificationType.success,
  Duration duration = const Duration(seconds: 4),
}) {
  toastification.show(
    // context: context,
    type: type,
    style: ToastificationStyle.flat,
    title: Text(
      title,
      // style: TextStyle(
      //   color: Colors.white,
      //   fontWeight: FontWeight.bold,
      // ),
    ),
    description: Text(
      description,
      // style: TextStyle(
      //   color: Colors.white70,
      // ),
    ),
    alignment: Alignment.topRight,
    autoCloseDuration: duration,
    icon: const Icon(Icons.check_circle),
    backgroundColor: Colors.white,
    dragToClose: true,
    // applyBlurEffect: true,
    // backgroundColor: Colors.black38,
    borderRadius: BorderRadius.circular(10),
    // borderSide: BorderSide(),
    showProgressBar: true,
  );
}
