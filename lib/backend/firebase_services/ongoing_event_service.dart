import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cell_website/backend/models/ongoing_events.dart';
import 'package:e_cell_website/const/app_logs.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OngoingEventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
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

  Future<void> submitRegistration(String eventId, String? teamName,
      List<Map<String, dynamic>> participants) async {
    try {
      if (_auth.currentUser == null) {
        throw Exception('User must be signed in to register for an event');
      }

      final batch = _firestore.batch();

      // Reference to the event document
      final eventRef = _firestore.collection(_eventsCollection).doc(eventId);

      // Reference to the registered users collection
      final registeredUsersRef = eventRef.collection('registered_users');
      final docRef = registeredUsersRef.doc();

      // Store registration data
      batch.set(docRef, {
        'team_name': teamName ?? 'Individual',
        'participants': participants,
        'registeredAt': Timestamp.now(),
        'userId': _auth.currentUser!.uid,
      });

      // Get the event to check if it's a team event
      final eventDoc = await eventRef.get();
      if (!eventDoc.exists) {
        throw Exception('Event does not exist');
      }
      final eventData = eventDoc.data()!;
      final isTeamEvent = eventData['isTeamEvent'] as bool? ?? false;

      // Update numTeams and numParticipants atomically
      if (isTeamEvent) {
        batch.update(eventRef, {
          'numTeams': FieldValue.increment(1),
          'numParticipants': FieldValue.increment(participants.length),
        });
      } else {
        batch.update(eventRef, {
          'numParticipants': FieldValue.increment(1),
        });
      }

      await batch.commit();
    } catch (e) {
      AppLogger.error('Error submitting registration: $e');
      rethrow;
    }
  }

  Future<bool> checkUserRegistration(String eventId) async {
    try {
      if (_auth.currentUser == null) {
        return false;
      }

      final snapshot = await _firestore
          .collection(_eventsCollection)
          .doc(eventId)
          .collection('registered_users')
          .where('userId', isEqualTo: _auth.currentUser!.uid)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      AppLogger.error('Error checking registration: $e');
      return false;
    }
  }
}
