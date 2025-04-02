import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cell_website/services/enums/url_type.dart';

class Event {
  final String? id;
  final String name;
  final String description;
  final DateTime eventDate;
  final Timestamp createdAt;
  final String status;
  final List<String> winnerPhotos;
  final List<String> allPhotos;
  final List<SocialLink> socialLink;
  final int numParticipants;
  final int numTeams;
  final List<GuestOrJudge> guestsAndJudges;
  final double prizePool;
  final String place;
  final String bannerPhotoUrl;
  final String certificatesScript;

  Event({
    required this.name,
    required this.description,
    required this.eventDate,
    required this.createdAt,
    required this.winnerPhotos,
    required this.allPhotos,
    required this.socialLink,
    required this.status,
    required this.numParticipants,
    required this.numTeams,
    required this.guestsAndJudges,
    required this.prizePool,
    required this.place,
    required this.bannerPhotoUrl,
    required this.certificatesScript,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name.trim(),
      'description': description.trim(),
      'eventDate': Timestamp.fromDate(eventDate),
      'createdAt': createdAt,
      'status': status,
      'winnerPhotos': winnerPhotos,
      'allPhotos': allPhotos,
      'socialLink': socialLink,
      'numParticipants': numParticipants,
      'numTeams': numTeams,
      'guestsAndJudges': guestsAndJudges.map((gj) => gj.toMap()).toList(),
      'prizePool': prizePool,
      'place': place,
      'bannerPhotoUrl': bannerPhotoUrl,
      'certificatesScript': certificatesScript
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'] as String?,
      name: map['name'] as String,
      description: map['description'] as String,
      eventDate: (map['eventDate'] as Timestamp).toDate(),
      createdAt: map['createdAt'] as Timestamp,
      status: map['status'] as String,
      winnerPhotos: List<String>.from(map['winnerPhotos']),
      allPhotos: List<String>.from(map['allPhotos']),
      socialLink: (map['socialLink'] as List<dynamic>?)
              ?.map((e) => SocialLink.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      numParticipants: (map['numParticipants'] as int?) ?? 0,
      numTeams: (map['numTeams'] as int?) ?? 0,
      guestsAndJudges: (map['guestsAndJudges'] as List<dynamic>?)
              ?.map((e) => GuestOrJudge.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      prizePool: (map['prizePool'] as num?)?.toDouble() ?? 0.0,
      place: map['place'] as String? ?? "VITB, Bhimavarm",
      bannerPhotoUrl: map['bannerPhotoUrl'] as String? ?? "",
      certificatesScript: map['certificatesScript'] as String? ??
          "https://script.google.com/macros/s/AKfycbzqlOnxhhlZiJYeetOiukTviFxobw4_3kyujrcvSDGDXe5uaAXGBJpBPNJL9jEfLpKZBw/exec",
    );
  }
}

class GuestOrJudge {
  final String name;
  final String about;
  final String photoUrl;
  final String role;

  GuestOrJudge({
    required this.name,
    required this.about,
    required this.photoUrl,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'about': about,
      'photoUrl': photoUrl,
      'role': role,
    };
  }

  factory GuestOrJudge.fromMap(Map<String, dynamic> map) {
    return GuestOrJudge(
      name: map['name'] as String,
      about: map['about'] as String,
      photoUrl: map['photoUrl'] as String,
      role: map['role'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory GuestOrJudge.fromJson(String source) =>
      GuestOrJudge.fromMap(json.decode(source) as Map<String, dynamic>);
}

class SocialLink {
  final UrlType urlType;
  final String url;

  SocialLink({
    required this.urlType,
    required this.url,
  });

  Map<String, dynamic> toMap() {
    return {
      'urlType': urlType,
      'url': url,
    };
  }

  factory SocialLink.fromMap(Map<String, dynamic> map) {
    return SocialLink(
      urlType: UrlType.fromString(map['type'] as String),
      url: map['url'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SocialLink.fromJson(String source) =>
      SocialLink.fromMap(json.decode(source) as Map<String, dynamic>);
}

Event dummyEvent = Event(
  name: "Hackathon 2025",
  description:
      "A 24-hour coding competition for innovators and developers to build solutions for real-world problems. Join us for a weekend of coding, learning, and networking with industry professionals.",
  eventDate: DateTime(2025, 5, 20),
  createdAt: Timestamp.now(),
  status: "Upcoming",
  certificatesScript: "",
  // Winner photos - 3 images
  winnerPhotos: [
    "https://images.unsplash.com/photo-1522202176988-66273c2fd55f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80",
    "https://images.unsplash.com/photo-1531482615713-2afd69097998?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80",
    "https://images.unsplash.com/photo-1543269865-cbf427effbad?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80"
  ],

// All photos - 10 images
  allPhotos: [
    "https://images.unsplash.com/photo-1540575467063-178a50c2df87?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80",
    "https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80",
    "https://images.unsplash.com/photo-1530099486328-e021101a494a?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80",
    "https://images.unsplash.com/photo-1528901166007-3784c7dd3653?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80",
    "https://images.unsplash.com/photo-1523240795612-9a054b0db644?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80",
    "https://images.unsplash.com/photo-1525908541266-7b528d2affb5?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80",
    "https://images.unsplash.com/photo-1522071820081-009f0129c71c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80",
    "https://images.unsplash.com/photo-1523575166472-a83a0ed4d212?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80",
    "https://images.unsplash.com/photo-1511467687858-23d96c32e4ae?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80",
    "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80"
  ],
  socialLink: [],
  numParticipants: 200,
  numTeams: 50,
  guestsAndJudges: [
    GuestOrJudge(
      name: "Dr. John Doe",
      about:
          "AI Researcher and Tech Speaker with over 15 years of experience in machine learning and emerging technologies",
      photoUrl:
          "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80",
      role: "Judge",
    ),
    GuestOrJudge(
      name: "Ms. Jane Smith",
      about: "CTO of TechStart Inc. and advocate for women in technology",
      photoUrl:
          "https://images.unsplash.com/photo-1580489944761-15a19d654956?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80",
      role: "Guest",
    ),
    GuestOrJudge(
      name: "Mr. Robert Chen",
      about:
          "Founder of StartupBoost and serial entrepreneur with 5 successful exits",
      photoUrl:
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80",
      role: "Judge",
    ),
  ],
  prizePool: 5000.0,
  place: "VITB, Bhimavaram",
  bannerPhotoUrl:
      "https://images.unsplash.com/photo-1505373877841-8d25f7d46678?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1200&q=80",
);
