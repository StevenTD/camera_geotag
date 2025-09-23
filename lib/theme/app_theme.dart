import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A class that contains all theme configurations for the application.
/// Implements Professional Precision Interface with Technical Accuracy Palette
/// optimized for field documentation and professional mobile applications.
class AppTheme {
  AppTheme._();

  // Technical Accuracy Palette - High-contrast colors optimized for outdoor visibility
  static const Color primaryLight =
      Color(0xFF1A1D23); // Deep charcoal for professional interface chrome
  static const Color primaryDark =
      Color(0xFF1A1D23); // Consistent across themes for brand recognition

  static const Color secondaryLight =
      Color(0xFF2D3748); // Medium gray for secondary elements
  static const Color secondaryDark =
      Color(0xFF4A5568); // Lighter gray for dark theme contrast

  static const Color accentLight =
      Color(0xFF3182CE); // Professional blue for GPS and primary actions
  static const Color accentDark =
      Color(0xFF63B3ED); // Lighter blue for dark theme visibility

  static const Color successLight =
      Color(0xFF38A169); // GPS accuracy confirmation
  static const Color successDark =
      Color(0xFF68D391); // Lighter success for dark theme

  static const Color warningLight = Color(0xFFD69E2E); // GPS signal issues
  static const Color warningDark =
      Color(0xFFF6E05E); // Lighter warning for dark theme

  static const Color errorLight = Color(0xFFE53E3E); // Critical errors
  static const Color errorDark =
      Color(0xFFFC8181); // Lighter error for dark theme

  static const Color surfaceLight =
      Color(0xFFF7FAFC); // Clean background for metadata cards
  static const Color surfaceDark =
      Color(0xFF1A202C); // Dark surface maintaining contrast

  static const Color backgroundLight = Color(0xFFFFFFFF); // Primary background
  static const Color backgroundDark = Color(0xFF171923); // Dark background

  static const Color borderLight =
      Color(0xFFE2E8F0); // Subtle element separation
  static const Color borderDark = Color(0xFF2D3748); // Dark theme borders

  static const Color textPrimaryLight =
      Color(0xFF1A202C); // High contrast body text
  static const Color textPrimaryDark =
      Color(0xFFF7FAFC); // High contrast for dark theme

  static const Color textSecondaryLight =
      Color(0xFF4A5568); // Supporting text and metadata
  static const Color textSecondaryDark =
      Color(0xFFA0AEC0); // Secondary text for dark theme

  static const Color textDisabledLight = Color(0xFF718096); // Disabled states
  static const Color textDisabledDark =
      Color(0xFF4A5568); // Disabled for dark theme

  // Shadow colors for subtle elevation system (2-4dp shadows with 0.08 opacity)
  static const Color shadowLight =
      Color(0x14000000); // 0.08 opacity for functional depth
  static const Color shadowDark =
      Color(0x14FFFFFF); // Subtle shadows for dark theme

