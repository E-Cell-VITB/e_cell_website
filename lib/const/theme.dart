import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData getAppTheme() {
  // Define colors
  const backgroundColor = Color(0xFF202020);
  const primaryColor = Color(0xFFFFFFFF);
  const secondaryColor = Color(0xFFC79200);

  return ThemeData(
    // Base colors
    scaffoldBackgroundColor: backgroundColor,
    primaryColor: primaryColor,
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: backgroundColor,
      onPrimary: backgroundColor,
      onSecondary: backgroundColor,
      onSurface: primaryColor,
    ),

    // AppBar theme
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundColor,
      foregroundColor: primaryColor,
      elevation: 0,
    ),

    // Button themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: backgroundColor,
        backgroundColor: primaryColor,
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
      ),
    ),

    // Text theme using Poppins font
    textTheme: GoogleFonts.poppinsTextTheme(
      ThemeData.dark().textTheme.copyWith(
            displayLarge: const TextStyle(color: primaryColor),
            displayMedium: const TextStyle(color: primaryColor),
            displaySmall: const TextStyle(color: primaryColor),
            headlineLarge: const TextStyle(color: primaryColor),
            headlineMedium: const TextStyle(color: primaryColor),
            headlineSmall: const TextStyle(color: primaryColor),
            titleLarge: const TextStyle(color: primaryColor),
            titleMedium: const TextStyle(color: primaryColor),
            titleSmall: const TextStyle(color: primaryColor),
            bodyLarge: const TextStyle(color: primaryColor),
            bodyMedium: const TextStyle(color: primaryColor),
            bodySmall: const TextStyle(color: primaryColor),
          ),
    ),

    // Card theme
    cardTheme: CardTheme(
      color: Colors.black.withAlpha(204), // ~0.8 opacity
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    // Input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.black.withAlpha(128), // ~0.5 opacity
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
            color: Color(0x80FFFFFF)), // primaryColor with 0.5 opacity
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: secondaryColor, width: 2),
      ),
      labelStyle: const TextStyle(color: primaryColor),
    ),

    // Icon theme
    iconTheme: const IconThemeData(
      color: primaryColor,
    ),

    // Divider theme
    dividerTheme: const DividerThemeData(
      color: primaryColor,
      thickness: 0.5,
    ),
  );
}

const backgroundColor = Color(0xFF202020);
const primaryColor = Color(0xFFFFFFFF);
const secondaryColor = Color(0xFFC79200);

const List<Color> eventBoxLinearGradient=[
  Color(0xFF0D0D0D),
  Color(0xFF1F1E1E),
  Color(0xFF000000)
];

const List<Color> linerGradient = [
  Color(0xffC79200),
  Color(0xffFFE8A9),
  Color(0xffC79200),
];
