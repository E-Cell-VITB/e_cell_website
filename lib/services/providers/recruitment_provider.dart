import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cell_website/backend/firebase_services/recruitment_service.dart';
import 'package:e_cell_website/backend/models/recruitment_form.dart';
import 'package:e_cell_website/const/app_logs.dart';
import 'package:flutter/foundation.dart';

class RecruitmentProvider extends ChangeNotifier {
  final RecruitmentService _recruitmentService;
  final EmailService _emailService = EmailService();
  // State variables
  bool _isLoading = false;
  String? _errorMessage;
  final List<Map<String, dynamic>> _activeRecruitments = [];
  List<RecruitmentForm> _applications = [];
  RecruitmentForm? _currentApplication;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Map<String, dynamic>> get activeRecruitments => _activeRecruitments;
  List<RecruitmentForm> get applications => _applications;
  RecruitmentForm? get currentApplication => _currentApplication;

  RecruitmentProvider({RecruitmentService? recruitmentService})
      : _recruitmentService = recruitmentService ?? RecruitmentService();

  // Fetch all active recruitments
  Stream<QuerySnapshot> getOpenRecruitments() {
    try {
      return _recruitmentService.getOpenRecruitments();
    } catch (e) {
      _errorMessage = 'Error loading recruitments: $e';
      AppLogger.log(e);
      notifyListeners();
      // Return an empty stream to avoid null issues
      return Stream<QuerySnapshot>.error(e);
    }
  }

  // Fetch applications for a specific recruitment
  Future<void> fetchApplicationsForRecruitment(String recruitmentId) async {
    _setLoading(true);

    try {
      final snapshot = await _recruitmentService
          .getApplicationsForRecruitment(recruitmentId);
      _applications = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return RecruitmentForm.fromJson({
          'applicationId': doc.id,
          ...data,
        });
      }).toList();

      _setLoading(false);
    } catch (e) {
      _handleError('Failed to fetch applications: ${e.toString()}');
    }
  }

  Future<void> checkEmail(String email, String recruitmentId) async {
    try {
      final hasApplied =
          await _recruitmentService.hasUserApplied(recruitmentId, email);

      if (hasApplied) {
        _handleError('You have already applied for this recruitment');
        return;
      }
    } catch (e) {
      _handleError('Failed to submit application: ${e.toString()}');
      return;
    }
  }

  // Submit a new application
  Future<String?> submitApplication(
      RecruitmentForm application, String dept) async {
    _setLoading(true);

    try {
      // Check if user has already applied
      final hasApplied = await _recruitmentService.hasUserApplied(
          application.recruitmentId, application.emailAddress);

      if (hasApplied) {
        _handleError('You have already applied for this recruitment');
        return null;
      }

      // Submit the application
      final docRef = await _recruitmentService.submitApplication(application);

      // Update the application with the new ID
      _currentApplication = application.copyWith(applicationId: docRef.id);
      await _emailService.sendApplicationReceivedEmail(
        email: application.emailAddress,
        name: application.name,
        position: dept,
      );
      _setLoading(false);
      return docRef.id;
    } catch (e) {
      _handleError('Failed to submit application: ${e.toString()}');
      return null;
    }
  }

  // Check application status
  Future<String?> checkApplicationStatus(String applicationId) async {
    _setLoading(true);

    try {
      final status =
          await _recruitmentService.getApplicationStatus(applicationId);
      _setLoading(false);
      return status;
    } catch (e) {
      _handleError('Failed to check application status: ${e.toString()}');
      return null;
    }
  }

  // Get application count for a recruitment
  Future<int> getApplicationCount(String recruitmentId) async {
    try {
      final snapshot = await _recruitmentService
          .getApplicationsForRecruitment(recruitmentId);
      return snapshot.size;
    } catch (e) {
      _handleError('Failed to get application count: ${e.toString()}');
      return 0;
    }
  }

  // Clear current application data
  void clearCurrentApplication() {
    _currentApplication = null;
    notifyListeners();
  }

  // Helper method to set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    if (loading) {
      _errorMessage = null;
    }
    notifyListeners();
  }

  // Helper method to handle errors
  void _handleError(String message) {
    _isLoading = false;
    _errorMessage = message;
    debugPrint('RecruitmentProvider Error: $message');
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
