import 'package:e_cell_website/backend/models/event.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class EventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'events';

  Stream<List<Event>> getEvents() {
    return _firestore
        .collection(_collection)
        .orderBy('eventDate', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        data['id'] = doc.id; // Add document ID to the map
        return Event.fromMap(data);
      }).toList();
    });
  }

  Future<Event?> getEventById(String eventId) async {
    DocumentSnapshot doc =
        await _firestore.collection(_collection).doc(eventId).get();

    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return Event.fromMap(data);
    }

    return null;
  }
}
