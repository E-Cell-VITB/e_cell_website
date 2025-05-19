import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cell_website/backend/models/recruitment_form.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
    final applicationData = application.toJson();

    applicationData['submittedAt'] = FieldValue.serverTimestamp();

    final docRef = await _firestore
        .collection(_applicationsCollection)
        .add(applicationData);

    await docRef.update({'applicationId': docRef.id});

    return docRef;
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

class EmailService {
  final String _appsScriptUrl =
      'https://script.google.com/macros/s/AKfycby2Pcia2T8pFblgmRm7Ls_Y1w6PGuM4mEseVJ-KzB0y1SdGjhXFjMwgIKYjfO0pASzO/exec';

  /// Sends an application received email via Apps Script
  Future<void> sendApplicationReceivedEmail({
    required String email,
    required String name,
    required String position,
  }) async {
    await _sendEmail(
      action: 'applicationReceived',
      email: email,
      name: name,
      position: position,
      operationName: 'application submission',
    );
  }

  /// Private helper method to handle all types of email sending
  Future<void> _sendEmail({
    required String action,
    required String email,
    required String name,
    required String position,
    required String operationName,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse(_appsScriptUrl),
            body: jsonEncode({
              'action': action,
              'email': email,
              'name': name,
              'position': position,
            }),
          )
          .timeout(const Duration(seconds: 30));

      final data = jsonDecode(response.body);

      if (data['success'] != true) {
        final errorMessage =
            data['error'] ?? 'Failed to send $operationName email';

        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Error sending $operationName email: $e');
    }
  }

  /// Returns the current Apps Script URL
  String getAppsScriptUrl() => _appsScriptUrl;
}
