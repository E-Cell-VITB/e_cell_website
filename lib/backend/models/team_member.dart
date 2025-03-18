import 'package:cloud_firestore/cloud_firestore.dart';

class TeamMemberModel {
  final String department;
  final String designation;
  final String name;
  final String email;
  final String? phoneNumber;
  final String linkedInProfileURL;
  final String id;
  final String profileURL;

  TeamMemberModel({
    required this.department,
    required this.designation,
    required this.name,
    required this.email,
    this.phoneNumber = "",
    required this.linkedInProfileURL,
    required this.profileURL,
    required this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'department': department,
      'designation': designation,
      'phone_number': phoneNumber,
      'linked_in_profile_url': linkedInProfileURL,
      'profile_url': profileURL,
    };
  }

  static TeamMemberModel fromDocumentSnapshot(
      DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

    return TeamMemberModel(
      name: data['name'] ?? "",
      email: data['email'] ?? "",
      department: data['department'] ?? "",
      designation: data['designation'] ?? "",
      phoneNumber: data['phone_number'] ?? "",
      linkedInProfileURL: data['linked_in_profile_url'] ?? "",
      id: documentSnapshot.id,
      profileURL: data['profile_url'] ?? "https://via.placeholder.com/150",
    );
  }
}
