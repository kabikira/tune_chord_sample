// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:resonance/src/manager/preferences_manager.dart';
import 'package:resonance/src/manager/sample_data_manager.dart';

part 'app_initialization_manager.g.dart';

/// アプリケーション初期化の結果
enum AppInitializationStatus { loading, firstLaunch, completed, error }

// TODO;もっとわかりやすく修正したい
/// アプリケーション初期化結果
class AppInitializationResult {
  final AppInitializationStatus status;
  final String? errorMessage;

  const AppInitializationResult({required this.status, this.errorMessage});

  factory AppInitializationResult.loading() =>
      const AppInitializationResult(status: AppInitializationStatus.loading);

  factory AppInitializationResult.firstLaunch() =>
      const AppInitializationResult(
        status: AppInitializationStatus.firstLaunch,
      );

  factory AppInitializationResult.completed() =>
      const AppInitializationResult(status: AppInitializationStatus.completed);

  factory AppInitializationResult.error(String message) =>
      AppInitializationResult(
        status: AppInitializationStatus.error,
        errorMessage: message,
      );
}

/// アプリケーション初期化を管理するNotifier
@riverpod
class AppInitializationNotifier extends _$AppInitializationNotifier {
  @override
  Future<AppInitializationResult> build() async {
    try {
      // PreferencesManagerを取得
      final preferencesManager = await ref.read(
        preferencesManagerProvider.future,
      );

      // 初回起動判定
      if (preferencesManager.isFirstLaunch) {
        // サンプルデータを挿入
        final sampleDataManager = ref.read(sampleDataManagerProvider);
        await sampleDataManager.insertSampleData();

        // 初回起動フラグを更新
        await preferencesManager.setFirstLaunchCompleted();

        return AppInitializationResult.firstLaunch();
      }

      return AppInitializationResult.completed();
    } catch (e) {
      return AppInitializationResult.error(e.toString());
    }
  }

  /// 初期化を再実行（開発・テスト用）
  Future<void> reinitialize() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }

  /// 初回起動フラグをリセットして再初期化（開発・テスト用）
  Future<void> resetAndReinitialize() async {
    try {
      final preferencesManager = await ref.read(
        preferencesManagerProvider.future,
      );
      await preferencesManager.resetFirstLaunchFlag();
      await reinitialize();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
