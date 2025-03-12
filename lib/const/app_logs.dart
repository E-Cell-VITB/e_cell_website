import 'package:flutter/foundation.dart';

/// A utility class for logging messages in debug mode only
class AppLogger {
  /// Log a regular info message
  static void log(dynamic message) {
    if (kDebugMode) {
      print('ℹ️ INFO: $message');
    }
  }

  /// Log an error message
  static void error(dynamic message) {
    if (kDebugMode) {
      print('❌ ERROR: $message');
    }
  }

  /// Log a warning message
  static void warning(dynamic message) {
    if (kDebugMode) {
      print('⚠️ WARNING: $message');
    }
  }

  /// Log a success message
  static void success(dynamic message) {
    if (kDebugMode) {
      print('✅ SUCCESS: $message');
    }
  }

  /// Log an object with formatting for better readability
  static void object(String label, dynamic object) {
    if (kDebugMode) {
      print('📦 $label: ${object.toString()}');
    }
  }
}

// Short constant function for quick logging
const logd = AppLogger.log;
