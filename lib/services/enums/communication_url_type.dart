import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum CommunicationUrlType {
  linkedin,
  twitter,
  instagram,
  github,
  kaggle,
  telegram,
  whatsapp;

  @override
  String toString() {
    return switch (this) {
      CommunicationUrlType.linkedin => "LinkedIn",
      CommunicationUrlType.twitter => "Twitter",
      CommunicationUrlType.instagram => "Instagram",
      CommunicationUrlType.kaggle => "Kaggle",
      CommunicationUrlType.github => "GitHub",
      CommunicationUrlType.telegram => "Telegram",
      CommunicationUrlType.whatsapp => "WhatsApp",
    };
  }

  IconData get icon {
    return switch (this) {
      CommunicationUrlType.linkedin => FontAwesomeIcons.linkedin,
      CommunicationUrlType.twitter => FontAwesomeIcons.twitter,
      CommunicationUrlType.instagram => FontAwesomeIcons.instagram,
      CommunicationUrlType.kaggle => FontAwesomeIcons.kaggle,
      CommunicationUrlType.github => FontAwesomeIcons.github,
      CommunicationUrlType.telegram => FontAwesomeIcons.telegram,
      CommunicationUrlType.whatsapp => FontAwesomeIcons.whatsapp,
    };
  }

  static CommunicationUrlType fromString(String value) {
    return switch (value.toLowerCase()) {
      'linkedin' => CommunicationUrlType.linkedin,
      'twitter' => CommunicationUrlType.twitter,
      'instagram' => CommunicationUrlType.instagram,
      'kaggle' => CommunicationUrlType.kaggle,
      'github' => CommunicationUrlType.github,
      'telegram' => CommunicationUrlType.telegram,
      'whatsapp' => CommunicationUrlType.whatsapp,
      _ => throw ArgumentError('Invalid URL type: $value'),
    };
  }
}
