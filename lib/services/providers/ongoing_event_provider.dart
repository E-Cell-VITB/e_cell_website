import 'dart:async';
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

  // Stream subscriptions for real-time updates
  StreamSubscription<List<OngoingEvent>>? _eventsSubscription;
  StreamSubscription<OngoingEvent?>? _currentEventSubscription;
  StreamSubscription<List<Schedule>>? _schedulesSubscription;
  StreamSubscription<List<EventUpdate>>? _updatesSubscription;

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
    } catch (e) {
      _errorEvents = 'Failed to fetch events: $e';
      _events = [];
    } finally {
      _setLoading('events', false);
      notifyListeners();
    }
  }

  /// Start listening to real-time events stream
  void startEventsStream() {
    _eventsSubscription?.cancel();
    _setLoading('events', true);

    _eventsSubscription = _eventService.getAllEventsStream().listen(
      (events) {
        _events = events;
        _errorEvents = null;
        _setLoading('events', false);
      },
      onError: (error) {
        _errorEvents = 'Failed to stream events: $error';
        _events = [];
        _setLoading('events', false);
      },
    );
  }

  /// Stop listening to events stream
  void stopEventsStream() {
    _eventsSubscription?.cancel();
    _eventsSubscription = null;
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

  /// Start listening to real-time event stream for specific event
  void startEventByIdStream(String eventId) {
    _currentEventSubscription?.cancel();
    _setLoading('events', true);

    _currentEventSubscription =
        _eventService.getEventByIdStream(eventId).listen(
      (event) {
        _currentEvent = event;
        _errorEvents = null;
        _setLoading('events', false);
      },
      onError: (error) {
        _errorEvents = 'Failed to stream event: $error';
        _currentEvent = null;
        _setLoading('events', false);
      },
    );
  }

  /// Stop listening to current event stream
  void stopEventByIdStream() {
    _currentEventSubscription?.cancel();
    _currentEventSubscription = null;
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

  /// Start listening to real-time schedules stream
  void startSchedulesStream(String eventId) {
    _schedulesSubscription?.cancel();
    _setLoading('schedules', true);

    _schedulesSubscription =
        _eventService.getEventScheduleStream(eventId).listen(
      (schedules) {
        _schedules = schedules;
        _errorSchedules = null;
        _setLoading('schedules', false);
      },
      onError: (error) {
        _errorSchedules = 'Failed to stream schedules: $error';
        _schedules = [];
        _setLoading('schedules', false);
      },
    );
  }

  /// Stop listening to schedules stream
  void stopSchedulesStream() {
    _schedulesSubscription?.cancel();
    _schedulesSubscription = null;
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

  /// Start listening to real-time updates stream
  void startUpdatesStream(String eventId) {
    _updatesSubscription?.cancel();
    _setLoading('updates', true);

    _updatesSubscription = _eventService.getEventUpdatesStream(eventId).listen(
      (updates) {
        _updates = updates;
        _errorUpdates = null;
        _setLoading('updates', false);
      },
      onError: (error) {
        _errorUpdates = 'Failed to stream updates: $error';
        _updates = [];
        _setLoading('updates', false);
      },
    );
  }

  /// Stop listening to updates stream
  void stopUpdatesStream() {
    _updatesSubscription?.cancel();
    _updatesSubscription = null;
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

  /// Start comprehensive real-time streaming for an event
  void startEventStreaming(String eventId) {
    startEventByIdStream(eventId);
    startSchedulesStream(eventId);
    startUpdatesStream(eventId);
  }

  /// Stop all real-time streaming
  void stopAllStreaming() {
    stopEventsStream();
    stopEventByIdStream();
    stopSchedulesStream();
    stopUpdatesStream();
  }

  @override
  void dispose() {
    stopAllStreaming();
    super.dispose();
  }
}
