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

  // Getters
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

  // Set loading state and notify listeners
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

  // Fetch all events from Firestore
  Future<void> fetchEvents() async {
    _setLoading('events', true);
    try {
      _events = await _eventService.getAllEvents();
      _errorEvents = null;
    } catch (e) {
      _errorEvents = 'Failed to fetch events: $e';
      _events = [];
    } finally {
      _setLoading('events', false);
    }
  }

  // Fetch a single event by ID
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

  // Fetch schedules for an event
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

  // Fetch updates for an event
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
}
