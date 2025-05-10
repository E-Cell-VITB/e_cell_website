// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Gallery {
  final String? id;
  final String name;
  final String description;
  final String status;
  final List<String> winnerPhotos;
  final List<String> allPhotos;
  // final String socialLink;

  Gallery({
    required this.name,
    required this.description,
    required this.winnerPhotos,
    required this.allPhotos,
    // required this.socialLink,
    required this.status,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'description': description,
      'status': status,
      'winnerPhotos': winnerPhotos,
      'allPhotos': allPhotos,
      // 'socialLink': socialLink,
    };
  }

  factory Gallery.fromMap(Map<String, dynamic> map) {
    return Gallery(
      id: map['id'] as String?,
      name: map['name'] as String,
      description: map['description'] as String,
      status: map['status'] as String,
      winnerPhotos: List<String>.from((map['winnerPhotos'])),
      allPhotos: List<String>.from((map['allPhotos'])),
      // socialLink: map['socialLink'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Gallery.fromJson(String source) =>
      Gallery.fromMap(json.decode(source) as Map<String, dynamic>);
}
