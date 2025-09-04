// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:chord_fracture/src/config/chord_fracture_colors.dart';

/// アプリケーションのテーマを管理するクラス
///
/// ResonanceColorsを使用してMaterial 3対応のテーマを生成し、
/// アプリ全体で統一されたデザインシステムを提供します。
class AppTheme {
  AppTheme._();

  /// Resonanceカラーパレットを使用したライトテーマ
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: ChordFractureColors.primary,
      brightness: Brightness.light,
      primary: ChordFractureColors.primary,
      secondary: ChordFractureColors.secondary,
      error: ChordFractureColors.error,
      surface: ChordFractureColors.offWhite,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFFF2F4F8),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 3,
        surfaceTintColor: const Color(0xFFFEFEFE),
        color: const Color(0xFFFEFEFE),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        shadowColor: Colors.black.withValues(alpha: 0.08),
      ),

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xFFFEFEFE),
        foregroundColor: Color(0xFF2C2C2C),
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2C2C2C),
        ),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ChordFractureColors.primary,
          foregroundColor: ChordFractureColors.offWhite,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ChordFractureColors.primary,
          side: BorderSide(
            color: ChordFractureColors.primary.withValues(alpha: 0.8),
            width: 1.5,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ChordFractureColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
      ),

      // Input Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF7F8FC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: ChordFractureColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: ChordFractureColors.error, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: ChordFractureColors.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        hintStyle: TextStyle(
          color: const Color(0xFF2C2C2C).withValues(alpha: 0.5),
          fontSize: 15,
        ),
      ),

      // Text Theme
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2C2C2C),
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2C2C2C),
        ),
        bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF2C2C2C)),
        bodyMedium: TextStyle(fontSize: 15, color: Color(0xFF2C2C2C)),
        bodySmall: TextStyle(fontSize: 13, color: Color(0xFF6E6E6E)),
      ),

      // Icon Theme
      iconTheme: IconThemeData(color: ChordFractureColors.primary, size: 24),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: Colors.grey.withValues(alpha: 0.15),
        thickness: 1,
        space: 1,
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: ChordFractureColors.accent,
        foregroundColor: ChordFractureColors.offWhite,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: ChordFractureColors.primary,
        linearTrackColor: ChordFractureColors.primary.withValues(alpha: 0.2),
        circularTrackColor: ChordFractureColors.primary.withValues(alpha: 0.2),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: ChordFractureColors.secondary.withValues(alpha: 0.1),
        selectedColor: ChordFractureColors.secondary,
        labelStyle: TextStyle(color: ChordFractureColors.secondary),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: ChordFractureColors.offWhite,
        selectedItemColor: ChordFractureColors.primary,
        unselectedItemColor: const Color(0xFF6E6E6E),
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// Resonanceカラーパレットを使用したダークテーマ（1a202c背景）
  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: ChordFractureColors.primary,
      brightness: Brightness.dark,
      primary: ChordFractureColors.primary,
      secondary: ChordFractureColors.secondary,
      error: ChordFractureColors.error,
      surface: ChordFractureColors.background,
      onSurface: ChordFractureColors.offWhite.withValues(alpha: 0.9),
      onPrimary: ChordFractureColors.offWhite,
      onSecondary: ChordFractureColors.offWhite,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: ChordFractureColors.background,

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 6,
        surfaceTintColor: ChordFractureColors.offWhite.withValues(alpha: 0.08),
        color: ChordFractureColors.offWhite.withValues(alpha: 0.08),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        shadowColor: Colors.black.withValues(alpha: 0.4),
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: ChordFractureColors.background,
        foregroundColor: ChordFractureColors.offWhite.withValues(alpha: 0.9),
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: ChordFractureColors.offWhite.withValues(alpha: 0.9),
        ),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ChordFractureColors.primary,
          foregroundColor: ChordFractureColors.offWhite,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ChordFractureColors.primary,
          side: BorderSide(
            color: ChordFractureColors.primary.withValues(alpha: 0.8),
            width: 1.5,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ChordFractureColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
      ),

      // Input Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ChordFractureColors.offWhite.withValues(alpha: 0.12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: ChordFractureColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: ChordFractureColors.error, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: ChordFractureColors.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        hintStyle: TextStyle(
          color: ChordFractureColors.offWhite.withValues(alpha: 0.6),
          fontSize: 15,
        ),
      ),

      // Text Theme
      textTheme: TextTheme(
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: ChordFractureColors.offWhite.withValues(alpha: 0.9),
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: ChordFractureColors.offWhite.withValues(alpha: 0.9),
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: ChordFractureColors.offWhite.withValues(alpha: 0.9),
        ),
        bodyMedium: TextStyle(
          fontSize: 15,
          color: ChordFractureColors.offWhite.withValues(alpha: 0.9),
        ),
        bodySmall: TextStyle(
          fontSize: 13,
          color: ChordFractureColors.offWhite.withValues(alpha: 0.7),
        ),
      ),

      // Icon Theme
      iconTheme: IconThemeData(color: ChordFractureColors.primary, size: 24),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: ChordFractureColors.offWhite.withValues(alpha: 0.2),
        thickness: 1,
        space: 1,
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: ChordFractureColors.accent,
        foregroundColor: ChordFractureColors.offWhite,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: ChordFractureColors.primary,
        linearTrackColor: ChordFractureColors.primary.withValues(alpha: 0.3),
        circularTrackColor: ChordFractureColors.primary.withValues(alpha: 0.3),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: ChordFractureColors.secondary.withValues(alpha: 0.2),
        selectedColor: ChordFractureColors.secondary,
        labelStyle: TextStyle(
          color: ChordFractureColors.offWhite.withValues(alpha: 0.9),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: ChordFractureColors.background.withValues(alpha: 0.95),
        selectedItemColor: ChordFractureColors.primary,
        unselectedItemColor: ChordFractureColors.offWhite.withValues(
          alpha: 0.6,
        ),
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

/// ギター弦用の特別なカラースキーム（ウィジェット用）
class GuitarStringTheme {
  GuitarStringTheme._();

  static const Map<int, Color> stringColors = {
    0: ChordFractureColors.highE, // High E (1弦)
    1: ChordFractureColors.b, // B (2弦)
    2: ChordFractureColors.g, // G (3弦)
    3: ChordFractureColors.d, // D (4弦)
    4: ChordFractureColors.a, // A (5弦)
    5: ChordFractureColors.lowE, // Low E (6弦)
  };

  /// 弦のインデックスに対応するカラーを取得
  static Color getStringColor(int stringIndex) {
    return stringColors[stringIndex] ?? ChordFractureColors.primary;
  }

  /// 弦カラーの薄い版（背景用）
  static Color getStringBackgroundColor(int stringIndex) {
    return getStringColor(stringIndex).withValues(alpha: 0.1);
  }

  /// 弦カラーの濃い版（境界線用）
  static Color getStringBorderColor(int stringIndex) {
    return getStringColor(stringIndex).withValues(alpha: 0.3);
  }
}

/// テーマユーティリティメソッド
class AppThemeUtils {
  AppThemeUtils._();

  /// グラデーション背景を生成（スプラッシュ画面用）
  static LinearGradient createGradientBackground({
    Color? topColor,
    Color? bottomColor,
    double topOpacity = 0.05,
  }) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        (topColor ?? ChordFractureColors.primary).withValues(alpha: topOpacity),
        bottomColor ?? ChordFractureColors.offWhite,
      ],
    );
  }

  /// カラーの透明度バリエーションを生成
  static Map<String, Color> createColorVariations(Color baseColor) {
    return {
      'full': baseColor,
      'high': baseColor.withValues(alpha: 0.8),
      'medium': baseColor.withValues(alpha: 0.5),
      'low': baseColor.withValues(alpha: 0.2),
      'subtle': baseColor.withValues(alpha: 0.1),
    };
  }
}