  /// Light theme optimized for outdoor visibility and professional credibility
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primaryLight,
      onPrimary: Colors.white,
      primaryContainer: accentLight,
      onPrimaryContainer: Colors.white,
      secondary: secondaryLight,
      onSecondary: Colors.white,
      secondaryContainer: secondaryLight.withValues(alpha: 0.1),
      onSecondaryContainer: textPrimaryLight,
      tertiary: accentLight,
      onTertiary: Colors.white,
      tertiaryContainer: accentLight.withValues(alpha: 0.1),
      onTertiaryContainer: textPrimaryLight,
      error: errorLight,
      onError: Colors.white,
      surface: surfaceLight,
      onSurface: textPrimaryLight,
      onSurfaceVariant: textSecondaryLight,
      outline: borderLight,
      outlineVariant: borderLight.withValues(alpha: 0.5),
      shadow: shadowLight,
      scrim: Colors.black54,
      inverseSurface: surfaceDark,
      onInverseSurface: textPrimaryDark,
      inversePrimary: accentDark,
    ),
    scaffoldBackgroundColor: backgroundLight,
    cardColor: surfaceLight,
    dividerColor: borderLight,

    // AppBar theme for professional interface chrome
    appBarTheme: AppBarTheme(
      backgroundColor: primaryLight,
      foregroundColor: Colors.white,
      elevation: 2.0,
      shadowColor: shadowLight,
      centerTitle: true,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        letterSpacing: 0.15,
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
        size: 24,
      ),
      actionsIconTheme: const IconThemeData(
        color: Colors.white,
        size: 24,
      ),
    ),

    // Card theme for metadata cards with subtle elevation
    cardTheme: CardThemeData(
      color: surfaceLight,
      elevation: 2.0,
      shadowColor: shadowLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),

    // Bottom navigation optimized for one-handed operation
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceLight,
      selectedItemColor: accentLight,
      unselectedItemColor: textSecondaryLight,
      type: BottomNavigationBarType.fixed,
      elevation: 8.0,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),

    // FloatingActionButton for contextual camera actions
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: accentLight,
      foregroundColor: Colors.white,
      elevation: 4.0,
      focusElevation: 6.0,
      hoverElevation: 6.0,
      highlightElevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    ),

    // Button themes for professional interactions
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: accentLight,
        elevation: 2.0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: accentLight,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        side: BorderSide(color: accentLight, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: accentLight,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    ),

    // Typography using Inter for contemporary mobile optimization
    textTheme: _buildTextTheme(isLight: true),

    // Input decoration for professional form elements
    inputDecorationTheme: InputDecorationTheme(
      fillColor: surfaceLight,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: borderLight, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: borderLight, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: accentLight, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: errorLight, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: errorLight, width: 2.0),
      ),
      labelStyle: GoogleFonts.inter(
        color: textSecondaryLight,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: GoogleFonts.inter(
        color: textDisabledLight,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      helperStyle: GoogleFonts.inter(
        color: textSecondaryLight,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      errorStyle: GoogleFonts.inter(
        color: errorLight,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Switch theme for GPS and settings toggles
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return accentLight;
        return borderLight;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected))
          return accentLight.withValues(alpha: 0.3);
        return borderLight.withValues(alpha: 0.5);
      }),
    ),

    // Checkbox theme for selection states
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return accentLight;
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(Colors.white),
      side: BorderSide(color: borderLight, width: 1.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),

    // Radio theme for option selection
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return accentLight;
        return borderLight;
      }),
    ),

    // Progress indicators for GPS accuracy and loading states
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: accentLight,
      linearTrackColor: borderLight,
      circularTrackColor: borderLight,
    ),

    // Slider theme for settings adjustments
    sliderTheme: SliderThemeData(
      activeTrackColor: accentLight,
      thumbColor: accentLight,
      overlayColor: accentLight.withValues(alpha: 0.2),
      inactiveTrackColor: borderLight,
      valueIndicatorColor: accentLight,
      valueIndicatorTextStyle: GoogleFonts.inter(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),

    // Tab bar theme for navigation
    tabBarTheme: TabBarThemeData(
      labelColor: accentLight,
      unselectedLabelColor: textSecondaryLight,
      indicatorColor: accentLight,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Tooltip theme for help and information
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: primaryLight.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: GoogleFonts.inter(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),

    // SnackBar theme for feedback messages
    snackBarTheme: SnackBarThemeData(
      backgroundColor: primaryLight,
      contentTextStyle: GoogleFonts.inter(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      actionTextColor: accentLight,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 4.0,
    ),

    // Dialog theme for modal interactions
    dialogTheme: DialogThemeData(
      backgroundColor: surfaceLight,
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      titleTextStyle: GoogleFonts.inter(
        color: textPrimaryLight,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      contentTextStyle: GoogleFonts.inter(
        color: textPrimaryLight,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Bottom sheet theme for adaptive controls
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: surfaceLight,
      elevation: 8.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      modalBackgroundColor: surfaceLight,
      modalElevation: 8.0,
    ),
  );

  /// Dark theme maintaining professional credibility in low-light conditions
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: primaryDark,
      onPrimary: Colors.white,
      primaryContainer: accentDark,
      onPrimaryContainer: backgroundDark,
      secondary: secondaryDark,
      onSecondary: backgroundDark,
      secondaryContainer: secondaryDark.withValues(alpha: 0.2),
      onSecondaryContainer: textPrimaryDark,
      tertiary: accentDark,
      onTertiary: backgroundDark,
      tertiaryContainer: accentDark.withValues(alpha: 0.2),
      onTertiaryContainer: textPrimaryDark,
      error: errorDark,
      onError: backgroundDark,
      surface: surfaceDark,
      onSurface: textPrimaryDark,
      onSurfaceVariant: textSecondaryDark,
      outline: borderDark,
      outlineVariant: borderDark.withValues(alpha: 0.5),
      shadow: shadowDark,
      scrim: Colors.black87,
      inverseSurface: surfaceLight,
      onInverseSurface: textPrimaryLight,
      inversePrimary: accentLight,
    ),
    scaffoldBackgroundColor: backgroundDark,
    cardColor: surfaceDark,
    dividerColor: borderDark,

    // AppBar theme for dark mode
    appBarTheme: AppBarTheme(
      backgroundColor: primaryDark,
      foregroundColor: Colors.white,
      elevation: 2.0,
      shadowColor: shadowDark,
      centerTitle: true,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        letterSpacing: 0.15,
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
        size: 24,
      ),
      actionsIconTheme: const IconThemeData(
        color: Colors.white,
        size: 24,
      ),
    ),

    // Card theme for dark mode
    cardTheme: CardThemeData(
      color: surfaceDark,
      elevation: 2.0,
      shadowColor: shadowDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),

    // Bottom navigation for dark mode
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceDark,
      selectedItemColor: accentDark,
      unselectedItemColor: textSecondaryDark,
      type: BottomNavigationBarType.fixed,
      elevation: 8.0,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),

    // FloatingActionButton for dark mode
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: accentDark,
      foregroundColor: backgroundDark,
      elevation: 4.0,
      focusElevation: 6.0,
      hoverElevation: 6.0,
      highlightElevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    ),

    // Button themes for dark mode
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: backgroundDark,
        backgroundColor: accentDark,
        elevation: 2.0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: accentDark,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        side: BorderSide(color: accentDark, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: accentDark,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    ),

    // Typography for dark mode
    textTheme: _buildTextTheme(isLight: false),

    // Input decoration for dark mode
    inputDecorationTheme: InputDecorationTheme(
      fillColor: surfaceDark,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: borderDark, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: borderDark, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: accentDark, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: errorDark, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: errorDark, width: 2.0),
      ),
      labelStyle: GoogleFonts.inter(
        color: textSecondaryDark,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: GoogleFonts.inter(
        color: textDisabledDark,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      helperStyle: GoogleFonts.inter(
        color: textSecondaryDark,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      errorStyle: GoogleFonts.inter(
        color: errorDark,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Switch theme for dark mode
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return accentDark;
        return borderDark;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected))
          return accentDark.withValues(alpha: 0.3);
        return borderDark.withValues(alpha: 0.5);
      }),
    ),

    // Checkbox theme for dark mode
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return accentDark;
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(backgroundDark),
      side: BorderSide(color: borderDark, width: 1.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),

    // Radio theme for dark mode
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return accentDark;
        return borderDark;
      }),
    ),

    // Progress indicators for dark mode
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: accentDark,
      linearTrackColor: borderDark,
      circularTrackColor: borderDark,
    ),

    // Slider theme for dark mode
    sliderTheme: SliderThemeData(
      activeTrackColor: accentDark,
      thumbColor: accentDark,
      overlayColor: accentDark.withValues(alpha: 0.2),
      inactiveTrackColor: borderDark,
      valueIndicatorColor: accentDark,
      valueIndicatorTextStyle: GoogleFonts.inter(
        color: backgroundDark,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),

    // Tab bar theme for dark mode
    tabBarTheme: TabBarThemeData(
      labelColor: accentDark,
      unselectedLabelColor: textSecondaryDark,
      indicatorColor: accentDark,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Tooltip theme for dark mode
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: textPrimaryDark.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: GoogleFonts.inter(
        color: backgroundDark,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),

    // SnackBar theme for dark mode
    snackBarTheme: SnackBarThemeData(
      backgroundColor: primaryDark,
      contentTextStyle: GoogleFonts.inter(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      actionTextColor: accentDark,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 4.0,
    ),

    // Dialog theme for dark mode
    dialogTheme: DialogThemeData(
      backgroundColor: surfaceDark,
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      titleTextStyle: GoogleFonts.inter(
        color: textPrimaryDark,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      contentTextStyle: GoogleFonts.inter(
        color: textPrimaryDark,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Bottom sheet theme for dark mode
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: surfaceDark,
      elevation: 8.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      modalBackgroundColor: surfaceDark,
      modalElevation: 8.0,
    ),
  );

  /// Helper method to build text theme using Inter and SF fonts for professional documentation
  static TextTheme _buildTextTheme({required bool isLight}) {
    final Color textPrimary = isLight ? textPrimaryLight : textPrimaryDark;
    final Color textSecondary =
        isLight ? textSecondaryLight : textSecondaryDark;
    final Color textDisabled = isLight ? textDisabledLight : textDisabledDark;

    return TextTheme(
      // Display styles for large headings
      displayLarge: GoogleFonts.inter(
        fontSize: 57,
        fontWeight: FontWeight.w700,
        color: textPrimary,
        letterSpacing: -0.25,
        height: 1.12,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 45,
        fontWeight: FontWeight.w700,
        color: textPrimary,
        letterSpacing: 0,
        height: 1.16,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0,
        height: 1.22,
      ),

      // Headline styles for section headers
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0,
        height: 1.25,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0,
        height: 1.29,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0,
        height: 1.33,
      ),

      // Title styles for card headers and important text
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: textPrimary,
        letterSpacing: 0,
        height: 1.27,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textPrimary,
        letterSpacing: 0.15,
        height: 1.50,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textPrimary,
        letterSpacing: 0.1,
        height: 1.43,
      ),

      // Body styles for main content
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        letterSpacing: 0.5,
        height: 1.50,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        letterSpacing: 0.25,
        height: 1.43,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textSecondary,
        letterSpacing: 0.4,
        height: 1.33,
      ),

      // Label styles for buttons and small text
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textPrimary,
        letterSpacing: 0.1,
        height: 1.43,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textSecondary,
        letterSpacing: 0.5,
        height: 1.33,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: textDisabled,
        letterSpacing: 0.5,
        height: 1.45,
      ),
    );
  }

  /// Custom text styles for specialized use cases

  // GPS coordinate display using monospace font for precise alignment
  static TextStyle gpsCoordinateStyle({required bool isLight}) {
    return GoogleFonts.robotoMono(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: isLight ? textPrimaryLight : textPrimaryDark,
      letterSpacing: 0.5,
      height: 1.43,
    );
  }

  // Metadata labels for photo information
  static TextStyle metadataLabelStyle({required bool isLight}) {
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: isLight ? textSecondaryLight : textSecondaryDark,
      letterSpacing: 0.4,
      height: 1.33,
    );
  }

  // Timestamp display for photo capture time
  static TextStyle timestampStyle({required bool isLight}) {
    return GoogleFonts.robotoMono(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: isLight ? textSecondaryLight : textSecondaryDark,
      letterSpacing: 0.25,
      height: 1.33,
    );
  }

  // Status indicator text for GPS accuracy and system states
  static TextStyle statusIndicatorStyle(
      {required bool isLight, required Color color}) {
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: color,
      letterSpacing: 0.5,
      height: 1.33,
    );
  }
}
