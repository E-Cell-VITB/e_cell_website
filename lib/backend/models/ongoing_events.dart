import 'package:cloud_firestore/cloud_firestore.dart';

class OngoingEvent {
  final String? id;
  final String name;
  final String description;
  final DateTime eventDate;
  final DateTime? registrationStarts;
  final DateTime? registrationEnds;
  final Timestamp createdAt;
  final String status;
  final DateTime? estimatedEndTime;
  final List<WinnerPhotos> winnerPhotos;
  final List<String> allPhotos;
  final List<Map<String, String>> socialLink;
  final int numParticipants;
  final int numTeams;
  final List<JuryMember> jury;
  final double? prizePool;
  final String place;
  final String bannerPhotoUrl;
  final String certificatesScript;
  final bool isTeamEvent;
  final int maxTeamSize;
  final int? minTeamSize;
  final List<EvaluationCriteria> evaluationTemplate;
  final List<RegistrationField> registrationTemplate;
  bool isEventLive;
  bool isResultLive;
  final int position;
  String? thankYouEmailAppScriptUrl;
  final String department;

  OngoingEvent({
    this.id,
    required this.name,
    required this.description,
    required this.eventDate,
    required this.createdAt,
    required this.status,
    this.estimatedEndTime,
    required this.winnerPhotos,
    required this.allPhotos,
    required this.socialLink,
    required this.numParticipants,
    required this.numTeams,
    required this.jury,
    this.prizePool = 0.0,
    required this.place,
    required this.bannerPhotoUrl,
    required this.certificatesScript,
    required this.isTeamEvent,
    required this.maxTeamSize,
    required this.evaluationTemplate,
    required this.registrationTemplate,
    required this.registrationStarts,
    required this.registrationEnds,
    this.isEventLive = false,
    this.minTeamSize,
    this.position = 0,
    this.isResultLive = false,
    this.thankYouEmailAppScriptUrl = '',
    required this.department,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name.trim(),
      'description': description.trim(),
      'eventDate': Timestamp.fromDate(eventDate),
      'createdAt': createdAt,
      'status': status,
      'estimatedEndTime': estimatedEndTime ?? Timestamp.fromDate(eventDate),
      'winnerPhotos': winnerPhotos,
      'allPhotos': allPhotos,
      'socialLink': socialLink,
      'numParticipants': numParticipants,
      'numTeams': numTeams,
      'jury': jury.map((member) => member.toMap()).toList(),
      'prizePool': prizePool ?? 0.0,
      'place': place,
      'bannerPhotoUrl': bannerPhotoUrl,
      'certificatesScript': certificatesScript,
      'isTeamEvent': isTeamEvent,
      'maxTeamSize': maxTeamSize,
      'evaluationTemplate':
          evaluationTemplate.map((criteria) => criteria.toMap()).toList(),
      'registrationTemplate':
          registrationTemplate.map((field) => field.toMap()).toList(),
      'registrationStarts': registrationStarts != null
          ? Timestamp.fromDate(registrationStarts!)
          : null,
      'registrationEnds': registrationEnds != null
          ? Timestamp.fromDate(registrationEnds!)
          : null,
      'isEventLive': isEventLive,
      'minTeamSize': minTeamSize ?? 1,
      'position': position,
      'thankYouEmailAppScriptUrl': thankYouEmailAppScriptUrl,
      'department': department,
    };
  }

