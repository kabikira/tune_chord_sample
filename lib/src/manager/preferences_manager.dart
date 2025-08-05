// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'preferences_manager.g.dart';

/// SharedPreferencesを管理するマネージャークラス
class PreferencesManager {
  static const String _isFirstLaunchKey = 'is_first_launch';
  
  final SharedPreferences _prefs;
  
  PreferencesManager(this._prefs);
  
  /// 初回起動かどうかを取得
  bool get isFirstLaunch => _prefs.getBool(_isFirstLaunchKey) ?? true;
  
  /// 初回起動フラグを設定
  Future<void> setFirstLaunchCompleted() async {
    await _prefs.setBool(_isFirstLaunchKey, false);
  }
  
  /// 初回起動フラグをリセット（開発・テスト用）
  Future<void> resetFirstLaunchFlag() async {
    await _prefs.remove(_isFirstLaunchKey);
  }
}

/// PreferencesManagerのプロバイダー
@riverpod
Future<PreferencesManager> preferencesManager(Ref ref) async {
  final prefs = await SharedPreferences.getInstance();
  return PreferencesManager(prefs);
}