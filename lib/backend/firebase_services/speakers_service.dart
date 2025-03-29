// speaker_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cell_website/backend/models/speaker.dart';

class SpeakerService {
  final CollectionReference _speakersCollection =
      FirebaseFirestore.instance.collection('speakers');

  Stream<List<Speaker>> getSpeakers() {
    return _speakersCollection.orderBy('position').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Speaker.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }
}
