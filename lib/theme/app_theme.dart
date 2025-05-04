import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A class that contains all theme configurations for the Real Estate App.
class AppTheme {
  AppTheme._();

  // Primary Teal Colors
  static const Color primary50 = Color(0xFFF0FDFA);
  static const Color primary100 = Color(0xFFCCFBF1);
  static const Color primary200 = Color(0xFF99F6E4);
  static const Color primary300 = Color(0xFF5EEAD4);
  static const Color primary400 = Color(0xFF2DD4BF);
  static const Color primary500 = Color(0xFF14B8A6);
  static const Color primary600 = Color(0xFF0D9488);
  static const Color primary700 = Color(0xFF0F766E);
  static const Color primary800 = Color(0xFF115E59);
  static const Color primary900 = Color(0xFF134E4A);

  // Neutral Slate Colors
  static const Color neutral50 = Color(0xFFF8FAFC);
  static const Color neutral100 = Color(0xFFF1F5F9);
  static const Color neutral200 = Color(0xFFE2E8F0);
  static const Color neutral300 = Color(0xFFCBD5E1);
  static const Color neutral400 = Color(0xFF94A3B8);
  static const Color neutral500 = Color(0xFF64748B);
  static const Color neutral600 = Color(0xFF475569);
  static const Color neutral700 = Color(0xFF334155);
  static const Color neutral800 = Color(0xFF1E293B);
  static const Color neutral900 = Color(0xFF0F172A);