  factory OngoingEvent.fromMap(Map<String, dynamic> map, String id) {
    return OngoingEvent(
      id: id,
      name: map['name'] as String? ?? '',
      description: map['description'] as String? ?? '',
      eventDate: (map['eventDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdAt: map['createdAt'] as Timestamp? ?? Timestamp.now(),
      status: map['status'] as String? ?? 'Upcoming',
      estimatedEndTime: map['estimatedEndTime'] != null
          ? (map['estimatedEndTime'] as Timestamp).toDate()
          : null,
      winnerPhotos: (map['winnerPhotos'] as List<dynamic>?)
              ?.map((e) => WinnerPhotos.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      allPhotos: List<String>.from(map['allPhotos'] ?? []),
      socialLink: (map['socialLink'] as List<dynamic>)
          .map((e) => Map<String, String>.from(e as Map))
          .toList(),
      numParticipants: (map['numParticipants'] as int?) ?? 0,
      numTeams: (map['numTeams'] as int?) ?? 0,
      jury: (map['jury'] as List<dynamic>?)
              ?.map((e) => JuryMember.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      prizePool: (map['prizePool'] as num?)?.toDouble() ?? 0.0,
      place: map['place'] as String? ?? 'VITB, Bhimavaram',
      bannerPhotoUrl: map['bannerPhotoUrl'] as String? ?? '',
      certificatesScript: map['certificatesScript'] as String? ?? '',
      isTeamEvent: map['isTeamEvent'] as bool? ?? false,
      maxTeamSize: map['maxTeamSize'] as int? ?? 1,
      evaluationTemplate: (map['evaluationTemplate'] as List<dynamic>?)
              ?.map(
                  (e) => EvaluationCriteria.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      registrationTemplate: (map['registrationTemplate'] as List<dynamic>?)
              ?.map((e) => RegistrationField.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      registrationStarts: (map['registrationStarts'] as Timestamp?)?.toDate(),
      registrationEnds: (map['registrationEnds'] as Timestamp?)?.toDate(),
      minTeamSize: (map['minTeamSize'] as int?) ?? 1,
      position: (map['position'] as int?) ?? 0,
      isEventLive: map['isEventLive'] as bool? ?? false,
      thankYouEmailAppScriptUrl:
          map['thankYouEmailAppScriptUrl'] as String? ?? '',
      department: map['department'] as String? ?? '',
    );
  }
}

class RegistrationField {
  final String fieldName;
  final String inputType;
  final bool isRequired;

  RegistrationField({
    required this.fieldName,
    required this.inputType,
    required this.isRequired,
  });

  Map<String, dynamic> toMap() {
    return {
      'fieldName': fieldName,
      'inputType': inputType.toLowerCase(),
      'isRequired': isRequired,
    };
  }

  factory RegistrationField.fromMap(Map<String, dynamic> map) {
    return RegistrationField(
      fieldName: map['fieldName'] as String? ?? '',
      inputType: map['inputType'] as String? ?? 'text',
      isRequired: map['isRequired'] as bool? ?? false,
    );
  }
}

class Schedule {
  final String? id;
  final String title;
  final String description;
  final Timestamp scheduledTime;
  final Timestamp? expectedEndTime;
  final String status;

  Schedule({
    this.id,
    required this.title,
    required this.description,
    required this.scheduledTime,
    this.expectedEndTime,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'scheduledTime': scheduledTime,
      'expectedEndTime': expectedEndTime,
      'status': status,
    };
  }

  factory Schedule.fromMap(Map<String, dynamic> map, String id) {
    return Schedule(
      id: id,
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      scheduledTime: map['scheduledTime'] as Timestamp? ?? Timestamp.now(),
      expectedEndTime: map['expectedEndTime'] as Timestamp?,
      status: map['status'] as String? ?? 'Scheduled',
    );
  }
}

class EventUpdate {
  final String? id;
  final String title;
  final String message;
  final Timestamp updateLiveStartTime;
  final Timestamp updateLiveEndTime;

  EventUpdate({
    this.id,
    required this.title,
    required this.message,
    required this.updateLiveStartTime,
    required this.updateLiveEndTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'message': message,
      'updateLiveStartTime': updateLiveStartTime,
      'updateLiveEndTime': updateLiveEndTime,
    };
  }

  factory EventUpdate.fromMap(Map<String, dynamic> map, String id) {
    return EventUpdate(
        title: map['title'] as String? ?? '',
        id: id,
        message: map['message'] as String? ?? '',
        updateLiveStartTime: map['updateLiveStartTime'],
        updateLiveEndTime: map['updateLiveEndTime']);
  }
}

class EvaluationCriteria {
  final int roundNumber;
  final String criteriaName;
  final int maxScore;

  EvaluationCriteria({
    required this.roundNumber,
    required this.criteriaName,
    required this.maxScore,
  });

  Map<String, dynamic> toMap() {
    return {
      'roundNumber': roundNumber,
      'criteriaName': criteriaName,
      'maxScore': maxScore,
    };
  }

  factory EvaluationCriteria.fromMap(Map<String, dynamic> map) {
    return EvaluationCriteria(
      roundNumber: map['roundNumber'] as int,
      criteriaName: map['criteriaName'] as String? ?? '',
      maxScore: map['maxScore'] as int? ?? 0,
    );
  }
}

class JuryMember {
  final String id;
  final String name;
  final String email;
  final String photoUrl;
  final String about;
  final String role;

  final bool isVerified;

  JuryMember({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl = '',
    this.about = '',
    required this.role,
    required this.isVerified,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'photoUrl': photoUrl,
      'isVerified': isVerified,
    };
  }

  factory JuryMember.fromMap(Map<String, dynamic> json) {
    return JuryMember(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      photoUrl: json['photoUrl'] ?? '',
      about: json['about'] ?? 'No description available',
      role: json['role'],
      isVerified: json['isVerified'],
    );
  }
}

class WinnerPhotos {
  final String photoUrl;
  final String? teamName;
  final int rank;

  WinnerPhotos({
    required this.photoUrl,
    this.teamName,
    required this.rank,
  });

  Map<String, dynamic> toMap() {
    return {
      'photoUrl': photoUrl,
      'teamName': teamName,
      'rank': rank,
    };
  }

  factory WinnerPhotos.fromMap(Map<String, dynamic> map) {
    return WinnerPhotos(
      photoUrl: map['photoUrl'] as String? ?? '',
      teamName: map['teamName'] as String?,
      rank: map['rank'] as int? ?? 0,
    );
  }
}
