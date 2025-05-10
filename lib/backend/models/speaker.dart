import 'package:cloud_firestore/cloud_firestore.dart';

class Speaker {
  final String? id;
  final String name;
  final String designation;
  final String about;
  final String imageUrl;
  final int position;
  final DateTime timestamp;

  Speaker({
    this.id,
    required this.name,
    required this.designation,
    required this.about,
    required this.imageUrl,
    required this.position,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'designation': designation,
      'about': about,
      'imageUrl': imageUrl,
      'position': position,
      'timestamp': timestamp,
    };
  }

  factory Speaker.fromMap(Map<String, dynamic> map, String id) {
    return Speaker(
      id: id,
      name: map['name'] ?? '',
      designation: map['designation'] ?? '',
      about: map['about'] ?? '',
      imageUrl:
          map['imageUrl'] ?? "https://www.w3schools.com/w3images/avatar2.png",
      position: map['position'] ?? 0,
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }

  Speaker copyWith({
    String? id,
    String? name,
    String? designation,
    String? about,
    String? imageUrl,
    int? position,
    DateTime? timestamp,
  }) {
    return Speaker(
      id: id ?? this.id,
      name: name ?? this.name,
      designation: designation ?? this.designation,
      about: about ?? this.about,
      imageUrl: imageUrl ?? this.imageUrl,
      position: position ?? this.position,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
