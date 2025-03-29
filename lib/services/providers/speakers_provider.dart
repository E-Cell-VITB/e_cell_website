// speaker_provider.dart
import 'package:e_cell_website/backend/firebase_services/speakers_service.dart';
import 'package:e_cell_website/backend/models/speaker.dart';
import 'package:flutter/foundation.dart';

class SpeakerProvider extends ChangeNotifier {
  final SpeakerService _speakerService = SpeakerService();

  String? _error;

  String? get error => _error;

  Stream<List<Speaker>> getSpeakersStream() {
    return _speakerService.getSpeakers();
  }
}
