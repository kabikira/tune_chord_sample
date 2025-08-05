// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:resonance/src/manager/preferences_manager.dart';

part 'left_handed_provider.g.dart';

/// 左利き設定の状態管理
@riverpod
class LeftHandedNotifier extends _$LeftHandedNotifier {
  @override
  Future<bool> build() async {
    // PreferencesManagerから左利き設定を読み込み
    final preferencesManager = await ref.read(preferencesManagerProvider.future);
    return preferencesManager.isLeftHanded;
  }

  /// 左利き設定を変更して永続化
  Future<void> setLeftHanded(bool isLeftHanded) async {
    final preferencesManager = await ref.read(preferencesManagerProvider.future);
    await preferencesManager.setLeftHanded(isLeftHanded);
    
    // 状態を更新
    state = AsyncValue.data(isLeftHanded);
  }

  /// 左利き設定をトグル
  Future<void> toggleLeftHanded() async {
    final current = state.value ?? false;
    await setLeftHanded(!current);
  }
}