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