  // Semantic Colors
  static const Color success = Color(0xFF059669);
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFE11D48);
  static const Color errorLight = Color(0xFFFFE4E6);
  static const Color info = Color(0xFF0284C7);
  static const Color infoLight = Color(0xFFE0F2FE);
  static const Color favorite = Color(0xFFF43F5E);

  // Light Theme Surface Colors
  static const Color backgroundLight = neutral50;
  static const Color surfaceLight = Colors.white;
  static const Color cardLight = Colors.white;
  static const Color dialogLight = Colors.white;
  static const Color dividerLight = neutral200;
  static const Color shadowLight = Color(0x1F000000);

  // Dark Theme Surface Colors
  static const Color backgroundDark = neutral900;
  static const Color surfaceDark = neutral800;
  static const Color cardDark = neutral800;
  static const Color dialogDark = neutral800;
  static const Color dividerDark = neutral700;
  static const Color shadowDark = Color(0x1FFFFFFF);

  // Text Colors
  static const Color textHighEmphasisLight = neutral900;
  static const Color textMediumEmphasisLight = neutral700;
  static const Color textDisabledLight = neutral500;

  static const Color textHighEmphasisDark = neutral50;
  static const Color textMediumEmphasisDark = neutral300;
  static const Color textDisabledDark = neutral500;

  /// Light theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: primary600,
      onPrimary: Colors.white,
      primaryContainer: primary100,
      onPrimaryContainer: primary900,
      secondary: primary400,
      onSecondary: Colors.white,
      secondaryContainer: primary50,
      onSecondaryContainer: primary800,
      tertiary: info,
      onTertiary: Colors.white,
      tertiaryContainer: infoLight,
      onTertiaryContainer: neutral900,
      error: error,
      onError: Colors.white,
      errorContainer: errorLight,
      onErrorContainer: error,
      surface: surfaceLight,
      onSurface: textHighEmphasisLight,
      surfaceContainerHighest: neutral100,
      onSurfaceVariant: neutral700,
      outline: neutral400,
      outlineVariant: neutral300,
      shadow: shadowLight,
      scrim: shadowLight,
      inverseSurface: neutral900,
      onInverseSurface: neutral50,
      inversePrimary: primary300,
    ),
    scaffoldBackgroundColor: backgroundLight,
    cardColor: cardLight,
    dividerColor: dividerLight,
    appBarTheme: const AppBarTheme(
      color: primary600,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardTheme(
      color: cardLight,
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      shadowColor: shadowLight,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: surfaceLight,
      selectedItemColor: primary600,
      unselectedItemColor: neutral500,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primary600,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: CircleBorder(),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: primary600,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 2,
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primary600,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        side: const BorderSide(color: primary600, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primary600,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    textTheme: _buildTextTheme(isLight: true),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: neutral100,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: primary600, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: error, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: error, width: 2),
      ),
      labelStyle: GoogleFonts.inter(
        color: neutral700,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      hintStyle: GoogleFonts.inter(
        color: neutral500,
        fontSize: 16,
      ),
      prefixIconColor: neutral600,
      suffixIconColor: neutral600,
      errorStyle: GoogleFonts.inter(
        color: error,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primary600;
        }
        return neutral300;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primary300;
        }
        return neutral200;
      }),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primary600;
        }
        return null;
      }),
      checkColor: WidgetStateProperty.all(Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primary600;
        }
        return neutral400;
      }),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primary600,
      circularTrackColor: primary100,
      linearTrackColor: primary100,
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: primary600,
      thumbColor: primary600,
      overlayColor: primary200.withAlpha(51),
      inactiveTrackColor: neutral300,
      valueIndicatorColor: primary700,
      valueIndicatorTextStyle: const TextStyle(color: Colors.white),
      trackHeight: 4,
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: primary600,
      unselectedLabelColor: neutral500,
      indicatorColor: primary600,
      labelStyle: TextStyle(fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: neutral800,
        borderRadius: BorderRadius.circular(4),
      ),
      textStyle: const TextStyle(color: Colors.white),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: neutral800,
      contentTextStyle: GoogleFonts.inter(
        color: Colors.white,
        fontSize: 14,
      ),
      actionTextColor: primary300,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: neutral100,
      disabledColor: neutral200,
      selectedColor: primary100,
      secondarySelectedColor: primary600,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      labelStyle: GoogleFonts.inter(
        color: neutral700,
        fontSize: 14,
      ),
      secondaryLabelStyle: GoogleFonts.inter(
        color: Colors.white,
        fontSize: 14,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: surfaceLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: dialogLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      titleTextStyle: GoogleFonts.inter(
        color: textHighEmphasisLight,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      contentTextStyle: GoogleFonts.inter(
        color: textMediumEmphasisLight,
        fontSize: 16,
      ),
    ),
  );

  /// Dark theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: primary400,
      onPrimary: neutral900,
      primaryContainer: primary800,
      onPrimaryContainer: primary100,
      secondary: primary300,
      onSecondary: neutral900,
      secondaryContainer: primary700,
      onSecondaryContainer: primary100,
      tertiary: info,
      onTertiary: Colors.white,
      tertiaryContainer: Color(0xFF004D70), // Darker info color
      onTertiaryContainer: infoLight,
      error: error,
      onError: Colors.white,
      errorContainer: Color(0xFF8B0000), // Darker error color
      onErrorContainer: errorLight,
      surface: surfaceDark,
      onSurface: textHighEmphasisDark,
      surfaceContainerHighest: neutral800,
      onSurfaceVariant: neutral300,
      outline: neutral600,
      outlineVariant: neutral700,
      shadow: shadowDark,
      scrim: shadowDark,
      inverseSurface: neutral100,
      onInverseSurface: neutral900,
      inversePrimary: primary700,
    ),
    scaffoldBackgroundColor: backgroundDark,
    cardColor: cardDark,
    dividerColor: dividerDark,
    appBarTheme: const AppBarTheme(
      color: neutral800,
      foregroundColor: neutral50,
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardTheme(
      color: cardDark,
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      shadowColor: shadowDark,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: surfaceDark,
      selectedItemColor: primary400,
      unselectedItemColor: neutral400,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primary400,
      foregroundColor: neutral900,
      elevation: 4,
      shape: CircleBorder(),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: neutral900,
        backgroundColor: primary400,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 2,
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primary400,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        side: const BorderSide(color: primary400, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primary400,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    textTheme: _buildTextTheme(isLight: false),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: neutral800,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: primary400, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: error, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: error, width: 2),
      ),
      labelStyle: GoogleFonts.inter(
        color: neutral300,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      hintStyle: GoogleFonts.inter(
        color: neutral500,
        fontSize: 16,
      ),
      prefixIconColor: neutral400,
      suffixIconColor: neutral400,
      errorStyle: GoogleFonts.inter(
        color: error,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primary400;
        }
        return neutral600;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primary700;
        }
        return neutral700;
      }),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primary400;
        }
        return null;
      }),
      checkColor: WidgetStateProperty.all(neutral900),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primary400;
        }
        return neutral500;
      }),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primary400,
      circularTrackColor: primary800,
      linearTrackColor: primary800,
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: primary400,
      thumbColor: primary400,
      overlayColor: primary700.withAlpha(51),
      inactiveTrackColor: neutral700,
      valueIndicatorColor: primary400,
      valueIndicatorTextStyle: const TextStyle(color: neutral900),
      trackHeight: 4,
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: primary400,
      unselectedLabelColor: neutral400,
      indicatorColor: primary400,
      labelStyle: TextStyle(fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: neutral200,
        borderRadius: BorderRadius.circular(4),
      ),
      textStyle: const TextStyle(color: neutral900),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: neutral200,
      contentTextStyle: GoogleFonts.inter(
        color: neutral900,
        fontSize: 14,
      ),
      actionTextColor: primary700,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: neutral800,
      disabledColor: neutral700,
      selectedColor: primary700,
      secondarySelectedColor: primary400,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      labelStyle: GoogleFonts.inter(
        color: neutral300,
        fontSize: 14,
      ),
      secondaryLabelStyle: GoogleFonts.inter(
        color: neutral900,
        fontSize: 14,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: surfaceDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: dialogDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      titleTextStyle: GoogleFonts.inter(
        color: textHighEmphasisDark,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      contentTextStyle: GoogleFonts.inter(
        color: textMediumEmphasisDark,
        fontSize: 16,
      ),
    ),
  );

  /// Helper method to build text theme based on brightness
  static TextTheme _buildTextTheme({required bool isLight}) {
    final Color textHighEmphasis =
        isLight ? textHighEmphasisLight : textHighEmphasisDark;
    final Color textMediumEmphasis =
        isLight ? textMediumEmphasisLight : textMediumEmphasisDark;
    final Color textDisabled = isLight ? textDisabledLight : textDisabledDark;

    // Display styles
    final displayLarge = GoogleFonts.inter(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: textHighEmphasis,
      letterSpacing: -0.5,
    );

    final displayMedium = GoogleFonts.inter(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: textHighEmphasis,
      letterSpacing: -0.25,
    );

    final displaySmall = GoogleFonts.inter(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: textHighEmphasis,
    );

    // Title styles
    final titleLarge = GoogleFonts.inter(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: textHighEmphasis,
    );

    final titleMedium = GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: textHighEmphasis,
    );

    final titleSmall = GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: textHighEmphasis,
    );

    // Body styles
    final bodyLarge = GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: textHighEmphasis,
    );

    final bodyMedium = GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: textHighEmphasis,
    );

    final bodySmall = GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: textMediumEmphasis,
    );

    // Price styles (using DM Mono)
    final priceLarge = GoogleFonts.dmMono(
      fontSize: 24,
      fontWeight: FontWeight.w500,
      color: textHighEmphasis,
    );

    final priceMedium = GoogleFonts.dmMono(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: textHighEmphasis,
    );

    final priceSmall = GoogleFonts.dmMono(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: textHighEmphasis,
    );

    // Label styles
    final labelLarge = GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: textHighEmphasis,
      letterSpacing: 0.1,
    );

    final labelMedium = GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: textMediumEmphasis,
      letterSpacing: 0.5,
    );

    final labelSmall = GoogleFonts.inter(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: textDisabled,
      letterSpacing: 0.5,
    );

    return TextTheme(
      displayLarge: displayLarge,
      displayMedium: displayMedium,
      displaySmall: displaySmall,
      headlineLarge: displayLarge,
      headlineMedium: displayMedium,
      headlineSmall: displaySmall,
      titleLarge: titleLarge,
      titleMedium: titleMedium,
      titleSmall: titleSmall,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,
      labelLarge: labelLarge,
      labelMedium: labelMedium,
      labelSmall: labelSmall,
    );
  }

  /// Custom text styles for property prices using monospace font
  static TextStyle getPriceTextStyle(
      {required bool isLarge, required bool isLight}) {
    final Color textColor =
        isLight ? textHighEmphasisLight : textHighEmphasisDark;

    if (isLarge) {
      return GoogleFonts.dmMono(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: textColor,
      );
    } else {
      return GoogleFonts.dmMono(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: textColor,
      );
    }
  }

  /// Theme mode helper
  static ThemeMode getThemeMode(String mode) {
    switch (mode) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }
}
