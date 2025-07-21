// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_provider.g.dart';

/// テーマモード（ライト/ダーク）の状態管理
@riverpod
class ThemeModeNotifier extends _$ThemeModeNotifier {
  static const String _themeKey = 'theme_mode';

  @override
  Future<ThemeMode> build() async {
    // SharedPreferencesから保存されたテーマモードを読み込み
    final prefs = await SharedPreferences.getInstance();
    final savedThemeIndex = prefs.getInt(_themeKey);
    
    if (savedThemeIndex != null) {
      return ThemeMode.values[savedThemeIndex];
    }
    
    // デフォルトはシステムテーマに従う
    return ThemeMode.system;
  }

  /// テーマモードを変更して永続化
  Future<void> setThemeMode(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, themeMode.index);
    
    // 状態を更新
    state = AsyncValue.data(themeMode);
  }

  /// ダークモードかどうかを返す（システムテーマも考慮）
  bool isDarkMode(BuildContext context) {
    final currentMode = state.value ?? ThemeMode.system;
    switch (currentMode) {
      case ThemeMode.dark:
        return true;
      case ThemeMode.light:
        return false;
      case ThemeMode.system:
        return MediaQuery.of(context).platformBrightness == Brightness.dark;
    }
  }

  /// ダークモードをトグル
  Future<void> toggleDarkMode() async {
    final currentMode = state.value ?? ThemeMode.system;
    ThemeMode newMode;
    
    switch (currentMode) {
      case ThemeMode.light:
        newMode = ThemeMode.dark;
        break;
      case ThemeMode.dark:
        newMode = ThemeMode.light;
        break;
      case ThemeMode.system:
        // システムテーマの場合は明示的にライト/ダークを選択
        newMode = ThemeMode.dark;
        break;
    }
    
    await setThemeMode(newMode);
  }
}
