// subscription_provider.dart
import 'package:e_cell_website/backend/firebase_services/subscription_service.dart';
import 'package:flutter/material.dart';

// Subscription status enum
enum SubscriptionStatus { initial, loading, success, alreadyExists, error }

// Subscription state model
class SubscriptionProvider extends ChangeNotifier {
  final SubscriptionService _service = SubscriptionService();
  SubscriptionStatus _status = SubscriptionStatus.initial;
  String? _message;

  SubscriptionStatus get status => _status;
  String? get message => _message;

  SubscriptionProvider() {
    _initService();
  }

  Future<void> _initService() async {
    await _service.init();
  }

  Future<void> subscribe(String email) async {
    if (email.trim().isEmpty) {
      _status = SubscriptionStatus.error;
      _message = 'Please enter a valid email address.';
      notifyListeners();
      return;
    }

    // Email validation regex
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      _status = SubscriptionStatus.error;
      _message = 'Please enter a valid email address.';
      notifyListeners();
      return;
    }

    try {
      _status = SubscriptionStatus.loading;
      _message = null;
      notifyListeners();

      final added = await _service.addSubscriber(email);

      if (added) {
        _status = SubscriptionStatus.success;
        _message = 'Successfully subscribed!';
      } else {
        _status = SubscriptionStatus.alreadyExists;
        _message = 'Email already subscribed.';
      }
    } catch (e) {
      _status = SubscriptionStatus.error;
      _message = 'An error occurred: ${e.toString()}';
    }

    notifyListeners();
  }

  void resetState() {
    _status = SubscriptionStatus.initial;
    _message = null;
    notifyListeners();
  }
}
