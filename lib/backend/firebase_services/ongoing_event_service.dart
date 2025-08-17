import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cell_website/backend/models/ongoing_events.dart';
import 'package:e_cell_website/const/app_logs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:e_cell_website/backend/models/evalution_result.dart'
    as result_model;

class OngoingEventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String _eventsCollection = 'ongoing_events';

  Future<List<OngoingEvent>> getAllEvents() async {
    try {
      final snapshot = await _firestore
          .collection(_eventsCollection)
          .where("isEventLive", isEqualTo: true)
          .get();

      return snapshot.docs
          .map((doc) => OngoingEvent.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      AppLogger.error('Error fetching events: $e');
      return [];
    }
  }

  /// Stream of all live events - rebuilds when Firestore data changes
  Stream<List<OngoingEvent>> getAllEventsStream() {
    try {
      return _firestore
          .collection(_eventsCollection)
          .where("isEventLive", isEqualTo: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => OngoingEvent.fromMap(doc.data(), doc.id))
              .toList());
    } catch (e) {
      AppLogger.error('Error streaming events: $e');
      return Stream.value([]);
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

  /// Stream of a specific event by ID - rebuilds when Firestore data changes
  Stream<OngoingEvent?> getEventByIdStream(String eventId) {
    try {
      return _firestore
          .collection(_eventsCollection)
          .doc(eventId)
          .snapshots()
          .map((doc) {
        if (doc.exists) {
          return OngoingEvent.fromMap(doc.data()!, doc.id);
        }
        return null;
      });
    } catch (e) {
      AppLogger.error('Error streaming event by ID: $e');
      return Stream.value(null);
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

  /// Stream of event schedule - rebuilds when schedule changes
  Stream<List<Schedule>> getEventScheduleStream(String eventId) {
    try {
      return _firestore
          .collection(_eventsCollection)
          .doc(eventId)
          .collection('schedule')
          .orderBy('scheduledTime')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => Schedule.fromMap(doc.data(), doc.id))
              .toList());
    } catch (e) {
      AppLogger.error('Error streaming schedule: $e');
      return Stream.value([]);
    }
  }

  Future<List<EventUpdate>> getEventUpdates(String eventId) async {
    try {
      final snapshot = await _firestore
          .collection(_eventsCollection)
          .doc(eventId)
          .collection('updates')
          .orderBy('updateLiveStartTime', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => EventUpdate.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      AppLogger.error('Error fetching updates: $e');
      return [];
    }
  }

  /// Stream of event updates - rebuilds when new updates are added
  Stream<List<EventUpdate>> getEventUpdatesStream(String eventId) {
    try {
      return _firestore
          .collection(_eventsCollection)
          .doc(eventId)
          .collection('updates')
          .orderBy('updateLiveStartTime', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => EventUpdate.fromMap(doc.data(), doc.id))
              .toList());
    } catch (e) {
      AppLogger.error('Error streaming updates: $e');
      return Stream.value([]);
    }
  }

  Future<void> submitRegistration(String eventId, String? teamName,
      List<Map<String, dynamic>> participants) async {
    try {
      if (_auth.currentUser == null) {
        throw Exception('User must be signed in to register for an event');
      }

      final batch = _firestore.batch();

      final eventRef = _firestore.collection(_eventsCollection).doc(eventId);

      final registeredUsersRef = eventRef.collection('registered_users');
      final docRef = registeredUsersRef.doc();

      for (var i in participants) {
        i.addAll({
          'isCheckedIn': false,
          'checkedInBy': '',
          'checkedInAt': null,
        });
      }

      batch.set(docRef, {
        'team_name': teamName ?? 'Individual',
        'participants': participants,
        'registeredAt': Timestamp.now(),
        'teamDocId': docRef.id,
      });

      final eventDoc = await eventRef.get();
      if (!eventDoc.exists) {
        throw Exception('Event does not exist');
      }
      final eventData = eventDoc.data()!;
      final isTeamEvent = eventData['isTeamEvent'] as bool? ?? false;

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

  /// Stream to check user registration status - rebuilds when registration changes
  Stream<bool> checkUserRegistrationStream(String eventId) {
    try {
      if (_auth.currentUser == null) {
        return Stream.value(false);
      }

      return _firestore
          .collection(_eventsCollection)
          .doc(eventId)
          .collection('registered_users')
          .where('userId', isEqualTo: _auth.currentUser!.uid)
          .snapshots()
          .map((snapshot) => snapshot.docs.isNotEmpty);
    } catch (e) {
      AppLogger.error('Error streaming registration status: $e');
      return Stream.value(false);
    }
  }

  /// Stream of registered users for an event - rebuilds when new registrations occur
  Stream<List<Map<String, dynamic>>> getRegisteredUsersStream(String eventId) {
    try {
      return _firestore
          .collection(_eventsCollection)
          .doc(eventId)
          .collection('registered_users')
          .orderBy('registeredAt', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => {
                    'id': doc.id,
                    ...doc.data(),
                  })
              .toList());
    } catch (e) {
      AppLogger.error('Error streaming registered users: $e');
      return Stream.value([]);
    }
  }

  /// Stream of real-time participant count for an event
  Stream<Map<String, int>> getParticipantCountStream(String eventId) {
    try {
      return _firestore
          .collection(_eventsCollection)
          .doc(eventId)
          .snapshots()
          .map((doc) {
        if (doc.exists) {
          final data = doc.data()!;
          return {
            'numParticipants': data['numParticipants'] as int? ?? 0,
            'numTeams': data['numTeams'] as int? ?? 0,
          };
        }
        return {'numParticipants': 0, 'numTeams': 0};
      });
    } catch (e) {
      AppLogger.error('Error streaming participant count: $e');
      return Stream.value({'numParticipants': 0, 'numTeams': 0});
    }
  }

  //get team name by team id
  Future<String?> getTeamNameById(String eventId, String teamId) async {
    try {
      final doc = await _firestore
          .collection(_eventsCollection)
          .doc(eventId)
          .collection('registered_users')
          .doc(teamId)
          .get();
      if (doc.exists) {
        return doc.data()?['team_name'] as String?;
      }
      return null;
    } catch (e) {
      AppLogger.error('Error fetching team name by ID: $e');
      return null;
    }
  }

  //get teams by event id
  /// Fetches list of team IDs (document IDs) from registered_users collection
  /// Returns List<String> of document IDs
  Future<List<String>> getTeamsByEventId(String eventId) async {
    try {
      final snapshot = await _firestore
          .collection(_eventsCollection)
          .doc(eventId)
          .collection('registered_users')
          .get();

      return snapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      AppLogger.error('Error fetching teams by event ID: $e');
      return [];
    }
  }

  /// Stream that returns assigned marks array for a specific team
  /// Extracts assignedMarks from scores[0] in the results collection

//...
  Stream<List<result_model.EvaluationResult>> getResultsByTeamId(
      String eventId, String teamId) {
    try {
      return _firestore
          .collection(_eventsCollection)
          .doc(eventId)
          .collection('results')
          .where('teamId', isEqualTo: teamId)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) =>
                result_model.EvaluationResult.fromMap(doc.data(), doc.id))
            .toList();
      });
    } catch (e) {
      AppLogger.error('Error streaming results by team ID: $e');
      return Stream.value([]);
    }
  }

  Future<List<String>> getRestrictedRegistrationNumbers(String eventId) async {
    try {
      final doc =
          await _firestore.collection(_eventsCollection).doc(eventId).get();

      if (doc.exists) {
        final data = doc.data()!;
        return List<String>.from(data['restrictedRegistrationNumbers'] ?? []);
      }
      return [];
    } catch (e) {
      AppLogger.error('Error fetching restricted registration numbers: $e');
      return [];
    }
  }
}
