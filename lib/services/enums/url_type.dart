enum UrlType {
  linkedin,
  twitter,
  instagram,
  youtube,
  github,
  ppt,
  pdf,
  code;

  @override
  String toString() {
    return switch (this) {
      UrlType.linkedin => "LinkedIn",
      UrlType.twitter => "Twitter",
      UrlType.instagram => "Instagram",
      UrlType.youtube => "YouTube",
      UrlType.github => "GitHub",
      UrlType.ppt => "PPT",
      UrlType.pdf => "PDF",
      UrlType.code => "Code",
    };
  }

  String get icon {
    return switch (this) {
      UrlType.linkedin => "assets/icons/linkdein_icon.png",
      UrlType.twitter => "assets/icons/twitter.png",
      UrlType.instagram => "assets/icons/instagram.png",
      UrlType.youtube => "assets/icons/youtube.png",
      UrlType.github => "assets/icons/Github.png",
      UrlType.ppt => "assets/icons/ppt.png",
      UrlType.pdf => "assets/icons/pdf.png",
      UrlType.code => "assets/icons/code.png",
    };
  }

  static UrlType fromString(String value) {
    return switch (value.toLowerCase()) {
      'linkedin' => UrlType.linkedin,
      'twitter' => UrlType.twitter,
      'instagram' => UrlType.instagram,
      'youtube' => UrlType.youtube,
      'github' => UrlType.github,
      'ppt' => UrlType.ppt,
      'pdf' => UrlType.pdf,
      'code' => UrlType.code,
      _ => throw ArgumentError('Invalid URL type: $value'),
    };
  }
}
