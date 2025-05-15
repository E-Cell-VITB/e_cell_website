import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cell_website/backend/models/recruitment_form.dart';

class RecruitmentService {
  final FirebaseFirestore _firestore;
  final String _applicationsCollection = 'applications';
  final String _recruitmentsCollection = 'recruitments';
  final CollectionReference _recruitmentsCollectionRef =
      FirebaseFirestore.instance.collection('recruitments');
  RecruitmentService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // Get all active recruitments
  Stream<QuerySnapshot> getOpenRecruitments() {
    try {
      return _recruitmentsCollectionRef
          .where('status', isEqualTo: 'open')
          .orderBy('createdAt', descending: true)
          .snapshots();
    } catch (e) {
      // Log the error for debugging
      print('Error getting open recruitments: $e');
      // Rethrow to allow the provider to handle it
      throw Exception('Failed to load recruitments: $e');
    }
  }

  // Get a specific recruitment by ID
  Future<DocumentSnapshot> getRecruitmentById(String recruitmentId) {
    return _firestore
        .collection(_recruitmentsCollection)
        .doc(recruitmentId)
        .get();
  }

  // Get all applications for a specific recruitment
  Future<QuerySnapshot> getApplicationsForRecruitment(String recruitmentId) {
    return _firestore
        .collection(_applicationsCollection)
        .where('recruitmentId', isEqualTo: recruitmentId)
        .get();
  }

  // Submit a new application
  Future<DocumentReference> submitApplication(
      RecruitmentForm application) async {
    // Convert application to JSON
    final applicationData = application.toJson();

    // Add timestamp
    applicationData['submittedAt'] = FieldValue.serverTimestamp();

    // Add to Firestore
    return _firestore.collection(_applicationsCollection).add(applicationData);
  }

  // Update an existing application
  Future<void> updateApplication(
      String applicationId, RecruitmentForm application) {
    return _firestore
        .collection(_applicationsCollection)
        .doc(applicationId)
        .update(application.toJson());
  }

  // Check if user has already applied for this recruitment
  Future<bool> hasUserApplied(String recruitmentId, String email) async {
    final result = await _firestore
        .collection(_applicationsCollection)
        .where('recruitmentId', isEqualTo: recruitmentId)
        .where('emailAddress', isEqualTo: email)
        .limit(1)
        .get();

    return result.docs.isNotEmpty;
  }

  // Get application status
  Future<String?> getApplicationStatus(String applicationId) async {
    final doc = await _firestore
        .collection(_applicationsCollection)
        .doc(applicationId)
        .get();

    if (doc.exists) {
      final data = doc.data();
      return data?['status'] as String?;
    }

    return null;
  }
}
