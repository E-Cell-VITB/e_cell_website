import 'package:e_cell_website/backend/firebase_services/events_service.dart';
import 'package:e_cell_website/backend/models/event.dart';
import 'package:flutter/material.dart';

class EventProvider extends ChangeNotifier {
  final EventService _eventService = EventService();

  String? _error;
  String? get error => _error;

  // Method to get stream of events
  Stream<List<Event>> getEventsStream() {
    return _eventService.getEvents();
  }

  // Optional: Method to get a single event
  Future<Event?> getEventById(String eventId) async {
    try {
      return await _eventService.getEventById(eventId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  // Reset error
  void resetError() {
    _error = null;
    notifyListeners();
  }
}
