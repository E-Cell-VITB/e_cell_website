import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cell_website/backend/models/gallery.dart';

class GalleryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Gallery>> getGalleries({bool descending = true}) {
    return _firestore
        .collection('events')
        .orderBy('eventDate', descending: descending)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Gallery.fromMap(data);
      }).toList();
    });
  }

  Future<Gallery> getGalleryById(String id) async {
    final doc = await _firestore.collection('events').doc(id).get();
    if (doc.exists) {
      final data = doc.data()!;
      data['id'] = doc.id;
      return Gallery.fromMap(data);
    } else {
      throw Exception('Gallery not found');
    }
  }
}
