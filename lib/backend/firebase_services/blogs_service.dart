import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cell_website/backend/models/blog.dart';
// import 'package:flutter/material.dart';

class BlogService {
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _blogsCollection =
      FirebaseFirestore.instance.collection('blogs');

  // Get all blogs as a stream
  Stream<List<Blog>> getBlogs() {
    return _blogsCollection
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Blog.fromMap(data);
      }).toList();
    });
  }
}
