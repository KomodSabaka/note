import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData theme() {
    return ThemeData(
      useMaterial3: true,
      textTheme: TextTheme(
        displayLarge: GoogleFonts.russoOne(
          fontSize: 32,
        ),
        titleLarge:GoogleFonts.ibmPlexMono(
          fontSize: 24,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: GoogleFonts.andika(
          fontSize: 16,
          decoration: TextDecoration.none,
        )
      ),
    );
  }
}