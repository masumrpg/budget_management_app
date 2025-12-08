import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Professional Financial Color Palette
  static const Color _primaryColor = Color(0xFF1A237E); // Deep Blue
  static const Color _secondaryColor = Color(0xFF00BFA5); // Teal Accent
  static const Color _surfaceColor = Colors.white;
  static const Color _backgroundColor = Color(0xFFF5F7FA); // Very Light Grey
  static const Color _errorColor = Color(0xFFE53935); // Soft Red
  static const Color _onSurfaceColor = Color(0xFF263238); // Dark Grey Text

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: _primaryColor,
        secondary: _secondaryColor,
        surface: _surfaceColor,
        surfaceContainerHighest: Color(
          0xFFE8EAF6,
        ), // Light Indigo for containers
        error: _errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: _onSurfaceColor,
        onSurfaceVariant: Color(0xFF546E7A), // Muted Text
      ),
      scaffoldBackgroundColor: _backgroundColor,

      // Typography
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme)
          .copyWith(
            displayLarge: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: _onSurfaceColor,
            ),
            displayMedium: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: _onSurfaceColor,
            ),
            displaySmall: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: _onSurfaceColor,
            ),
            headlineLarge: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: _onSurfaceColor,
            ),
            headlineMedium: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: _onSurfaceColor,
            ),
            headlineSmall: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: _onSurfaceColor,
            ),
            titleLarge: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: _onSurfaceColor,
            ),
          ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: _surfaceColor,
        elevation: 0,
        scrolledUnderElevation: 2,
        centerTitle: false,
        iconTheme: const IconThemeData(color: _onSurfaceColor),
        titleTextStyle: GoogleFonts.poppins(
          color: _onSurfaceColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Card Theme
      // Card Theme
      cardTheme: CardThemeData(
        elevation: 0,
        color: _surfaceColor,
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        clipBehavior: Clip.antiAlias,
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primaryColor, width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _errorColor),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        labelStyle: const TextStyle(color: Color(0xFF546E7A)),
        floatingLabelStyle: const TextStyle(color: _primaryColor),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _primaryColor,
          side: const BorderSide(color: _primaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: _surfaceColor,
        surfaceTintColor: _surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: _onSurfaceColor,
        ),
      ),

      // Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _secondaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  static ThemeData get darkTheme {
    // Dark Theme Colors
    const Color primaryDark = Color(0xFF5C6BC0); // Lighter Indigo
    const Color secondaryDark = Color(0xFF26A69A); // Muted Teal
    const Color backgroundDark = Color(0xFF121212);
    const Color surfaceDark = Color(0xFF1E1E1E);
    const Color onSurfaceDark = Color(0xFFE0E0E0);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primaryDark,
        secondary: secondaryDark,
        surface: surfaceDark,
        surfaceContainerHighest: Color(0xFF2C2C2C),
        // background: backgroundDark, // deprecated
        error: Color(0xFFEF5350),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: onSurfaceDark,
      ),
      scaffoldBackgroundColor: backgroundDark,

      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme)
          .copyWith(
            displayLarge: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            headlineLarge: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            headlineMedium: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            titleLarge: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),

      appBarTheme: AppBarTheme(
        backgroundColor: surfaceDark,
        elevation: 0,
        scrolledUnderElevation: 2,
        centerTitle: false,
        titleTextStyle: GoogleFonts.poppins(
          color: onSurfaceDark,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      cardTheme: CardThemeData(
        elevation: 0,
        color: surfaceDark,
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade800),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2C2C2C),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryDark, width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryDark,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primaryDark,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: secondaryDark,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: onSurfaceDark,
        ),
      ),
    );
  }
}
