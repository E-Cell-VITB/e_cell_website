import 'package:cloud_firestore/cloud_firestore.dart';

class EvaluationResult {
  final String? id;
  final String teamId;
  final String teamName;
  final List<ScoresModel> scores;

  EvaluationResult({
    this.id,
    required this.teamId,
    required this.teamName,
    required this.scores,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'teamId': teamId,
      'teamName': teamName,
      'scores': scores.map((s) => s.toJson()).toList(),
    };
  }

  factory EvaluationResult.fromMap(Map<String, dynamic> map, String id) {
    return EvaluationResult(
      id: id,
      teamId: map['teamId'] as String? ?? '',
      teamName: map['teamName'] as String? ?? '',
      scores: (map['scores'] as List)
          .map((s) => ScoresModel.fromJson(s as Map<String, dynamic>))
          .toList(),
    );
  }

  double get totalScore {
    if (scores.isEmpty) return 0;
    if (scores.isEmpty) return 0;
    final total = scores.fold(0, (total, scorer) {
      return total +
          scorer.assignedMarks.fold(
              0,
              (sum, markMap) =>
                  sum +
                  markMap.values.fold(0, (mapSum, score) => mapSum + score));
    });
    return (total / scores.length);
  }

  List<ScoresModel> get latestScoresPerJury {
    final Map<String, ScoresModel> latestScoresMap = {};
    for (final score in scores) {
      final existing = latestScoresMap[score.juryEmail];
      if (existing == null) {
        latestScoresMap[score.juryEmail] = score;
      }
    }
    return latestScoresMap.values.toList();
  }
}

class ScoresModel {
  final String juryEmail;
  final List<Map<String, int>> assignedMarks;// Reason for marks change (optional)

  ScoresModel({
    required this.juryEmail,
    required this.assignedMarks,
  });

  factory ScoresModel.fromJson(Map<String, dynamic> json) {
    return ScoresModel(
      juryEmail: json['juryEmail'] as String,
      assignedMarks: List<Map<String, int>>.from(
        (json['assignedMarks'] as List).map(
          (item) => Map<String, int>.from(item as Map),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'juryEmail': juryEmail,
      'assignedMarks':
          assignedMarks.map((mark) => Map<String, dynamic>.from(mark)).toList(),
    };
  }
}
