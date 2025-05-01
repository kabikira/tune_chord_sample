import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface.withOpacity(0.95),
      appBar: AppBar(
        title: const Text('設定'),
        elevation: 0,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // アプリ情報セクション
            _buildSectionHeader(context, 'アプリ情報'),
            const SizedBox(height: 8),
            _buildSettingsCard(
              context,
              children: [
                _buildSettingsItem(
                  context,
                  icon: Icons.info_outline,
                  title: 'アプリについて',
                  onTap: () {
                    // アプリ情報ダイアログを表示
                    _showAboutDialog(context);
                  },
                ),
                _buildDivider(),
                _buildSettingsItem(
                  context,
                  icon: Icons.update,
                  title: 'バージョン',
                  trailing: Text(
                    '1.0.0',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 外観設定セクション
            _buildSectionHeader(context, '外観設定'),
            const SizedBox(height: 8),
            _buildSettingsCard(
              context,
              children: [
                _buildSettingsItem(
                  context,
                  icon: Icons.dark_mode,
                  title: 'ダークモード',
                  trailing: Switch.adaptive(
                    value: false, // 実際の値は状態管理で制御
                    onChanged: (value) {
                      // ダークモード切り替え処理
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // データ管理セクション
            _buildSectionHeader(context, 'データ管理'),
            const SizedBox(height: 8),
            _buildSettingsCard(
              context,
              children: [
                _buildSettingsItem(
                  context,
                  icon: Icons.backup,
                  title: 'データのバックアップ',
                  onTap: () {
                    // バックアップ処理
                  },
                ),
                _buildDivider(),
                _buildSettingsItem(
                  context,
                  icon: Icons.restore,
                  title: 'データの復元',
                  onTap: () {
                    // 復元処理
                  },
                ),
                _buildDivider(),
                _buildSettingsItem(
                  context,
                  icon: Icons.delete_forever,
                  title: 'すべてのデータを削除',
                  titleColor: theme.colorScheme.error,
                  onTap: () {
                    // 削除確認ダイアログ
                    _showDeleteConfirmDialog(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // セクションヘッダーを構築
  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }

  // 設定カードを構築
  Widget _buildSettingsCard(
    BuildContext context, {
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(children: children),
    );
  }

  // 設定項目を構築
  Widget _buildSettingsItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    Color? titleColor,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: titleColor ?? theme.colorScheme.primary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(color: titleColor),
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  // 区切り線を構築
  Widget _buildDivider() {
    return const Divider(height: 1, indent: 56);
  }

  // アプリ情報ダイアログを表示
  void _showAboutDialog(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.music_note, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                const Text('アプリについて'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'コードフォーム管理アプリ',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '変則チューニングのためのギターコードフォーム管理アプリです。様々なチューニングでのコードフォームを記録・管理できます。',
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'バージョン: 1.0.0',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  '閉じる',
                  style: TextStyle(color: theme.colorScheme.primary),
                ),
              ),
            ],
          ),
    );
  }

  // データ削除確認ダイアログを表示
  void _showDeleteConfirmDialog(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('データを削除'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.error.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: theme.colorScheme.error.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: theme.colorScheme.error,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'すべてのチューニングとコードフォームデータを削除します',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'この操作は取り消せません。すべてのデータが完全に削除されます。',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'キャンセル',
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // データ削除処理
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.error,
                  foregroundColor: theme.colorScheme.onError,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('削除する'),
              ),
            ],
            actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          ),
    );
  }
}
