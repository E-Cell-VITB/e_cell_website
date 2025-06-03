import 'package:e_cell_website/backend/firebase_services/ongoing_event_service.dart';
import 'package:e_cell_website/backend/models/ongoing_events.dart';
import 'package:flutter/material.dart';

class OngoingEventProvider extends ChangeNotifier {
  final OngoingEventService _eventService = OngoingEventService();

  List<OngoingEvent> _events = [];
  OngoingEvent? _currentEvent;
  List<Schedule> _schedules = [];
  List<EventUpdate> _updates = [];
  bool _isLoadingEvents = false;
  bool _isLoadingSchedules = false;
  bool _isLoadingUpdates = false;
  String? _errorEvents;
  String? _errorSchedules;
  String? _errorUpdates;
  String? _errorRegistration;

  List<OngoingEvent> get events => _events;
  OngoingEvent? get currentEvent => _currentEvent;
  List<Schedule> get schedules => _schedules;
  List<EventUpdate> get updates => _updates;
  bool get isLoadingEvents => _isLoadingEvents;
  bool get isLoadingSchedules => _isLoadingSchedules;
  bool get isLoadingUpdates => _isLoadingUpdates;
  String? get errorEvents => _errorEvents;
  String? get errorSchedules => _errorSchedules;
  String? get errorUpdates => _errorUpdates;
  String? get errorRegistration => _errorRegistration;

  void _setLoading(String type, bool value) {
    switch (type) {
      case 'events':
        _isLoadingEvents = value;
        break;
      case 'schedules':
        _isLoadingSchedules = value;
        break;
      case 'updates':
        _isLoadingUpdates = value;
        break;
    }
    notifyListeners();
  }

  Future<void> fetchEvents() async {
    _setLoading('events', true);
    try {
      _events = await _eventService.getAllEvents();
      print(_events);
      _errorEvents = null;
    } catch (e) {
      _errorEvents = 'Failed to fetch events: $e';
      _events = [];
    } finally {
      _setLoading('events', false);
    }
  }

  Future<void> fetchEventById(String eventId) async {
    _setLoading('events', true);
    try {
      _currentEvent = await _eventService.getEventById(eventId);
      _errorEvents = null;
    } catch (e) {
      _errorEvents = 'Failed to fetch event: $e';
      _currentEvent = null;
    } finally {
      _setLoading('events', false);
    }
  }

  Future<void> fetchSchedules(String eventId) async {
    _setLoading('schedules', true);
    try {
      _schedules = await _eventService.getEventSchedule(eventId);
      _errorSchedules = null;
    } catch (e) {
      _errorSchedules = 'Failed to fetch schedules: $e';
      _schedules = [];
    } finally {
      _setLoading('schedules', false);
    }
  }

  Future<void> fetchUpdates(String eventId) async {
    _setLoading('updates', true);
    try {
      _updates = await _eventService.getEventUpdates(eventId);
      _errorUpdates = null;
    } catch (e) {
      _errorUpdates = 'Failed to fetch updates: $e';
      _updates = [];
    } finally {
      _setLoading('updates', false);
    }
  }

  Future<void> submitRegistration(String eventId, String? teamName,
      List<Map<String, dynamic>> participants) async {
    try {
      _errorRegistration = null;
      await _eventService.submitRegistration(eventId, teamName, participants);
      await fetchEventById(eventId);
      notifyListeners();
    } catch (e) {
      _errorRegistration = 'Failed to submit registration: $e';
      notifyListeners();
      rethrow;
    }
  }

  Future<bool> checkUserRegistration(String eventId) async {
    try {
      return await _eventService.checkUserRegistration(eventId);
    } catch (e) {
      _errorRegistration = 'Failed to check registration: $e';
      notifyListeners();
      return false;
    }
  }

  // Future<bool> checkUserRegistration(String eventId) async {
  //   try {
  //     final user = FirebaseAuth.instance.currentUser;
  //     if (user == null) return false;

  //     final query = await FirebaseFirestore.instance
  //         .collection('events')
  //         .doc(eventId)
  //         .collection('registrations')
  //         .where('userId', isEqualTo: user.uid)
  //         .get();

  //     _isRegistered = query.docs.isNotEmpty;
  //     return _isRegistered;
  //   } catch (e) {
  //     _errorRegistration = 'Error checking registration: $e';
  //     AppLogger.log('Error checking registration: $e');
  //     notifyListeners();
  //     return false;
  //   }
  // }

  // Future<DocumentReference> submitRegistration(
  //   String eventId,
  //   String? teamName,
  //   List<Map<String, dynamic>> participants,
  // ) async {
  //   try {
  //     final user = FirebaseAuth.instance.currentUser;
  //     if (user == null) {
  //       throw Exception('User not authenticated');
  //     }

  //     final registrationData = {
  //       'userId': user.uid,
  //       'teamName': teamName,
  //       'participants': participants,
  //       'timestamp': FieldValue.serverTimestamp(),
  //     };

  //     final docRef = await FirebaseFirestore.instance
  //         .collection('ongoing_events')
  //         .doc(eventId)
  //         .collection('registered_users')
  //         .add(registrationData);

  //     _errorRegistration = null;
  //     notifyListeners();
  //     return docRef;
  //   } catch (e) {
  //     _errorRegistration = 'Failed to submit registration: $e';
  //     AppLogger.log('Error submitting registration: $e');
  //     notifyListeners();
  //     rethrow;
  //   }
  // }
}
