import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cell_website/backend/models/ongoing_events.dart';
import 'package:e_cell_website/const/app_logs.dart';

class OngoingEventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _eventsCollection = 'ongoing_events';
  Future<List<OngoingEvent>> getAllEvents() async {
    try {
      final snapshot = await _firestore.collection(_eventsCollection).get();
      return snapshot.docs
          .map((doc) => OngoingEvent.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      AppLogger.error('Error fetching events: $e');
      return [];
    }
  }

  Future<OngoingEvent?> getEventById(String eventId) async {
    try {
      final doc =
          await _firestore.collection(_eventsCollection).doc(eventId).get();
      if (doc.exists) {
        return OngoingEvent.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      AppLogger.error('Error fetching event by ID: $e');
      return null;
    }
  }

  // Schedule operations
  Future<List<Schedule>> getEventSchedule(String eventId) async {
    try {
      final snapshot = await _firestore
          .collection(_eventsCollection)
          .doc(eventId)
          .collection('schedule')
          .orderBy('scheduledTime')
          .get();

      return snapshot.docs
          .map((doc) => Schedule.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      AppLogger.error('Error fetching schedule: $e');
      return [];
    }
  }

  // Updates operations
  Future<List<EventUpdate>> getEventUpdates(String eventId) async {
    try {
      final snapshot = await _firestore
          .collection(_eventsCollection)
          .doc(eventId)
          .collection('updates')
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => EventUpdate.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      AppLogger.error('Error fetching updates: $e');
      return [];
    }
  }
}
